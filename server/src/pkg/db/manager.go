package db

const kDbMasterName = "Master"
const kDbSlaveName = "Slave"

type Manager struct {
	dbList map[string]Session // db连接集合
}

var DefaultManager = &Manager{}

func init() {
	DefaultManager.dbList = make(map[string]Session)
}

func (d *Manager) Init(server []DatabaseConfig) error {
	for i := 0; i < len(server); i++ {
		session := NewSessionMysql()
		err := session.Init(server[i])
		if err != nil {
			return err
		}
		// insert to dbList
		d.dbList[server[i].ServerName] = session
	}

	return nil
}

func (d *Manager) UnInt() {
	// close all connect
	for key := range d.dbList {
		session := d.dbList[key]
		db, ok := session.(*SessionMysql)
		if ok {
			_ = db.DB.Close()
		}
	}
}

// 获取主Db对象，优先写
func (d *Manager) GetDbMaster() Session {
	session, ok := d.dbList[kDbMasterName]
	if ok {
		return session
	}
	return nil
}

// 获取从Db对象，优先读
func (d *Manager) GetDBSlave() Session {
	session, ok := d.dbList[kDbSlaveName]
	if ok {
		return session
	}
	return nil
}
