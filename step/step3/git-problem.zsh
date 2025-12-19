# git branch 를 변경하기

# 1. 로컬에 존재하는 git branch 의 목록을 정보와 함께 가져온다. - 브랜치 명, 커밋한 시간, 작성자, 커밋 내용
# 아래 명령어를 사용할 것

# git for-each-ref --sort=-committerdate refs/heads/ \
#        --format='%(refname:short)%09%(committerdate:relative)%09%(authorname)%09%(subject)'

# 2. fzf 에 BRANCH, LAST COMMIT, AUTHOR, SUBJECT 라는 헤더와 함께 브랜치를 보여주고
# 오른쪽에는 git log graph 를 보여준다.

# 아래 명령어를 사용할 것
# git log --color=always --oneline --graph --decorate -n 10 {1}

# 3. 선택한 브랜치로 체크아웃 한다.

# (심화사항) c를 누르면 체크아웃, p를 누르면 pull, d를 누르면 삭제되게 한다.

