#!/bin/zsh

RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
NO_COLOR="\033[0m"

CUSTOM_DIR=~/.dshell
PROJECT_NAME="dshell"

print $BLUE "Fetching updates for $PROJECT_NAME from remote..." $NO_COLOR
git -C $CUSTOM_DIR fetch &> /dev/null
CHANGE_LOG=$(curl -sSf https://raw.githubusercontent.com/DominikHorn/$PROJECT_NAME/master/update.sh &> /dev/null \
             && git -C $CUSTOM_DIR log --no-decorate --no-merges --pretty="format:%s" ..origin/master \
                | awk '{printf "    %d. %s\n", NR, $0}')

# Exit early if network down
if [[ ! $? == 0 ]];
then
   print $RED "Network appears to be down, can not fetch updates from remote" $NO_COLOR
   exit -1
fi

if [[ -z $CHANGE_LOG ]];
then 
   print $BLUE "Already up to date" $NO_COLOR
   exit 0
else
  git -C $CUSTOM_DIR add -A
  git -C $CUSTOM_DIR stash &> /dev/null
  git -C $CUSTOM_DIR checkout origin/master &> /dev/null
fi

# Actually install updates
print $BLUE "Installing updates..."
zsh -c $CUSTOM_DIR/install.sh &> /dev/null

cat <<-'EOF'

          _____                    _____                    _____                    _____                    _____            _____  
         /\    \                  /\    \                  /\    \                  /\    \                  /\    \          /\    \ 
        /::\    \                /::\    \                /::\____\                /::\    \                /::\____\        /::\____\
       /::::\    \              /::::\    \              /:::/    /               /::::\    \              /:::/    /       /:::/    /
      /::::::\    \            /::::::\    \            /:::/    /               /::::::\    \            /:::/    /       /:::/    / 
     /:::/\:::\    \          /:::/\:::\    \          /:::/    /               /:::/\:::\    \          /:::/    /       /:::/    /  
    /:::/  \:::\    \        /:::/__\:::\    \        /:::/____/               /:::/__\:::\    \        /:::/    /       /:::/    /   
   /:::/    \:::\    \       \:::\   \:::\    \      /::::\    \              /::::\   \:::\    \      /:::/    /       /:::/    /    
  /:::/    / \:::\    \    ___\:::\   \:::\    \    /::::::\    \   _____    /::::::\   \:::\    \    /:::/    /       /:::/    /     
 /:::/    /   \:::\ ___\  /\   \:::\   \:::\    \  /:::/\:::\    \ /\    \  /:::/\:::\   \:::\    \  /:::/    /       /:::/    /      
/:::/____/     \:::|    |/::\   \:::\   \:::\____\/:::/  \:::\    /::\____\/:::/__\:::\   \:::\____\/:::/____/       /:::/____/       
\:::\    \     /:::|____|\:::\   \:::\   \::/    /\::/    \:::\  /:::/    /\:::\   \:::\   \::/    /\:::\    \       \:::\    \       
 \:::\    \   /:::/    /  \:::\   \:::\   \/____/  \/____/ \:::\/:::/    /  \:::\   \:::\   \/____/  \:::\    \       \:::\    \      
  \:::\    \ /:::/    /    \:::\   \:::\    \               \::::::/    /    \:::\   \:::\    \       \:::\    \       \:::\    \     
   \:::\    /:::/    /      \:::\   \:::\____\               \::::/    /      \:::\   \:::\____\       \:::\    \       \:::\    \    
    \:::\  /:::/    /        \:::\  /:::/    /               /:::/    /        \:::\   \::/    /        \:::\    \       \:::\    \   
     \:::\/:::/    /          \:::\/:::/    /               /:::/    /          \:::\   \/____/          \:::\    \       \:::\    \  
      \::::::/    /            \::::::/    /               /:::/    /            \:::\    \               \:::\    \       \:::\    \ 
       \::::/    /              \::::/    /               /:::/    /              \:::\____\               \:::\____\       \:::\____\
        \::/____/                \::/    /                \::/    /                \::/    /                \::/    /        \::/    /
         ~~                       \/____/                  \/____/                  \/____/                  \/____/          \/____/ 

EOF

# Print change log
print $BLUE "Find the changelog bellow:" $NO_COLOR
print $CHANGE_LOG
