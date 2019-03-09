###################################################################################################
#                                                                                                 #
#                                                                                                 #
#                                      Stage - code-server                                        #
#                                                                                                 #
#                                                                                                 #
###################################################################################################

FROM codercom/code-server:latest AS CODESRV

###################################################################################################
#                                                                                                 #
#                                                                                                 #
#                                         Stage - golang                                          #
#                                                                                                 #
#                                                                                                 #
###################################################################################################

FROM golang:stretch as GO

###################################################################################################
#                                                                                                 #
#                                                                                                 #
#                                         Stage - vscode                                          #
#                                                                                                 #
#                                                                                                 #
###################################################################################################

FROM ubuntu:18.04 AS VSCODE
WORKDIR /root
ENV PLUGIN_LIST="shd101wyy.markdown-preview-enhanced \
    ms-python.python \
    alefragnani.Bookmarks \
    eamodio.gitlens \
    christian-kohler.npm-intellisense \
    christian-kohler.path-intellisense \
    quicktype.quicktype \
    Shan.code-settings-sync \
    wwm.better-align \
    formulahendry.auto-close-tag \
    formulahendry.auto-rename-tag \
    formulahendry.code-runner \
    HookyQR.beautify \
    Rubymaniac.vscode-paste-and-indent \
    konstantin.wrapSelection \
    robertohuertasm.vscode-icons \
    steoates.autoimport \
    naumovs.color-highlight \
    vincaslt.highlight-matching-tag \
    mkloubert.vscode-remote-workspace \
    cssho.vscode-svgviewer \
    zhuangtongfa.Material-theme \
    yzhang.markdown-all-in-one \
    esbenp.prettier-vscode \
    redhat.java \
    truman.autocomplate-shell \
    ms-vscode.Go \
    itryapitsin.Scala \
    mathiasfrohlich.Kotlin \
    twxs.cmake"

RUN apt-get update ;\
	apt-get install -y curl ;\
	curl -o vscode-amd64.deb -L https://vscode-update.azurewebsites.net/latest/linux-deb-x64/stable ;\
	dpkg -i vscode-amd64.deb || true ;\
	apt-get install -y -f ;\
	# VSCode missing deps
	apt-get install -y libx11-xcb1 libasound2 jq

RUN for p in $PLUGIN_LIST; do \
        code --user-data-dir /root/.config/Code --install-extension $p ;\
    done ;\
    \
    # download offline vsix to /root/vsix
    mkdir -p /root/vsix ;\
    #
    # prepare vscode-cpptools.vsix for manaul offline installation
    curl -o /root/vsix/vscode-cpptools.vsix -L \
        "$(curl -sL https://api.github.com/repos/Microsoft/vscode-cpptools/releases/latest \
            | jq -r '.assets[].browser_download_url' \
            | grep linux.vsix)"

###################################################################################################
#                                                                                                 #
#                                                                                                 #
#                                         Final Image                                             #
#                                                                                                 #
#                                                                                                 #
###################################################################################################

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
    # gocode with gomodule support
    go get -u github.com/stamblerre/gocode ;\
    mv /go/bin/gocode /go/bin/gocode-gomod ;\
    \
    # gocode without gomodule support
    go get -u github.com/mdempsky/gocode ;\
    \
    go get -u github.com/uudashr/gopkgs/cmd/gopkgs ;\
    go get -u github.com/ramya-rao-a/go-outline ;\
    go get -u github.com/acroca/go-symbols ;\
    go get -u golang.org/x/tools/cmd/guru ;\
    go get -u golang.org/x/tools/cmd/gorename ;\
    go get -u github.com/fatih/gomodifytags ;\
    go get -u github.com/haya14busa/goplay/cmd/goplay ;\
    go get -u github.com/josharian/impl ;\
    go get -u github.com/tylerb/gotype-live ;\
    go get -u github.com/rogpeppe/godef ;\
    go get -u github.com/zmb3/gogetdoc ;\
    go get -u golang.org/x/tools/cmd/goimports ;\
    go get -u github.com/sqs/goreturns ;\
    go get -u winterdrache.de/goformat/goformat ;\
    go get -u golang.org/x/lint/golint ;\
    go get -u github.com/cweill/gotests/... ;\
    go get -u github.com/alecthomas/gometalinter ;\
    go get -u honnef.co/go/tools/... ;\
    go get -u github.com/golangci/golangci-lint/cmd/golangci-lint ;\
    go get -u github.com/mgechev/revive ;\
    go get -u github.com/go-delve/delve/cmd/dlv ;\
    go get -u github.com/davidrjenni/reftools/cmd/fillstruct ;\
    go get -u github.com/godoctor/godoctor

# Install code-server and extensions
COPY --from=CODESRV /usr/local/bin/code-server /usr/local/bin/code-server
COPY --from=VSCODE /root/.vscode/extensions /root/.code-server/extensions
COPY --from=VSCODE /root/vsix/ /root/vsix/

EXPOSE 8443
WORKDIR /root/project
ENTRYPOINT [ "/usr/local/bin/code-server" ]
