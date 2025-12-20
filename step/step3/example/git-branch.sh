#!/usr/bin/env bash

git-branch() {
  local branch_list branch action
  branch_list=$(git for-each-ref --sort=-committerdate refs/heads/ \
    --format='%(refname:short)%09%(committerdate:relative)%09%(authorname)%09%(subject)')

  branch=$(
    echo "$branch_list" |
      fzf --ansi --prompt="Switch to Branch > " \
          --header="BRANCH | LAST COMMIT | AUTHOR | SUBJECT" \
          --layout="reverse" \
          --delimiter=$'\t' \
          --with-nth=1,2,3,4 \
          --accept-nth=1 \
          --preview=$'
            line="━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo "$line"
            echo "🌿 Branch: {1}"
            echo "$line"
            echo
            echo "📊 Branch Info:"
            echo "  Last Commit: {2}"
            echo "  Author:      {3}"
            echo "  Message:     {4}"
            echo
            echo "$line"
            echo "📜 Recent Commits:"
            echo "$line"
            git log --color=always --oneline --graph --decorate -n 10 {1}
          ' \
          --preview-window=right:50%:wrap)
  printf "%s 가 선택되었습니다" branch

  printf '(c)heckout, (p)ull, (d)elete: '
  IFS= read -r action
  action=${action:0:1}
  case "$action" in
    c|C) git checkout "$branch" ;;
    p|P) git checkout "$branch" && git pull ;;
    d|D) git branch -D "$branch" ;;
    *)    echo "Cancelled" ;;
  esac
}