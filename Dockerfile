FROM golang:stretch as GO

# Actual learning-env
FROM ubuntu:18.04

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

# Install go
COPY --from=GO /usr/local/go /usr/local/go

# RUN sed -i -E 's/(security|archive).ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list

RUN apt-get update -qq; \
    apt-get install -y build-essential vim tmux htop nodejs npm git; \
    rm -rf /var/lib/apt/lists;

# Install some utils
RUN go get github.com/cjbassi/gotop; \
    npm install -g tldr;

WORKDIR /root

ENTRYPOINT [ "/bin/bash" ]
