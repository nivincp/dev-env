export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

alias gicp="git log -1 --pretty=%s | pbcopy"

gdc() {
  local base=${1:-main}
  local branch=${2:-HEAD}
  git diff --no-color "$base...$branch" | pbcopy
  echo "Copied diff: $base...$branch"
}

clear_history() {
  unset HISTFILE
  print -n >! ~/.zsh_history
  export HISTFILE=~/.zsh_history
  fc -R
  echo "Zsh history fully reset."
}
