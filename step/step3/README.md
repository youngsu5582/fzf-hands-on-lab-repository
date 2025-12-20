## fzf 사용해보기

사용 방법 및 옵션을 먼저 사용하고 하나씩 설명하는 식으로 진행한다.

```shell
git stash list --pretty=format:$'%gd\t%cr\t%s' | fzf --layout="reverse"
```

- `|` : 앞 명령어의 출력을 뒤 명령어의 입력으로 넘겨주는 파이프라인
- `--layout="reverse"` : 입력을 아래서부터가 아닌, 위에서 부터 입력하게 변경

```shell
git stash list --pretty=format:$'%gd\t%cr\t%s' \
  | fzf --layout="reverse" --prompt="Stash 를 선택해주세요" --header="Stash ID    |  Stash 된 시간    | Message"
```

- `--prompt` : 입력 프롬프트 문자열을 지정해, 검색창 앞에 문자열을 표시
- `--header` : 결과 리스트 상단에 고정된 헤더 한 줄을 출력해 각 칼럼의 의미를 표시

```shell
git stash list --pretty=format:$'%gd\t%cr\t%s' \
  | fzf --prompt="Stash 를 선택해주세요" --header="Stash ID    |  Stash 된 시간    | Message" \
    --layout="reverse" \
    --preview="git stash show -p {1} --color=always"
```

- `--preview` : 파싱된 요소 `{1}`(Stash@{0}) 을 기반으로 명령어를 실행해 미리보기를 렌더링

```shell
fzf-git-stash() {
  local stash_list
  stash_list=$(git stash list --pretty=format:$'%gd\t%cr\t%s')

  local selected_stash
  selected_stash=$(echo "$stash_list" \
      | fzf --reverse \
          --prompt="Select Stash > " \
          --header="Stash ID    |  Stash 된 시간    | Message" \
          --preview="git stash show -p {1} --color=always")

  local stash_id message
  stash_id=$(echo "$selected_stash" | cut -f1)
  message=$(echo "$selected_stash" | cut -f3)

  echo
  echo "선택된 Stash 의 ID 및 메시지"
  echo "$stash_id"
}
```

fzf 를 통해 입력받은 문장을 파싱해서 로직에서 사용할 수 있다.
