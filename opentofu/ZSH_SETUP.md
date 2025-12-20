# Ubuntu 22.04 LTS에서 Zsh 설정하기

EC2 인스턴스에서 zsh와 fzf를 사용하기 위한 가이드입니다.

**OS:** Ubuntu 22.04 LTS
**사용자:** ubuntu

## 자동 설정 (EC2 생성 시)

`./scripts/create.sh`로 EC2 인스턴스를 생성하면 다음이 자동으로 설치됩니다:

- ✅ zsh
- ✅ fzf
- ✅ Oh My Zsh
- ✅ 기본 셸이 zsh로 변경

SSH 접속 후 바로 zsh 환경을 사용할 수 있습니다!

```bash
./scripts/connect.sh
# 접속 후 바로 zsh 사용 가능
```

## 수동 설정 (이미 생성된 인스턴스)

기존 인스턴스에서 zsh를 설정하려면:

### 방법 1: 스크립트 사용 (추천)

```bash
# EC2 인스턴스에 접속
./scripts/connect.sh

# setup 스크립트를 인스턴스로 복사
# (로컬 터미널에서 실행)
scp -i opentofu/fzf-lab-key.pem \
    opentofu/scripts/setup-zsh.sh \
    ubuntu@<인스턴스_IP>:~/

# 인스턴스에서 실행
ssh -i opentofu/fzf-lab-key.pem ubuntu@<인스턴스_IP>
chmod +x setup-zsh.sh
./setup-zsh.sh

# zsh 시작
exec zsh
```

### 방법 2: 수동 설치

```bash
# 1. SSH 접속
./scripts/connect.sh

# 2. zsh 설치
sudo apt-get update
sudo apt-get install -y zsh

# 3. Oh My Zsh 설치
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# 4. fzf 설치
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

# 5. 기본 셸 변경
sudo chsh -s /bin/zsh ubuntu

# 6. 로그아웃 후 다시 로그인
exit
./scripts/connect.sh
```

## fzf 설정 추가

zsh에서 fzf를 더 편리하게 사용하기 위한 설정을 추가할 수 있습니다.

`~/.zshrc` 파일에 추가:

```bash
# fzf 기본 옵션
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

# 숨김 파일도 검색에 포함
export FZF_DEFAULT_COMMAND='find . -type f'

# 디렉토리 색상 표시
export FZF_ALT_C_OPTS="--preview 'ls -la {}'"

# 파일 미리보기
export FZF_CTRL_T_OPTS="--preview 'cat {}' --preview-window=right:60%"
```

설정 적용:

```bash
source ~/.zshrc
```

## 단축키 (fzf)

zsh + fzf 환경에서 사용 가능한 기본 단축키:

- `Ctrl + R`: 명령어 히스토리 검색
- `Ctrl + T`: 파일 검색 (현재 디렉토리)
- `Alt + C` (또는 `Esc + C`): 디렉토리 이동

## 테스트

```bash
# fzf 버전 확인
fzf --version

# zsh 버전 확인
zsh --version

# 현재 셸 확인
echo $SHELL

# 명령어 히스토리 검색 테스트
# Ctrl+R 누르기

# 파일 검색 테스트
# Ctrl+T 누르기
```

## Oh My Zsh 테마 변경 (선택사항)

기본 테마는 `robbyrussell`입니다. 다른 테마를 사용하려면:

```bash
# .zshrc 편집
vim ~/.zshrc

# ZSH_THEME 변경
ZSH_THEME="agnoster"  # 또는 af-magic, bira, cloud 등

# 적용
source ~/.zshrc
```

인기 있는 테마:
- `agnoster`: 깔끔하고 정보가 많음
- `powerlevel10k`: 매우 커스터마이징 가능 (별도 설치 필요)
- `af-magic`: 간결하고 컬러풀
- `bira`: 미니멀

테마 목록 보기:
```bash
ls ~/.oh-my-zsh/themes/
```

## 플러그인 추가 (선택사항)

유용한 플러그인을 활성화할 수 있습니다.

`~/.zshrc`에서 `plugins` 부분 수정:

```bash
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  history
  sudo
  docker
  kubectl
)
```

플러그인 설치 (별도 설치가 필요한 경우):

```bash
# zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

## 실습 파일 가져오기

fzf hands-on lab 파일을 EC2로 복사:

```bash
# 로컬 터미널에서
scp -i opentofu/fzf-lab-key.pem -r step \
  ubuntu@<인스턴스_IP>:~/

# EC2에서 실습 진행
cd ~/step/step1
source problem.zsh
```

또는 git clone:

```bash
# EC2에서
git clone https://github.com/youngsu5582/fzf-hands-on-lab-repository.git
cd fzf-hands-on-lab-repository/step/step1
```

## 트러블슈팅

### zsh가 기본 셸로 설정되지 않음

```bash
# 현재 셸 확인
echo $SHELL

# 수동으로 변경
sudo chsh -s /bin/zsh ec2-user

# 로그아웃 후 다시 로그인
exit
```

### fzf 단축키가 작동하지 않음

```bash
# .zshrc에 fzf 설정이 있는지 확인
grep fzf ~/.zshrc

# 없다면 추가
echo '[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh' >> ~/.zshrc
source ~/.zshrc
```

### Oh My Zsh 테마가 깨져 보임

폰트 문제일 수 있습니다. 로컬 터미널에 Powerline 폰트를 설치하세요:

- macOS: `brew install font-meslo-lg-nerd-font`
- 터미널 설정에서 폰트를 "MesloLGS NF"로 변경

### 명령어 실행 시 "command not found"

PATH 설정을 확인하세요:

```bash
# .zshrc에 PATH 추가
echo 'export PATH=$HOME/.local/bin:$PATH' >> ~/.zshrc
source ~/.zshrc
```

## 참고 자료

- [Oh My Zsh 공식 문서](https://github.com/ohmyzsh/ohmyzsh)
- [fzf GitHub](https://github.com/junegunn/fzf)
- [zsh 공식 사이트](https://www.zsh.org/)
