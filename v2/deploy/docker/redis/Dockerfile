# 基础镜像
FROM redis:6.2.6

LABEL maintainer="xmcy0011<xmcy0011@sina.com>"

# 将自定义conf文件拷入
COPY redis.conf /usr/local/etc/redis/redis.conf

#修复时区
#RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
#    echo 'Asia/Shanghai' >/etc/timezone && \
#    # 修改文件权限,使之可以通过config rewrite重写
#    chmod 777 /usr/local/etc/redis/redis.conf

# 以下2项redis基础镜像都有了，故不需要开放了。可以使用docker inspect <image_name>确认
# EXPOSE 6379
# VOLUME [ "/data" ]

# 使用自定义conf启动
CMD [ "redis-server", "/usr/local/etc/redis/redis.conf" ]
# CMD [ "/bin/sh" ]