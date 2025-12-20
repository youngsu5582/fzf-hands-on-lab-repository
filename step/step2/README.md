## 스크립트에서 CLI 사용해보기

### cli 실행

> 해당 실습 전, setup-stash 를 실행하고 해야한다.

함수 내부에서도 우리가 터미널에 입력하고 사용하는 명령어들을 포함할 수 있다.

```shell
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
```

- `git stash list --pretty=format:$'%gd\t%cr\t%s'` : stash 정보를 가져와서 출력해준다.
    - `%gd` : 데코레이션된 reflog 이름 - `stash@{0}`
    - `%cr` : 상대적 커밋 시간 - `2 Hours ago`
    - `%s` : 커밋 메시지 - `WIP on branch...`
    - `\t` : 탭 구분자

- head : 라인중 

- cut : 탭 구분자(\t) 을 기준으로 줄을 분리한다.


```
stash@{1}	3 days ago	On perf/optimize-queries: 데이터베이스 쿼리 최적화 작업 중
stash@{2}	3 days ago	On main: 유틸리티 함수 리팩토링 진행 중
stash@{3}	3 days ago	On fix/login-bug: 로그인 null 체크 버그 수정 중
stash@{4}	3 days ago	On feature/api-endpoint: API 엔드포인트 추가 중
stash@{5}	3 days ago	On main: 사용자 인증 기능 구현 중
stash@{6}	3 days ago	On feature/api-endpoint: API 엔드포인트 추가 중
...

가장 첫번째 Stash 의 ID 및 메시지
stash@{0}
WIP on main: 840ca2d stash 추가
```

와 같이 나온다면 정상이다.
 
