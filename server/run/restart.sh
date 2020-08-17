#!/bin/sh
CUR_DIR=`pwd`

print_help(){
  echo "Usage: "
  echo "  ./restart.sh (im_gate|im_logic|im_http)"
  echo "  ./restart.sh all"
}

stop(){
  cd ${CUR_DIR}/$1
  files=$(ls *.toml 2> /dev/null | wc -l)
  if [[ "$files" == "0" ]] ;then
    #if [[ ! -e "*.toml" ]] ;then
    echo "no config file"
    echo $(pwd)
    cd ..
    return
  fi

  if [[ -f server.pid ]]; then
    pid=$(cat server.pid)
    
    # 先检测进程是否真的存在
    if ps -p ${pid} > /dev/null; then
      echo "kill $1 pid=$pid"
      kill ${pid}
    else
      echo "pid=$pid not exist"
    fi
  fi
}

start(){
  cd ${CUR_DIR}/$1
  files=$(ls *.toml 2> /dev/null | wc -l)
  if [[ "$files" == "0" ]] ;then
    #if [[ ! -e "*.toml" ]] ;then
    echo "no config file"
    cd ..
    return
  fi

  ./daemon $1 $2

  sleep 2
  ps aux|grep `cat server.pid`
}

restart(){
  stop $1
  start $1 conf=$2
}

case $1 in
  im_gate)
    restart $1 im_gate.conf
    ;;
  im_logic)
    restart $1 im_logic.conf
    ;;
  im_http)
    restart $1 im_http.conf
    ;;
  all)
    restart im_logic im_logic.conf
    sleep 2
    restart im_gate im_gate.conf
    sleep 2
    restart im_http im_http.conf
    ;;
  *)
    print_help
    ;;
esac
