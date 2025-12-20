fzf-git-stash() {
  local stash_list
  stash_list=$(git stash list --pretty=format:$'%gd\t%cr\t%s')

  local selected_stash

  # fzf 옵션들을 하나씩 추가하자.
  # header, prompt, preview
  selected_stash=$(echo "$stash_list" \
      | fzf --layout="reverse")

  local stash_id
  stash_id=$(echo "$selected_stash" | cut -f1)

  echo
  echo "선택된 Stash 의 ID"
  echo "$stash_id"
}