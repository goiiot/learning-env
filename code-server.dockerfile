# codercom/code-server is based on ubuntu18.10
FROM codercom/code-server:latest AS CODESRV
# golang
FROM golang:stretch as GO
# vscode
FROM ubuntu:18.04 AS VSCODE

RUN apt-get update ;\
	apt-get install -y curl ;\
	curl -o vscode-amd64.deb -L https://vscode-update.azurewebsites.net/latest/linux-deb-x64/stable ;\
	dpkg -i vscode-amd64.deb || true ;\
	apt-get install -y -f ;\
	# VSCode missing deps
	apt-get install -y libx11-xcb1 libasound2

# install plugins to /root/.vscode/extensions
COPY vscode-plugins.sh /install-plugins.sh
RUN /install-plugins.sh

#
# Final Image
#
FROM ubuntu:18.04

# Install essential tools and libs
RUN apt-get update -qq; \
    apt-get install -y \
        net-tools iputils-ping wget gnupg2 xz-utils \
        build-essential nodejs npm clang \
        python3-pip python-pip \
        tmux htop git curl cmake zip unzip \
        openssh-server openssl locales ; \
    locale-gen en_US.UTF-8 ;\
    \
    # cleanup
    rm -rf /var/lib/apt/lists;

ENV LANG=en_US.UTF-8

RUN sed -i -E 's/(security|archive).ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list

# Install go and required plugins
ENV GOPATH /go
ENV GOROOT /usr/local/go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
COPY --from=GO /usr/local/go /usr/local/go
RUN set -e ;\
    go get -u -v github.com/ramya-rao-a/go-outline ;\
    go get -u -v github.com/acroca/go-symbols ;\
    go get -u -v github.com/nsf/gocode ;\
    go get -u -v github.com/rogpeppe/godef ;\
    go get -u -v golang.org/x/tools/cmd/godoc ;\
    go get -u -v github.com/zmb3/gogetdoc ;\
    go get -u -v golang.org/x/lint/golint ;\
    go get -u -v github.com/fatih/gomodifytags ;\
    go get -u -v github.com/uudashr/gopkgs/cmd/gopkgs ;\
    go get -u -v golang.org/x/tools/cmd/gorename ;\
    go get -u -v sourcegraph.com/sqs/goreturns ;\
    go get -u -v github.com/cweill/gotests/... ;\
    go get -u -v golang.org/x/tools/cmd/guru ;\
    go get -u -v github.com/josharian/impl ;\
    go get -u -v github.com/haya14busa/goplay/cmd/goplay ;\
    go get -u -v github.com/davidrjenni/reftools/cmd/fillstruct

# Install code-server and extensions
COPY --from=CODESRV /usr/local/bin/code-server /usr/local/bin/code-server
COPY --from=VSCODE /root/.vscode/extensions /root/.code-server/extensions

EXPOSE 8443
WORKDIR /root/project
ENTRYPOINT [ "/usr/local/bin/code-server" ]
