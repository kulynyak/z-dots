#!/bin/zsh

# Display the contents of .gitconfig file
alias cgc='cat ~/.gitconfig'

# Git commit browser with fzf support
unalias gl 2>/dev/null
gl() {
  # about: Show git log with graphical representation and fuzzy search capabilities
  git log --graph --color=always \
    --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
    fzf --ansi --no-sort --reverse --tiebreak=index --toggle-sort=\` \
      --bind "ctrl-m:execute:
                echo '{}' | grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R'"
}

command -v fzf &>/dev/null || return

isGitRepo() {
  # about: Function to check if the current directory is a Git repository
  # Try to get the git repository status
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    return 0 # Return true if inside a git repository
  else
    return 1 # Return false if not inside a git repository
  fi
}

fbx() {
  # about: Function to switch git branches with stash and unstash capability
  if ! isGitRepo; then
    # Check if the current directory is a git repository
    echo "Not a git repository"
    return
  fi

  local branchList nBranch nBranchName oBranchName stashName swCmd

  # Get the list of all branches
  branchList=$(git branch -a)

  # Get the current branch name
  oBranchName=$(echo "$branchList" | grep \* | sed 's/ *\* *//g')

  # Select the branch to switch to using fzf for fuzzy finding
  nBranch=$(echo "$branchList" | fzf-tmux -d30 -- -x --select-1 --exit-0 | sed 's/ *//')

  # Reset the prompt
  zle reset-prompt

  # If no branch was selected, return
  [[ -n "${nBranch}" ]] || return

  # Check if the selected branch is a remote tracking branch
  if [[ $nBranch =~ 'origin' ]]; then
    nBranchName=$(echo "$nBranch" | sed "s/.*origin\///")
    # Construct command to checkout a new local branch tracking the remote branch
    swCmd="git checkout -b $nBranchName $nBranch"
  else
    nBranchName=$(echo "$nBranch" | sed "s/.* //")
    # Command to checkout the local branch
    swCmd="git checkout $nBranchName"
  fi

  # If the selected branch is the same as the current branch, return
  [[ $nBranchName != $oBranchName ]] || return

  # Find the stash entry for the current branch, if it exists
  stashName=$(git stash list | grep -m 1 "On .*: ==${oBranchName}==" | sed -E "s/(stash@\{.*\}): .*/\1/g")

  # If a stash entry is found, drop it
  [[ -n "${stashName}" ]] && git stash drop "${stashName}"

  # Save the current changes to stash with a unique identifier
  git stash save "==${oBranchName}==" 2>/dev/null

  # Execute the branch switch command
  eval $swCmd

  # Find the stash entry for the target branch, if it exists
  stashName=$(git stash list | grep -m 1 "On .*: ==${nBranchName}==" | sed -E "s/(stash@\{.*\}): .*/\1/g")

  # Apply the stash entry for the target branch, if found
  [[ -n "${stashName}" ]] && git stash apply "${stashName}"

  # Reset the prompt again
  zle reset-prompt
}
zle -N fbx
bindkey '^x^b' fbx # checkout git branch + stash/unstash named changes (ctrl+x,ctrl+b)

fb() {
  # about: Function to switch git branches
  if ! isGitRepo; then
    # Check if the current directory is a git repository
    echo "Not a git repository"
    return
  fi

  local branches branch

  # Get the list of all branches
  branches=$(git branch -a)

  # Select the branch to switch to using fzf for fuzzy finding with an initial query
  branch=$(echo "$branches" | fzf-tmux -d30 -- -x --query="$*" --select-1 --exit-0 | sed 's/ *//')

  # Check if the selected branch is a remote tracking branch
  if [[ $branch =~ 'origin' ]]; then
    # Checkout a new local branch tracking the remote branch
    git checkout -b $(echo "$branch" | sed "s/.*origin\///") $branch
  else
    # Checkout the local branch
    git checkout $(echo "$branch" | sed "s/.* //")
  fi

  # Reset the prompt
  zle reset-prompt
}
zle -N fb
bindkey '^x^g' fb # checkout git branch (ctrl+x,ctrl+g)
