## 터미널 환경에 익숙해지기 

### Hello World

가장 기본적인 편집기 vi 로 함수를 작성해보자.

```shell
vi hello-world.zsh
```

를 통해 hello-world.zsh 라는 파일 편집을 시작한다.

그 후, `a` 키를 눌러 편집모드로 전환한다.

```shell
hello-world() {
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
input-name() {
  read -p "이름을 입력해주세요. : " name
  echo "이름은 $name 입니다."
}
```

### cut

```shell
cut-line() {
    local line
    line="스태시 ID\t스태시 생성일\t메시지"
    id=$(echo "$line" | cut -f1)

    echo "$id"
}
```

`\t` 구분자를 기반으로 줄을 자른다.
'스태시 ID' 를 출력한다.

### case(switch)

```shell
case-command() {
  echo "명령어를 입력해주세요 (a)pply, (p)op, (d)rop: "
  read -r command
  command=${command:0:1}
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

> zsh 를 사용한다면 read -k1 을 사용하자.
> `read -k1` 은 한 문자만 입력받고 바로 종료한다. (단축키 처리시 유용)

- case 구문은 `case 변수 in` - `입력값)` - `esac` 로 구성된다.