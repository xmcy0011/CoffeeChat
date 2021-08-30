#!/bin/sh

#
# 单节点的ETCD安装脚本，安装到/data/etcd/目录下
#

ETCD_VER=v3.5.0
ETCD_BIN=/data/etcd

GITHUB_URL=https://github.com/etcd-io/etcd/releases/download
FILE_URL=${DOWNLOAD_URL}/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz
TEMP_FILE_PATH=/${ETCD_BIN}/etcd-${ETCD_VER}-linux-amd64.tar.gz

download_etcd(){
    DOWNLOAD_URL=${GITHUB_URL}
    rm -f TEMP_FILE_PATH
    rm -rf $ETCD_BIN
    mkdir -p $ETCD_BIN

    curl -L ${FILE_URL} -o ${TEMP_FILE_PATH}

    if [ ! -f ${TEMP_FILE_PATH} ]; then
        echo "error"
        exit 0
    fi
}

install_etcd(){
    tar xzvf ${TEMP_FILE_PATH} -C $ETCD_BIN --strip-components=1
    rm -rf ${TEMP_FILE_PATH}
}

echo "download etcd"
download_etcd

echo "3s later will install etcd..."
sleep 3
install_etcd

echo "success install to ${ETCD_BIN}"