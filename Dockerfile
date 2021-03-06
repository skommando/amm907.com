# 先用14，如果报错了就换10
# FROM node:10
FROM node:14
MAINTAINER amm907,skommandoamm@gmail.com
ARG github_mail=489289314@qq.com
ARG github_user=skommando

# 设置 npm 为国内源
RUN npm config set registry https://registry.npm.taobao.org

# 安装 hexo
RUN npm install hexo-cli -g

# 配置 Github
RUN git config --global user.email "${github_mail}"
RUN git config --global user.name "${github_user}"

# 定义工作目录
ENV HEXODIR /hexo
VOLUME $HEXODIR
WORKDIR $HEXODIR

# 暴露服务端口
EXPOSE 4000

CMD ["/usr/local/bin/hexo", "help"]
