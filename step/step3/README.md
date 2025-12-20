# fzf 를 활용한 git stash 명령어 만들기

step1, step2 를 조합해 우리가 원하는 기능을 만들어보자.

```shell
local stash_list
stash_list=$(git log -g refs/stash --pretty=format:'%gd%x09%cr%x09%s')
```

fzf 에 input 으로 받을 값을 변수에 저장하자.

```shell

```