fzf-git-stash() {
  local stash_list
  stash_list=$(git stash list --pretty=format:$'%gd\t%cr\t%s')

  local selected_stash
  selected_stash=$(echo "$stash_list" \
      | fzf --layout="reverse" \
          --prompt="Select Stash > " \
          --header="Stash ID     |    Time Ago          | Message" \
          --preview="git stash show -p {1}")

  local stash_id
  stash_id=$(echo "$selected_stash" | cut -f1)

  echo
  echo "선택된 Stash 의 ID"
  echo "$stash_id"
}