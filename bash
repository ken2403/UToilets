# ターミナルのプロンプトにGit情報を常に表示させる
function join_by { local IFS="$1"; shift; echo "$*"; }
function _ps1_git_username {
local git_users_array=`git config --global --get-all user.name`
git_users=`join_by , $git_users_array`
test "$git_users" == 'ken2403' && echo '🏋️‍♂️ ' && return
test "$git_users" && echo "$git_users" && return
echo "No Git User"
}
# PS1 is the variable for the prompt you see everytime you hit enter
git_prompt_script=/usr/local/etc/bash_completion.d/git-prompt.sh
if [ -s $git_prompt_script ]; then
# if git-prompt is installed, use it (ie. to install it use:
# `brew install git`)
source $git_prompt_script
source /usr/local/etc/bash_completion.d/git-completion.bash
export GIT_PS1_SHOWDIRTYSTATE=true
export PS1='\[\e[0;31m\]\W\[\e[0;32m\] ($(_ps1_git_username "(%s)")$(__git_ps1 ":%s")) \[\e[0m\]:$ '
else
# otherwise omit git from the prompt
export PS1="$ColorRed\W$ColorReset :$ "
fi
# Colors ls should use for folders, files, symlinks etc, see `man ls` and
# search for LSCOLORS
export LSCOLORS=ExGxFxdxCxDxDxaccxaeex

# Load git completions
git_completion_script=/usr/local/etc/bash_completion.d/git-completion.bash
test -s $git_completion_script && source $git_completion_script
# A more colorful prompt
# \[\e[0m\] resets the color to default color
ColorReset='\[\e[0m\]'
# \e[0;31m\ sets the color to red
ColorRed='\[\e[0;31m\]'
# \e[0;32m\ sets the color to green
ColorGreen='\[\e[0;32m\]'ß