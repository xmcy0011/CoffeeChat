#!/bin/sh

ETCD_BIN=/data/etcd
DATA_DIR=/tmp/etcd

start(){
    if [ -f ${ETCD_BIN}/etcd.pid ];then
        pid=$(cat ${ETCD_BIN}/etcd.pid)

        if [ "${pid}" = "" ] || [ ps -p ${pid} > /dev/null ]; then
            echo "invalid pid"
            rm -rf ${ETCD_BIN}/etcd.pid
        else
            echo "etcd already start"
            exit
        fi
    fi

    # listen-client-urls：监听
    # advertise-client-urls：作为客户端连接
    nohup ${ETCD_BIN}/etcd \
    -data-dir ${DATA_DIR} \
    –listen-client-urls http://0.0.0.0:2379 \
    -advertise-client-urls http://127.0.0.1:2379 \
    > ${ETCD_BIN}/etcd.out 2>&1 &

    pid=$(pidof etcd)
    echo ${pid} > ${ETCD_BIN}/etcd.pid

    ps -aux|grep etcd
    echo "start etcd success, 2s later will print log"

    sleep 2
    tail -n 10 ${ETCD_BIN}/etcd.out
}

start