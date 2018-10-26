FROM golang:stretch as GO

# Actual learning-env
FROM ubuntu:18.04

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

# Install go
COPY --from=GO /usr/local/go /usr/local/go

WORKDIR /root

# Build and install neovim
COPY --chown=root:root nvim-vimrc /root/.config/nvim/init.vim
ENV NEOVIM_VERSION 0.3.1
RUN apt-get update -qq; \
    apt-get install -y \
        git ninja-build gettext libtool libtool-bin autoconf \
        automake cmake g++ pkg-config unzip wget curl; \
    \
    git clone --depth 1 -b v${NEOVIM_VERSION} \
        https://github.com/neovim/neovim.git; \
    cd neovim; make; make install; cd ..; \
    rm -rf neovim .wget-hsts; \
    \
    ln -s /usr/local/bin/nvim /usr/local/bin/vim; \
    nvim +'PlugInstall --sync' +qall &> /dev/null; \
    \
    apt-get autoremove --purge -y \
        git ninja-build gettext libtool libtool-bin autoconf \
        automake cmake g++ pkg-config unzip wget curl; \
    rm -rf /var/lib/apt/lists;

# Install essential tools
RUN apt-get update -qq; \
    apt-get install -y \
        net-tools iputils-ping \
        build-essential nodejs npm clang \
        python3-pip python-pip \
        tmux htop git curl cmake zip unzip \
        openssh-server ; \
    rm -rf /var/lib/apt/lists;

COPY --chown=root:root sshd_config /etc/ssh/sshd_config

# Install some utils
ENV BAT_VERSION 0.8.0
ENV BAT_URL https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat_${BAT_VERSION}_amd64.deb
RUN go get -u github.com/cjbassi/gotop; \
    go get -u github.com/mdempsky/gocode; \
    npm install -g tldr; tldr --update; \
    npm install -g tern; \
    pip3 install neovim; \
    curl -fsSL ${BAT_URL} -o bat.deb; dpkg -i bat.deb; \
    \
    rm -rf bat.deb .cache .npm;

# Fix sshd problem
RUN mkdir -p /var/run/sshd; \
    ln -s /var/run/sshd /run/sshd;

# make sure ssh user will have valid path environment
RUN echo "" >> /etc/profile; \
    echo "export PATH=${PATH}" >> /etc/profile; \
    echo "export GOPATH=${GOPATH}" >> /etc/profile;

RUN sed -i -E 's/(security|archive).ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list

# copy examples
COPY --chown=root:root examples /root/examples

EXPOSE 22
COPY --chown=root:root entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]

ONBUILD COPY --chown=root:root id_rsa.pub /root/.ssh/authorized_keys
ONBUILD RUN chmod 400 /root/.ssh/authorized_keys
