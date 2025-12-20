# PR 선택 실습 가이드

GitHub Pull Request를 fzf로 선택하고 관리하는 방법을 배웁니다.

## 사전 준비

### 1. GitHub CLI 설치

```bash
# macOS
brew install gh

# Linux
sudo apt-get install gh

# Windows (WSL)
sudo apt-get install gh
```

### 2. GitHub 인증

```bash
gh auth login
```

화면 안내에 따라 인증을 완료하세요.

### 3. 실습용 PR 생성

```bash
./setup-pr.sh
```

이 스크립트는 다음과 같은 실습용 PR을 자동으로 생성합니다:
- 📚 문서 개선 PR
- ✨ 기능 추가 PR
- 🐛 버그 수정 PR
- 🎨 UI/UX 개선 PR

## fzf로 PR 선택하기

### 기본 PR 목록 보기

```bash
gh pr list
```

### fzf로 PR 선택

```bash
gh pr list | fzf
```

**단축키:**
- `Ctrl+R`: 명령어 히스토리에서 검색
- `Tab`: 여러 항목 선택
- `Enter`: 선택 확정

### PR 상세 보기

```bash
# 방법 1: 수동으로 번호 입력
gh pr view 123

# 방법 2: fzf로 선택 후 보기
gh pr view $(gh pr list | fzf | awk '{print $1}')
```

### PR 미리보기와 함께 선택

```bash
gh pr list | \
  fzf --preview 'gh pr view {1}' \
      --preview-window=right:60% \
      --border
```

**설명:**
- `--preview 'gh pr view {1}'`: 선택한 PR의 상세 내용을 미리보기
- `{1}`: 첫 번째 컬럼 (PR 번호)
- `--preview-window=right:60%`: 오른쪽에 60% 크기로 미리보기 표시

## 실용적인 PR 함수

### PR 선택하여 Checkout

```bash
function pr-checkout() {
  local pr_number=$(gh pr list | \
    fzf --preview 'gh pr view {1}' \
        --preview-window=right:60% \
        --header='Select PR to checkout' | \
    awk '{print $1}')

  if [ -n "$pr_number" ]; then
    gh pr checkout "$pr_number"
  fi
}
```

**사용:**
```bash
pr-checkout
```

### PR 선택하여 브라우저에서 열기

```bash
function pr-web() {
  local pr_number=$(gh pr list | \
    fzf --preview 'gh pr view {1}' \
        --preview-window=right:60% \
        --header='Select PR to open in browser' | \
    awk '{print $1}')

  if [ -n "$pr_number" ]; then
    gh pr view "$pr_number" --web
  fi
}
```

### PR 병합하기

```bash
function pr-merge() {
  local pr_number=$(gh pr list | \
    fzf --preview 'gh pr view {1}' \
        --preview-window=right:60% \
        --header='Select PR to merge' | \
    awk '{print $1}')

  if [ -n "$pr_number" ]; then
    echo "Merging PR #$pr_number..."
    gh pr merge "$pr_number" --merge
  fi
}
```

### 다중 작업 PR 선택

```bash
function pr-select() {
  local pr_number=$(gh pr list | \
    fzf --preview 'gh pr view {1}' \
        --preview-window=right:60% \
        --border=rounded \
        --header='Ctrl-O: Open | Ctrl-C: Checkout | Ctrl-M: Merge | Enter: View' \
        --bind='ctrl-o:execute(gh pr view {1} --web)+abort' \
        --bind='ctrl-c:execute(gh pr checkout {1})+abort' \
        --bind='ctrl-m:execute(gh pr merge {1} --merge)+abort' | \
    awk '{print $1}')

  if [ -n "$pr_number" ]; then
    gh pr view "$pr_number"
  fi
}
```

**키 바인딩:**
- `Enter`: PR 상세 보기
- `Ctrl-O`: 브라우저에서 열기
- `Ctrl-C`: Checkout
- `Ctrl-M`: Merge

## 고급 필터링

### 상태별 PR 보기

```bash
# Open PR만
gh pr list --state open | fzf --preview 'gh pr view {1}'

# Closed PR만
gh pr list --state closed | fzf --preview 'gh pr view {1}'

# Merged PR만
gh pr list --state merged | fzf --preview 'gh pr view {1}'
```

### 작성자별 PR 보기

```bash
gh pr list --author youngsu5582 | fzf --preview 'gh pr view {1}'
```

### 라벨별 PR 보기

```bash
gh pr list --label "bug" | fzf --preview 'gh pr view {1}'
gh pr list --label "feature" | fzf --preview 'gh pr view {1}'
```

## 실습 과제

### 과제 1: PR 탐색기
fzf를 사용해서 PR을 선택하고 브라우저에서 여는 함수를 만드세요.

<details>
<summary>정답 보기</summary>

```bash
function pr-explorer() {
  gh pr list | \
    fzf --preview 'gh pr view {1}' \
        --preview-window=right:60% \
        --bind='enter:execute(gh pr view {1} --web)'
}
```
</details>

### 과제 2: PR 리뷰어
PR을 선택하면 변경된 파일 목록을 보여주는 함수를 만드세요.

<details>
<summary>정답 보기</summary>

```bash
function pr-review() {
  local pr_number=$(gh pr list | \
    fzf --preview 'gh pr diff {1}' \
        --preview-window=right:70% | \
    awk '{print $1}')

  if [ -n "$pr_number" ]; then
    gh pr diff "$pr_number"
  fi
}
```
</details>

### 과제 3: PR 상태 대시보드
현재 저장소의 PR 상태를 한눈에 보는 함수를 만드세요.

<details>
<summary>정답 보기</summary>

```bash
function pr-dashboard() {
  echo "📊 PR Dashboard"
  echo ""
  echo "Open PRs:"
  gh pr list --state open | wc -l
  echo ""
  echo "Select a PR:"
  gh pr list | \
    fzf --preview 'gh pr view {1}' \
        --header='PR Dashboard - Select to view details'
}
```
</details>

## 팁과 트릭

### 1. 자주 사용하는 명령어를 alias로

```bash
# .zshrc 또는 .bashrc에 추가
alias prl='gh pr list | fzf --preview "gh pr view {1}"'
alias prc='gh pr checkout $(gh pr list | fzf | awk "{print \$1}")'
alias prv='gh pr view $(gh pr list | fzf | awk "{print \$1}")'
```

### 2. PR 템플릿과 함께 사용

```bash
function pr-create-with-template() {
  gh pr create --fill
}
```

### 3. Draft PR 필터링

```bash
gh pr list --draft | fzf --preview 'gh pr view {1}'
```

### 4. 내 PR만 보기

```bash
gh pr list --author @me | fzf --preview 'gh pr view {1}'
```

## 정리

이제 다음을 할 수 있습니다:
- ✅ gh CLI로 PR 관리
- ✅ fzf로 PR 빠르게 선택
- ✅ 미리보기로 PR 내용 확인
- ✅ 키 바인딩으로 빠른 작업
- ✅ 자신만의 PR 관리 함수 작성

## 다음 단계

- Docker 컨테이너 선택하기
- Kubernetes Pod 선택하기
- AWS 리소스 선택하기

모든 CLI 도구를 fzf와 결합할 수 있습니다! 🚀
