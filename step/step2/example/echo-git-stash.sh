echo-git-stash() {
  local stash_list
  stash_list=$(git stash list --pretty=format:$'%gd\t%cr\t%s')

  echo "stash 정보를 출력합니다"
  echo "$stash_list"

  local stash stash_id
  stash=$(echo "$stash_list" | head -n1)

  stash_id=$(echo "$stash" | cut -f1)

  echo
  echo "가장 첫번째 Stash 의 ID 및 변경된 파일"
  echo "$stash_id"
  git stash show -p "$stash_id" --color=always
}