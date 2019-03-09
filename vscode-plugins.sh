PLUGIN_LIST="shd101wyy.markdown-preview-enhanced \
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
    ms-vscode.cpptools \
    itryapitsin.Scala \
    mathiasfrohlich.Kotlin \
    PeterJausovec.vscode-docker \
    twxs.cmake"

for p in $PLUGIN_LIST; do
  code --user-data-dir /root/.config/Code --install-extension $p
done
