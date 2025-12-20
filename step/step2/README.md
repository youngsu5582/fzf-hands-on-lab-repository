## fzf 사용해보기

사용 방법 및 옵션을 먼저 사용하고 하나씩 설명하는 식으로 진행한다.

```shell
git log -g refs/stash --pretty=format:'%gd%x09%cr%x09%s' | fzf
```

기존 명령어에 `| fzf` 를 추가후 실행해보자.

- `|` : 앞 명령어의 출력을 뒤 명령어의 입력으로 넘겨주는 파이프라인

```shell
git log -g refs/stash --pretty=format:'%gd%x09%cr%x09%s' \
  | fzf --prompt="Stash 를 선택해주세요" --header="Stash ID    |  Stash 된 시간    | Message"  \
    --layout="reverse"
```

- `--prompt` : 입력 프롬프트 문자열을 지정해, 검색창 앞에 문자열을 표시
- `--header` : 결과 리스트 상단에 고정된 헤더 한 줄을 출력해 각 칼럼의 의미를 표시
- `--layout="reverse"` : 입력을 아래서부터가 아닌, 위에서 부터 입력하게 변경

```shell
git log -g refs/stash --pretty=format:'%gd%x09%cr%x09%s' \
  | fzf --prompt="Stash 를 선택해주세요" --header="Stash ID    |  Stash 된 시간    | Message" \
    --layout="reverse" \
    --preview="
        echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
        echo '📋 Stash: {1}'
        echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
        echo
        echo '📊 Statistics:'
        git stash show {1} --stat --color=always        
    "
```

- `--preview` : 왼쪽에 선택한 요소를 `{1}` 를 전달받아 명령어를 실행해 미리보기를 렌더링

```shell
fzf-git-stash() {
  local selected_stash
  selected_stash=$(git log -g refs/stash \
      --pretty=format:'%gd%x09%cr%x09%s' \
      | fzf --reverse \
          --prompt="Select Stash > " \
          --header="Stash ID    |  Stash 된 시간    | Message" \
          --delimiter='\t' \
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

선택하면, 전체 문장을 가져온다.
`cut -f1`, `cut -f3` 을 통해서 Stash ID 와 Message 만 추출한다.

---

아래는 fzf 를 통해

- 이모지를 검색후 출력

```shell
emoji() {
  emojis=$(curl -sSL 'https://git.io/JXXO7')
  selected_emoji=$(echo $emojis | fzf)
  echo $selected_emoji
}
```

- 현재 디렉토리부터, 하위 디렉토리를 재귀 검색후 이동한다

```shell
fd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}
```

속도가 궁금하다면 `cd ~` 후, 수많은 파일에서도 자기가 원하는 요소를 찾을수 있는지 실험해보자.