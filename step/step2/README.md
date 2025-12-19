## FZF Step2. FZF 옵션

> 옵션을 사용하다가 모르겠으면, `man fzf` 를 입력해보자.
> 정말 자세하게 설명해준다.

`find . | fzf` 를 실행해보자.

```sh
find . | fzf
```

폴더 내 존재하는 파일 목록들을 받아서 fzf 가 실행된다.
단순 선택하면, 선택한 파일 목록이 출력된다.

### preview

```sh
find . | fzf --preview='cat {1}'
```

오른쪽에 선택된 요소를 통해 미리보기를 보여준다.

- `find . | fzf --preview='file {1}'`
- `find . | fzf --preview='ls -al {1}'`
- `find . | fzf --preview='stat {1}'`

만약, 자기 화면에서 조금 잘리는거 같다면?

```shell
find . | fzf --preview-window=down:50% --preview='stat {1}'
```

```shell
find . | fzf --preview-window=right:50% --preview='stat {1}'
```

등 `preview-window` 를 설정하자.
- left,right,down,up 다 가능

`--layout=reverse` 옵션은 입력창, 결과 목록을 화면 위쪽에 배치 시켜주는 옵션 

### query

fzf 를 사용할 때 대부분이 특정 검색어를 사용한다면

```shell
find . | fzf --query='music' --preview='cat {1}'
```

query 옵션을 사용하면, 해당 키워드를 기반으로 fzf 가 실행된다.

### --with-nth

`/api/v1/users	POST,PUT	com.example.UserController	{}`

이와같은 라인이 있을때, `/api/v1/users`, `com.example.UserController` 로만 검색을 하고 싶은데
`POST,PUT` 을 출력하고 싶다면?

```shell
cat ./endpoints.txt | fzf --with-nth=1,3 --delimiter='\t' \
    --header="END_POINT | HANDLER" \
    --accept-nth=2
```

- with-nth : 입력 요소 중 1,3 번만 선택
- delimiter : 입력 데이터의 필드 구분자를 지정
- header : 각 필드 위에 표시될 헤더 지정
- accept-nth : 입력 받은 요소중 2번만 선택

HTTP METHOD 가 나온다.