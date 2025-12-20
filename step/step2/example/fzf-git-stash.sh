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