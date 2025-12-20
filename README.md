# FZF Hands-on Lab

> https://github.com/youngsu5582/awesome-tools
> 해당 레포지토리에 제가 사용하는 함수들을 하나씩 올리고 있으니
> 어떻게 쓰는지 궁금하다면, 먼저 들어가서 구경해도 좋습니다.

## 실습 목차

실습은 타이핑을 따라하는 것 위주로 진행됩니다.

1. 터미널을 이해하고, CLI 명령어를 함수에 넣어서 사용해봅니다.
2. fzf 에 대한 학습 및 실습
3. fzf 를 활용한 git stash 명령어 만들기

## AWS 실습 환경 (선택사항)

원격 서버에서 fzf를 실습하고 싶다면 OpenTofu를 사용하여 AWS EC2 인스턴스를 생성할 수 있습니다.

**사용 OS:** Ubuntu 22.04 LTS

**자동으로 설치됩니다:**
- ✅ zsh + Oh My Zsh
- ✅ fzf (퍼지 파인더)
- ✅ 개발 도구 (git, vim, htop 등)

```bash
cd opentofu
./scripts/create.sh    # EC2 인스턴스 생성 (모든 도구 자동 설치)
./scripts/connect.sh   # 인스턴스 접속 (ubuntu 사용자)
./scripts/stop.sh      # 인스턴스 중지 (비용 절감)
./scripts/start.sh     # 인스턴스 재시작
./scripts/destroy.sh   # 인스턴스 삭제
```

자세한 내용은 [opentofu/README.md](opentofu/README.md)를 참고하세요.
zsh 설정 가이드는 [opentofu/ZSH_SETUP.md](opentofu/ZSH_SETUP.md)를 참고하세요.

---

## 학습 목표

이 워크샵을 마치면 다음을 할 수 있습니다:

- ✅ fzf의 기본 검색 패턴 이해하고 활용하기
- ✅ preview, query 등 주요 옵션으로 생산성 향상하기
- ✅ 실무에서 자주 사용하는 CLI 도구와 fzf 결합하기
- ✅ 자신만의 fzf 함수 만들어 쉘 설정에 추가하기

---

## 시작하기

### 1. 환경 설정

먼저 [Step 0](step/step0/)를 따라 fzf를 설치하고 환경을 설정하세요.

```bash
# 설치 확인
fzf --version
```

### 2. Step별 실습

각 Step 디렉토리로 이동하여 README를 읽고 실습을 진행하세요.

```bash
cd step/step1
```

### 3. 실습 파일 구조

각 Step에는 다음 파일들이 포함되어 있습니다:

- `README.md`: 학습 내용 및 실습 가이드
- `problem.zsh`: 실습 문제 (직접 완성해야 하는 함수)
- `answer.zsh`: 정답 코드 (막힐 때 참고)
- 기타 실습용 샘플 파일

---

## 실습 방식

### 권장 학습 방법

1. **README 읽기**: 각 Step의 개념을 먼저 이해
2. **직접 타이핑**: 예제 명령어를 직접 입력하며 체감
3. **문제 풀이**: problem.zsh의 함수를 직접 완성
4. **답안 확인**: answer.zsh로 정답 확인 및 비교
5. **응용하기**: 자신의 작업 환경에 맞게 커스터마이징

### 함수 실행 방법

```bash
# 함수 정의 로드
source problem.zsh

# 함수 실행
find-sample
```

---

## 추가 자료

### 공식 문서
- [fzf GitHub](https://github.com/junegunn/fzf)
- [fzf Wiki](https://github.com/junegunn/fzf/wiki)

### 유용한 링크
- [fzf 예제 모음](https://github.com/junegunn/fzf/wiki/examples)
- [awesome-fzf](https://github.com/aabiskar1/awesome-fzf)