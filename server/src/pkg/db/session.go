/** @file session.go
 * @brief ref https://github.com/alberliu/goim/blob/master/public/session/session.go
 * @author CoffeeChat
 * @date 2019/9/19
 */

package db

import (
	"context"
	"database/sql"
	"fmt"
	_ "github.com/go-sql-driver/mysql"
	"time"
)

const beginStatus = 1
const kDriveName = "mysql"

type DatabaseConfig struct {
	ServerName string // 服务名，读/写分离

	Host string // 数据库的服务器ip地址
	Port int

	DbName     string // 数据库名
	Username   string // 连接数据库的用户名
	Password   string // 密码
	MaxConnCnt int    // 最大连接数
}

// Db对象接口，非单个连接
type Session interface {
	// 初始化数据库的连接
	Init(db DatabaseConfig) error

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

// mysql对象
type SessionMysql struct {
	DB           *sql.DB // 原生db(原生支持连接池)
	tx           *sql.Tx // 原生事务
	commitSign   int8    // 提交标记，控制是否提交事务
	rollbackSign bool    // 回滚标记，控制是否回滚事务

	config DatabaseConfig // 配置信息
}

// 获取一个Mysql连接
func NewSessionMysql() *SessionMysql {
	conn := new(SessionMysql)
	return conn
}

func (s *SessionMysql) Init(config DatabaseConfig) error {
	s.config = config

	// interpolateParams：解决sql注入的问题，启用后可使用'?'传参，否则报错
	dataSourceName := fmt.Sprintf("%s:%s@tcp(%s:%d)/%s?charset=utf8mb4&interpolateParams=true", config.Username,
		config.Password, config.Host, config.Port, config.DbName)
	db, err := sql.Open(kDriveName, dataSourceName)
	if err != nil {
		return err
	}

	// limit max connect count
	db.SetMaxOpenConns(config.MaxConnCnt)

	s.DB = db
	return nil
}

// check connect status(timeout 3s)
func (s *SessionMysql) Ping() error {
	ctx, _ := context.WithTimeout(context.Background(), time.Second*3)
	return s.DB.PingContext(ctx)
}

// Begin 开启事务
func (s *SessionMysql) Begin() error {
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
func (s *SessionMysql) Rollback() error {
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
func (s *SessionMysql) Commit() error {
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
func (s *SessionMysql) Exec(query string, args ...interface{}) (sql.Result, error) {
	if s.tx != nil {
		return s.tx.Exec(query, args...)
	}
	return s.DB.Exec(query, args...)
}

// QueryRow 如果已经开启事务，就以事务方式执行，如果没有开启事务，就以非事务方式执行
func (s *SessionMysql) QueryRow(query string, args ...interface{}) *sql.Row {
	if s.tx != nil {
		return s.tx.QueryRow(query, args...)
	}
	return s.DB.QueryRow(query, args...)
}

// Query 查询数据，如果已经开启事务，就以事务方式执行，如果没有开启事务，就以非事务方式执行
func (s *SessionMysql) Query(query string, args ...interface{}) (*sql.Rows, error) {
	if s.tx != nil {
		return s.tx.Query(query, args...)
	}
	return s.DB.Query(query, args...)
}

// Prepare 预执行，如果已经开启事务，就以事务方式执行，如果没有开启事务，就以非事务方式执行
func (s *SessionMysql) Prepare(query string) (*sql.Stmt, error) {
	if s.tx != nil {
		return s.tx.Prepare(query)
	}
	return s.DB.Prepare(query)
}
