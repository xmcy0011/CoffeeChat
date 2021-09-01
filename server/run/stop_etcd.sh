#!/bin/sh

ETCD_BIN=/data/etcd

stop(){
    if [ ! -f ${ETCD_BIN}/etcd.pid ];then
        echo "进程不存在"
        exit 0
    fi

    pid=$(cat ${ETCD_BIN}/etcd.pid)

    if ps -p ${pid} > /dev/null; then
        echo "kill $1 pid=$pid"
        kill ${pid}
    else
        echo "pid=$pid not exist"
    fi

    ps -ef | grep etcd
    rm -rf ${ETCD_BIN}/etcd.pid

    echo "stop etcd success"
}

stop