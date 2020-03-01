export DEV_BUILD_DBG="Debug"
export DEV_BUILD_REL="RelWithDebInfo"
export DEV_CCLS_ROOT=".ccls-root"
export DEV_CCLS_CACHE=".ccls-cache"
export DEV_CCLS_BUILD_DIR=".build-ccls"
alias cat=bat
alias ls='exa  --group-directories-first'
alias fsk='sk --ansi -i -c '"'"'fd --type f "{}"'"'"''
alias gsk='sk --ansi -i -c '"'"'rg --color=always --line-number "{}"'"'"''
alias skvi='f(){ x="$(sk --bind "ctrl-p:toggle-preview" --ansi --preview="bat {} --color=always" --preview-window=right:60%:hidden)"; [[ $? -eq 0 ]] && nvim "$x" || true }; f'
prepcmake() {
    rm -rf $DEV_BUILD_DBG
}

cmakesetupdbg() {
    cmake -H. -B$DEV_BUILD_DBG -DCMAKE_BUILD_TYPE=$DEV_BUILD_DBG
}

proj-dbg() {
    prepcmake; cmakesetupdbg
}

cmakebuilddbg() {
    cmake --build $DEV_BUILD_DBG -- -j4
}

cmaketestdbg() {
    cmake --build $DEV_BUILD_DBG -- test
}

prep-ccls() {
    rm $DEV_CCLS_ROOT; rm -rf $DEV_CCLS_BUILD_DIR; rm -rf  $DEV_CCLS_CACHE
}

cmakesetupccls() {
    cmake -H. -B$DEV_CCLS_BUILD_DIR -DCMAKE_BUILD_TYPE=$DEV_BUILD_REL -DCMAKE_EXPORT_COMPILE_COMMANDS=1
}

proj-ccls() {
    export DEV_CCLS_INIT="{ \"cache\": { \"directory\": \"$DEV_CCLS_CACHE\" }, \"compilationDatabaseDirectory\": \"$DEV_CCLS_BUILD_DIR\" }"; prep-ccls; cmakesetupccls && touch $DEV_CCLS_ROOT && ccls --index=$PWD --init=$DEV_CCLS_INIT; unset DEV_CCLS_INIT
}

#alias skvs='f(){ x="$(sk --bind "ctrl-p:toggle-preview" --ansi --preview="bat {} --color=always" --preview-window=right:60%:hidden)"; [[ $? -eq 0 ]] && code :w "$x" || true }; f'
#alias cc='/opt/rh/devtoolset-2/root/usr/bin/cc'
#alias gcc='/opt/rh/devtoolset-2/root/usr/bin/gcc'
#alias c++='/opt/rh/devtoolset-2/root/usr/bin/c++'
#alias g++='/opt/rh/devtoolset-2/root/usr/bin/g++'
