function git-stash-log() {
  echo "stash 정보를 출력합니다"

  local stash_list
  stash_list=$(git log -g refs/stash --pretty=format:'%gd%x09%cr%x09%s')
  echo "$stash_list"

  local number
  number=0

  echo "stash $number 의 통계"
  echo $(git stash show stash@{$number} --stat --color=always)

  echo "stash $number 의 변경된 파일"
  echo $(git stash show stash@{$number} --color=always)
}
