export BPS_DEV_CC="/opt/rh/devtoolset-2/root/usr/bin/gcc"
export BPS_DEV_CXX="/opt/rh/devtoolset-2/root/usr/bin/g++"
export PATH="/opt/rh/sclo-git212/root/usr/bin:$PATH"
export VORAK_BOX_USERNAME="phillip.bonhomme"
export VORAK_BOX_ADDR="35.235.101.45"
alias ssh-vorak="ssh $VORAK_BOX_USERNAME@$VORAK_BOX_ADDR"
alias gdb='/opt/rh/devtoolset-8/root/usr/bin/gdb'

rsync-vorak() {
    rsync -v -a ssh $1 $VORAK_BOX_USERNAME@$VORAK_BOX_ADDR:/home/$VORAK_BOX_USERNAME/rsync.here
}

svnaddtxt() {
    for var in $@
    do
        svn add ${var}; svn propset svn:mime-type text/plain ${var} && svn propset svn:eol-style native ${var} && svn propset svn:keywords 'Author Date Id Revision URL Header' ${var}
    done
}

svnst() {
    svn status -q
}

svnup() {
    svn up && svn up
}

svnbranchname() {
    svn info | grep '^URL:' | egrep -o '(branches\/phillip)/[^/]+|trunk' | egrep -o '[^/]+$'
}

runbpsdbg() {
    export BPS_BRANCH_NAME=svnbranchname; export BPS_DEV_LOCAL_BUILD=$PWD/$DEV_BUILD_DBG; $BPS_DEV_LOCAL_BUILD/Install/BluePearlCLI -output results.${BPS_BRANCH_NAME}-64 -verbosity 3 -tcl $1 -e "BPS::run analyze -forceload" -e exit -noexitontclerror; unset BPS_DEV_LOCAL_BUILD; unset BPS_BRANCH_NAME
}


cmakesetupdbg() {
    scl enable devtoolset-2 'cmake -H. -B$DEV_BUILD_DBG -DCMAKE_BUILD_TYPE=$DEV_BUILD_DBG'
}

bps-proj-dbg() {
    scl enable devtoolset-2 'prepcmake; cmakesetupdbg'
}

bps-cmakesetupccls() {
    scl enable devtoolset-2 'cmake -H. -B$DEV_CCLS_BUILD_DIR -DCMAKE_BUILD_TYPE=$DEV_BUILD_REL -DCMAKE_EXPORT_COMPILE_COMMANDS=1'
}

bps-proj-ccls() {
    export DEV_CCLS_INIT="{ \"cache\": { \"directory\": \"$DEV_CCLS_CACHE\" }, \"compilationDatabaseDirectory\": \"$DEV_CCLS_BUILD_DIR\" }"; prep-ccls; bps-cmakesetupccls && touch $DEV_CCLS_ROOT && ccls --index=$PWD --init=$DEV_CCLS_INIT; unset DEV_CCLS_INIT
}

# runbpsunittest() {
#     ./$1 --gtest-filter=*$2
# }
