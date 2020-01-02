#!/bin/sh
CUR_DIR=`pwd`

print_help(){
  echo "Usage: "
  echo "  ./stop.sh (im_gate|im_logic)"
  echo "  ./stop.sh all"
}

stop(){
  cd $1
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
    echo "kill $1 pid=$pid"
    kill "${pid}"
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

  ./daemon im_$1 $2
}

case $1 in
  gate)
    stop $1
    start $1 conf=im_gate.conf
    ;;
  logic)
    stop $1
    start $1 conf=im_logic.conf
    ;;
  *)
    print_help
    ;;
esac