#/bin/sh

print_help(){
  echo "Usage: "
  echo "  ./stop.sh (im_gate|im_logic|im_http)"
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
  *)
    print_help
    ;;
esac
