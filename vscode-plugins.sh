PLUGIN_LIST="shd101wyy.markdown-preview-enhanced \
    ms-python.python \
    alefragnani.Bookmarks \
    eamodio.gitlens \
    ritwickdey.LiveServer \
    christian-kohler.npm-intellisense \
    quicktype.quicktype \
    christian-kohler.path-intellisense \
    humao.rest-client \
    Shan.code-settings-sync \
    wwm.better-align \
    formulahendry.auto-close-tag \
    formulahendry.auto-rename-tag \
    HookyQR.beautify \
    Rubymaniac.vscode-paste-and-indent \
    konstantin.wrapSelection \
    robertohuertasm.vscode-icons \
    steoates.autoimport \
    formulahendry.code-runner \
    naumovs.color-highlight \
    vincaslt.highlight-matching-tag \
    mkloubert.vscode-remote-workspace \
    sozercan.slack \
    cssho.vscode-svgviewer \
    zhuangtongfa.Material-theme \
    yzhang.markdown-all-in-one \
    esbenp.prettier-vscode \
    dbaeumer.vscode-eslint \
    eg2.tslint \
    mgmcdermott.vscode-language-babel \
    redhat.java \
    truman.autocomplate-shell \
    ms-vscode.Go \
    pranaygp.vscode-css-peek \
    ms-vscode.cpptools \
    itryapitsin.Scala \
    mathiasfrohlich.Kotlin \
    PeterJausovec.vscode-docker \
    twxs.cmake \
    vsciot-vscode.vscode-arduino \
    MS-vsliveshare.vsliveshare \
    KnisterPeter.vscode-github"

for p in $PLUGIN_LIST; do
  code --user-data-dir /root/.config/Code --install-extension $p
done
