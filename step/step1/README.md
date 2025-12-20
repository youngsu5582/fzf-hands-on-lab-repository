## 터미널 환경에 익숙해지기 

### Hello World

가장 기본적인 편집기 vi 로 함수를 작성해보자.

```shell
vi hello-world.zsh
```

를 통해 hello-world.zsh 라는 파일 편집을 시작한다.

그 후, `a` 키를 눌러 편집모드로 전환한다.

```shell
function hello-world() {
  echo "Hello World!"
}
```

echo 는 프로그래밍 언어의 'System.out.println', 'printf', 'console.log' 
와 같은 출력을 해주는 명령어이다.

함수를 작성했으면

1. Esc 입력
2. `Shift + :` 입력
3. `wq` 입력
4. Enter 입력

> Esc 는 

현재, 터미널 세션에 불러오기 위해

```shell
source ./hello-world.zsh
```

를 입력

### Input

```shell
function input-name() {
  read -p "이름을 입력해주세요. : " name
  echo "이름은 $name 입니다."
}
```

### if, elif, else

```shell
function if-score() {
  read -p "숫자를 입력하세요 : " score
  if [ "$score" -ge 100 ]; then
    echo "100점 이상"
  elif [ "$score" -ge 50 ]; then
    echo "100점 이하 50점 이상"
  else
    echo "50점 이하"
  fi
}
```

read 를 통해 변수에 값을 읽은 후,
if - elif - else 형식으로 if 구문을 작성한다.
fi 를 통해 무조건 if 문의 종료를 명시해줘야 한다!!

### case(switch)

```shell
function command_switch() {
  read -n 1 -p "명령어를 입력해주세요 (a)pply, (p)op, (d)rop: " command
  echo
  case "$command" in
    a|A)
      echo "apply 가 선택되었습니다"
      ;;
    p|P)
      echo "pop 가 선택되었습니다"
      ;;
    d|D)
      echo "drop 이 선택되었습니다"
      ;;
    *)
      echo "아무것도 선택되지 않았습니다"
  esac
}
```

- `read -n 1` 구문을 통해 문자 하나만 입력을 받는다.

> zsh 를 사용한다면 read -k1 을 사용하자.
> `read -k1` 은 한 문자만 입력받고 바로 종료한다. (단축키 처리시 유용)

- case 구문은 `case 변수 in` - `입력값)` - `esac` 로 구성된다.

### cli 실행

> 해당 실습 전, setup-stash 를 실행하고 해야한다.

함수 내부에서도 우리가 터미널에 입력하고 사용하는 명령어들을 포함할 수 있다. 

```shell
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
```

- `git log -g refs/stash --pretty=format:'%gd%x09%cr%x09%s'` : stash 정보를 가져와서 출력해준다.
  - `%gd` : 데코레이션된 reflog 이름 - `stash@{0}`
  - `%cr` : 상대적 커밋 시간 - `2 Hours ago`
  - `%s` : 커밋 메시지 - `WIP on branch...`
  - `%x09` : 탭 구분자의 아스키번호

```
  2 minutes ago	On main: 유틸리티 함수 리팩토링 진행 중
  2 minutes ago	On fix/login-bug: 로그인 null 체크 버그 수정 중
  2 minutes ago	On feature/api-endpoint: API 엔드포인트 추가 중
```

와 같이 나온다면 정상이다.

 
