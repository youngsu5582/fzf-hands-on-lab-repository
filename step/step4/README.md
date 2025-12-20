# fzf 를 활용한 git stash 명령어 만들기

기존에 우리가 작성했던 `fzf-git-stash.sh` 에서 기능을 확장 시켜 나가자.

```shell
git-stash() {
  local stash_list
  stash_list=$(git log -g refs/stash --pretty=format:'%gd%x09%cr%x09%s')

  local selected_stash
  selected_stash=$(echo "$stash_list" \
      | fzf --reverse \
          --prompt="Select Stash > " \
          --header="Time Ago          | Message" \
          --delimiter='\t' \
          --with-nth=2,3 \
          --preview="
              echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
              echo '📋 Stash: {1}'
              echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
              echo
              echo '📊 Statistics:'
              git stash show {1} --stat --color=always
              echo
              echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
              echo '🔍 Detailed Changes:'
              echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
              git stash show -p {1} --color=always
          " \
          --preview-window=right:50%:wrap)

  local stash_id message
  stash_id=$(echo "$selected_stash" | cut -f1)
  message=$(echo "$selected_stash" | cut -f3)

  echo "$stash_id ($message) 가 선택되었습니다!"
}
```

우리가 실제로 필요한 기능을 추가하자.
action 에 값을 입력 받으면
그 값을 기반으로

- `git stash apply`
- `git stash pop`
- `git stash drop`

이 실행되게 만들자.

```shell
echo "(a)pply, (p)op, (d)rop "
IFS= read -r action
action=${action:0:1}
echo
case "$action" in
  a|A) git stash apply "$stash_id" ;;
  p|P) git stash pop "$stash_id" ;;
  d|D) git stash drop "$stash_id" ;;
  *)   echo "Cancelled." ;;
esac
```

이를 응용해서 브랜치를
checkout, pull, drop 하는 명령어도 완성시켜보자.

```shell
git-branch() {
  local branch_list branch
  branch_list=$(git branch --sort=-committerdate \
  --format=$'%(refname:short)\t%(committerdate:relative)\t%(authorname)\t%(subject)')

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
  echo "$branch 가 선택되었습니다"
}
```

```shell
local action

echo '(c)heckout, (p)ull, (d)elete: '
IFS= read -r action
action=${action:0:1}
case "$action" in
c|C) git checkout "$branch" ;;
p|P) git checkout "$branch" && git pull ;;
d|D) git branch -D "$branch" ;;
*)    echo "Cancelled" ;;
esac
```

만 추가가 되면 끝이다!