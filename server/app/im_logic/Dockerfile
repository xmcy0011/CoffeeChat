# escape=\ 
# This dockerfile uses go build, then use the ubuntu run
# Version: 0.1
# Author: xmcy0011@sina.com
# Desc: 注意，编译镜像的上下文必须在server下（../../），否则会失败
#       example: docker build -t im_gate -f . ../../

##
## build
##

# Base image to use, this must be set as the first line
FROM golang:1.16-alpine as build

LABEL maintainer="xmcy0011<xmcy0011@sina.com>"

# 工作目录
WORKDIR /go/src/coffeechat

# 把当前所有文件 拷贝到上面的工作目录下（包括配置文件）
COPY . .

# 设置go代理，加快拉包速度
RUN go env -w GOPROXY=https://goproxy.io && \
    cd app/im_logic && \
    # 拉项目依赖
    go mod tidy && \
    # 编译程序
    go build

##
## deploy
##

FROM alpine
# 指定日志存储卷，当前工作目录下的Log文件
VOLUME [ "log" ]
COPY --from=build /go/src/coffeechat/app/im_logic /usr
CMD [ "/usr/im_logic", "--conf=/usr/logic-docker.toml" ]