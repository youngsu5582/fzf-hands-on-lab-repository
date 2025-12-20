git-stash() {
  local stash_list
  stash_list=$(git stash list --pretty=format:$'%gd\t%cr\t%s')

  local selected_stash
  selected_stash=$(echo "$stash_list" \
      | fzf --reverse \
          --layout="reverse" \
          --prompt="Select Stash > " \
          --header="Stash ID     |    Time Ago          | Message" \
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
          ")

  local stash_id message
  stash_id=$(echo "$selected_stash" | cut -f1)
  message=$(echo "$selected_stash" | cut -f3)

  echo "$stash_id ($message) 가 선택되었습니다!"

  # 선택된 stash_id 를 기반으로
  echo "(a)pply, (p)op, (d)rop 를 입력해주세요."
  # a를 입력 받으면, git stash apply 를 실행한다.
  # p를 입력 받으면, git stash pop 를 실행한다.
  # d를 입력 받으면, git stash drop 를 실행한다.
}