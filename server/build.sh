#!/bin/sh

# parameters
TARGET_DIR=coffeechat
CUR_DIR=$(pwd)

# 编译以守护进程启动工具
build_daemon(){
  echo "build daemon..."
  cd "$CUR_DIR" || exit
  go build -o app/daemon/daemon app/daemon/main.go
}

# 编译网关
build_gate(){
  echo "build gate..."
  cd "$CUR_DIR" || exit
  go build -o ${TARGET_DIR}/im_gate/im_gate app/im_gate/gate.go
  cp app/im_gate/gate-example.toml ${TARGET_DIR}/im_gate/im_gate.toml
  cp app/daemon/daemon ${TARGET_DIR}/im_gate/daemon
}

# 编译logic
build_logic(){
  echo "build logic..."
  cd "$CUR_DIR" || exit
  go build -o ${TARGET_DIR}/im_logic/im_logic app/im_logic/logic.go
  cp app/im_logic/logic-example.toml ${TARGET_DIR}/im_logic/im_logic.toml
  cp app/daemon/daemon ${TARGET_DIR}/im_logic/daemon
}

# 编译http_server
build_http(){
  echo "build http..."
  cd "$CUR_DIR" || exit
  go build -o ${TARGET_DIR}/im_http/im_http app/im_http/http.go
  cp app/im_http/http-example.toml ${TARGET_DIR}/im_http/im_http.toml
  cp app/daemon/daemon ${TARGET_DIR}/im_http/daemon
}

build_all(){
  rm -rf ${TARGET_DIR}/
  mkdir ${TARGET_DIR}/

  build_daemon
  build_gate
  build_logic
  build_http

  cp ../run/restart.sh ${TARGET_DIR}/restart.sh
  cp ../run/stop.sh ${TARGET_DIR}/stop.sh

  # 打包
  build_version=coffeechat.$1
  build_name=${build_version}.tar.gz
  tar -zcvf "${build_name}" ${TARGET_DIR}

  rm -rf ${TARGET_DIR}
}

clean(){
  rm -rf ${TARGET_DIR}/
}

print_help(){
  echo "Usage: "
  echo "  $0 clean -- clean all build"
  echo "  $0 version version_str -- build a version"
}

case $1 in
  clean)
    echo "clean all build..."
    clean
    ;;
  version)
    if [[ $# != 2 ]];then
      echo $#
      print_help
      exit
    fi

    echo "$2"
    echo "build..."
    build_all "$2"
    ;;
  *)
    print_help
    ;;
esac