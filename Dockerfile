FROM golang:stretch as GO

# Actual learning-env
FROM ubuntu:18.04

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

# Install go
COPY --from=GO /usr/local/go /usr/local/go

# RUN sed -i -E 's/(security|archive).ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list

RUN apt-get update -qq; \
    apt-get install -y \
        build-essential vim tmux htop nodejs npm git \
        openssh-server; \
    rm -rf /var/lib/apt/lists;

COPY --chown=root:root sshd_config /etc/ssh/sshd_config

# Install some utils
RUN go get github.com/cjbassi/gotop; \
    npm install -g tldr;

# Fix sshd problem
RUN mkdir -p /var/run/sshd; \
    ln -s /var/run/sshd /run/sshd;

# make sure ssh user will have valid path
RUN echo "" >> /etc/profile; \
    echo "export PATH=${PATH}" >> /etc/profile; \
    echo "export GOPATH=${GOPATH}" >> /etc/profile;

EXPOSE 22
WORKDIR /root
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]

ONBUILD COPY --chown=root:root id_rsa.pub /root/.ssh/authorized_keys
ONBUILD RUN chmod 400 /root/.ssh/authorized_keys
