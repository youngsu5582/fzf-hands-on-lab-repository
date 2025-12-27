# 환경 설정 문서: https://buly.kr/BpGL3Qp

# 행사장 WIFI 접속 (https://buly.kr/GvoJUyY)
- 와이파이: https://buly.kr/GvoJUyY
- 네트워크 이름: woowanet.join
- 연결 주소: woowanet.woowa.in
- 구성원 AD 계정: robot.hoony

---

# Step 0: 환경 설정

> 이 문서는 fzf 핸즈온 실습을 위한 환경 설정 가이드입니다.

## 목차

0. ⭐ Stash 목록 세팅하기  
   → [바로가기](#-0-stash-목록-세팅하기)

1. [Mac에서 설치](#1-mac에서-설치)
2. [Windows에서 설치](#2-windows에서-설치)
3. [Git을 사용한 설치](#3-git-을-사용한-설치)
4. [설치 확인](#4-설치-확인)

---

## ⭐️ 0. Stash 목록 세팅하기

이번 실습은 stash 를 간편하게 하는 함수를 작성합니다.
그래서, stash 목록이 필요합니다.

```shell
chmod +x ./setup-stash.sh && ./setup-stash.sh
```

를 실행하면 stash 가 자동으로 생성됩니다.

```shell
git stash list
```

stash 목록을 출력해서 5개인지 확인하면 세팅 끝!

## 1. Mac에서 설치

Mac에서는 **Homebrew**를 사용하는 것이 가장 간단합니다.

### 1.1 Homebrew를 사용한 설치 (권장)

```bash
# fzf 설치
brew install fzf
```

---

## 2. Windows에서 설치

### 2.1 방법 1: WSL2 (Windows Subsystem for Linux) 사용

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

### 2.2 방법 2: Chocolatey 사용 (PowerShell 환경)

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

---

## 3. Git 을 사용한 설치

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
