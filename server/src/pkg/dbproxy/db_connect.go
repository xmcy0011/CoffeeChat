package dbproxy

import "database/sql"

const beginStatus = 1

type DbServer struct {
	ServerIp   string // 数据库的服务器ip地址
	ServerPort int

	UserName string // 连接数据库的用户名
	Password string // 密码
	DbName   string // 数据库名
}

type DbConn interface {
	// 初始化数据库的连接
	Init(db DbServer) error

	// Begin 开启事务
	Begin() error

	// Rollback 回滚事务
	Rollback() error

	// Commit 提交事务
	Commit() error

	// Exec 执行sql语句，如果已经开启事务，就以事务方式执行，如果没有开启事务，就以非事务方式执行
	Exec(query string, args ...interface{}) (sql.Result, error)

	// QueryRow 如果已经开启事务，就以事务方式执行，如果没有开启事务，就以非事务方式执行
	QueryRow(query string, args ...interface{}) *sql.Row

	// Query 查询数据，如果已经开启事务，就以事务方式执行，如果没有开启事务，就以非事务方式执行
	Query(query string, args ...interface{}) (*sql.Rows, error)

	// Prepare 预执行，如果已经开启事务，就以事务方式执行，如果没有开启事务，就以非事务方式执行
	Prepare(query string) (*sql.Stmt, error)
}

// mysql连接
type DbConnMysql struct {
	DB           *sql.DB // 原生db
	tx           *sql.Tx // 原生事务
	commitSign   int8    // 提交标记，控制是否提交事务
	rollbackSign bool    // 回滚标记，控制是否回滚事务
}

// 获取一个Mysql连接
func NewDbConnMysql() *DbConnMysql {
	conn := new(DbConnMysql)
	return conn
}

// Begin 开启事务
func (s *DbConnMysql) Begin() error {
	s.rollbackSign = true
	if s.tx == nil {
		tx, err := s.DB.Begin()
		if err != nil {
			return err
		}
		s.tx = tx
		s.commitSign = beginStatus
		return nil
	}
	s.commitSign++
	return nil
}

// Rollback 回滚事务
func (s *DbConnMysql) Rollback() error {
	if s.tx != nil && s.rollbackSign == true {
		err := s.tx.Rollback()
		if err != nil {
			return err
		}
		s.tx = nil
		return nil
	}
	return nil
}

// Commit 提交事务
func (s *DbConnMysql) Commit() error {
	s.rollbackSign = false
	if s.tx != nil {
		if s.commitSign == beginStatus {
			err := s.tx.Commit()
			if err != nil {
				return err
			}
			s.tx = nil
			return nil
		} else {
			s.commitSign--
		}
		return nil
	}
	return nil
}

// Exec 执行sql语句，如果已经开启事务，就以事务方式执行，如果没有开启事务，就以非事务方式执行
func (s *DbConnMysql) Exec(query string, args ...interface{}) (sql.Result, error) {
	if s.tx != nil {
		return s.tx.Exec(query, args...)
	}
	return s.DB.Exec(query, args...)
}

// QueryRow 如果已经开启事务，就以事务方式执行，如果没有开启事务，就以非事务方式执行
func (s *DbConnMysql) QueryRow(query string, args ...interface{}) *sql.Row {
	if s.tx != nil {
		return s.tx.QueryRow(query, args...)
	}
	return s.DB.QueryRow(query, args...)
}

// Query 查询数据，如果已经开启事务，就以事务方式执行，如果没有开启事务，就以非事务方式执行
func (s *DbConnMysql) Query(query string, args ...interface{}) (*sql.Rows, error) {
	if s.tx != nil {
		return s.tx.Query(query, args...)
	}
	return s.DB.Query(query, args...)
}

// Prepare 预执行，如果已经开启事务，就以事务方式执行，如果没有开启事务，就以非事务方式执行
func (s *DbConnMysql) Prepare(query string) (*sql.Stmt, error) {
	if s.tx != nil {
		return s.tx.Prepare(query)
	}
	return s.DB.Prepare(query)
}
