#/bin/sh

cur=`pwd`

print_help(){
  echo "Usage: "
  echo "  ./stop.sh (im_gate|im_logic|im_http)"
  echo "  ./stop.sh all"
}

stop(){
  cd $cur/$1
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
  
  ps aux|grep `cat server.pid`
}

case $1 in
  im_gate)
    stop $1
    ;;
  im_logic)
    stop $1
    ;;
  im_http)
    stop $1
    ;;
  all)
    stop im_logic
    stop im_gate
    stop im_http
    ;;
  *)
    print_help
    ;;
esac
