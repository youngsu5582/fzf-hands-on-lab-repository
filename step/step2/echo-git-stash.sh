echo-git-stash() {
  local stash_list
  stash_list=$(git stash list --pretty=format:$'%gd\t%cr\t%s')

  echo "stash 정보를 출력합니다"
  echo "$stash_list"

  # head 명령어를 통해 첫번째 라인을 추출한다
  local stash

  # cut 명령어를 통해 %gd 를 자른다. (stash_id)
  local stash_id

  # 첫번째 Stash ID 출력 및 stash 보기
  echo
  echo "가장 첫번째 Stash 의 ID 및 변경된 파일"
}