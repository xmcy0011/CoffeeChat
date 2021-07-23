package model

type NickGenerateModel struct {
	Id       int
	GenKey   string // 类别，lastname_v1：姓氏，classical_v1：古典名字
	GenValue string // 值
}