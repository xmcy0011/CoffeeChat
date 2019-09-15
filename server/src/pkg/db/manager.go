package db

type DbManager struct {
	dbList map[string]Session // db连接集合
}

var DBM = &DbManager{}

func (d *DbManager) Init(server ServerConfig) error {

}

func (d *DbManager) UnInt()  {

}