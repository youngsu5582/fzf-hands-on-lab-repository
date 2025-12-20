# Step 0: 환경 설정

> 이 문서는 fzf 핸즈온 실습을 위한 환경 설정 가이드입니다.
> 어떤 환경에서도 실습이 가능하도록 **Docker, Mac, Windows** 환경별 설치 방법을 모두 제공합니다.

## 목차
1. [Docker를 활용한 실습 환경 (권장)](#1-docker를-활용한-실습-환경-권장)
2. [Mac에서 설치](#2-mac에서-설치)
3. [Windows에서 설치](#3-windows에서-설치)
4. [설치 확인](#4-설치-확인)

---

## 1. Docker를 활용한 실습 환경 (권장)

Docker를 사용하면 **OS에 관계없이 동일한 환경**에서 실습이 가능하다.

### 1.1 사전 준비
- Docker Desktop 설치 ([Mac](https://docs.docker.com/desktop/install/mac-install/) / [Windows](https://docs.docker.com/desktop/install/windows-install/))

```bash
# 1. 컨테이너 빌드 및 실행
docker-compose up -d

# 2. 쉘 접속
docker exec -it fzf_shell zsh
```

### 1.3 컨테이너 관리

```bash
# 컨테이너에서 나가기 (컨테이너는 계속 실행 중)
exit

# 다시 접속
docker exec -it fzf_shell zsh

# 다 완료했으면, 컨테이너 중지
docker-compose down
```

---

## 2. Mac에서 설치

Mac에서는 **Homebrew**를 사용하는 것이 가장 간단!

### 2.1 Homebrew를 사용한 설치 (권장)

```bash
# fzf 설치
brew install fzf
```

### 2.2 Git을 사용한 설치

```bash
# 1. fzf 저장소 클론
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf

# 2. 설치 스크립트 실행
~/.fzf/install
# 모든 옵션에 'y' 입력

# 3. 쉘 재시작
source ~/.zshrc  # zsh 사용 시
source ~/.bashrc  # bash 사용 시
```

### 2.3 Mac 사용 시 주의사항

- **기본 쉘 확인:**

```bash
echo $SHELL
# /bin/zsh (Mac 기본) 또는 /bin/bash
```

이번 실습은 zsh 를 기반으로 학습하므로, zsh 를 사용하게 변경하자.

- 설정 파일 위치: `~/.zshrc`
---

## 3. Windows에서 설치

### 3.1 방법 1: WSL2 (Windows Subsystem for Linux) 사용

가장 간단하고, 기존 Linux 환경과 동일하게 사용할 수 있다.

#### WSL2 설치

```powershell

# PowerShell을 관리자 권한으로 실행 후

# WSL 설치
wsl --install
```

#### WSL2에서 fzf 설치

```bash
# WSL Ubuntu 터미널에서 실행

# 1. 패키지 업데이트
sudo apt-get update

# 2. fzf 설치
sudo apt-get install -y fzf

# 3. 쉘 재시작
exec bash
```

### 3.2 방법 2: Chocolatey 사용 (PowerShell 환경)

Windows 네이티브 환경에서 사용하려면 Chocolatey 패키지 매니저를 사용합니다.

#### Chocolatey 설치

[chocolatey Windows용 패키지 매니저 chocolatey 설치 하기](https://goddaehee.tistory.com/294)

를 참고하자.

#### fzf 설치

```powershell
# PowerShell에서 실행
choco install fzf

# 설치 확인
fzf --version
```

### 3.3 방법 3: Scoop 사용 (PowerShell 환경)

```powershell
# PowerShell에서 실행

# Scoop 설치 (관리자 권한 불필요)
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
irm get.scoop.sh | iex

# fzf 설치
scoop install fzf
```

### 3.4 방법 4: Git Bash 사용

Git for Windows를 설치하면 포함된 Git Bash에서 fzf를 사용할 수 있습니다.

```bash
# Git Bash 터미널에서

# 1. fzf 저장소 클론
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf

# 2. 설치
~/.fzf/install

# 3. Git Bash 재시작
```

### 3.7 Windows 사용 시 주의사항

- **경로 문제:**
  - Windows 경로: `C:\Users\...`
  - WSL 경로: `/mnt/c/Users/...`
  - Git Bash: `/c/Users/...`

- **줄바꿈 문제 (CRLF vs LF):**
```bash
# Git 설정으로 해결
git config --global core.autocrlf true  # Windows
git config --global core.autocrlf input # WSL
```

- **권한 문제:**
  - PowerShell 스크립트 실행 시 `Set-ExecutionPolicy` 설정 필요

---

## 4. 설치 확인

모든 환경에서 동일하게 확인할 수 있습니다.

### 4.1 버전 확인

```bash
fzf --version
# 출력 예시: 0.67.0
```

## 실습 전 체크리스트

설치가 완료되었다면 다음을 확인합니다:

- [ ] `fzf --version` 명령어로 버전 확인 ( 0.67 이 최신 버전 )
- [ ] `ls | fzf` 명령어로 기본 검색 동작 확인

모든 항목이 체크되었다면 실습 준비 완료입니다!

---

## 참고 자료

- [fzf 공식 GitHub](https://github.com/junegunn/fzf)
- [fzf 위키](https://github.com/junegunn/fzf/wiki)
- [Docker 공식 문서](https://docs.docker.com/)
- [WSL2 공식 문서](https://docs.microsoft.com/en-us/windows/wsl/)