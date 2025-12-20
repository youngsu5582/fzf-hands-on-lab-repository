# Quick Start - 5분 안에 시작하기

## 1. EC2 인스턴스 생성 (1분)

```bash
cd opentofu
./scripts/create.sh
```

입력 내용:
- `yes` 입력하여 인프라 생성 확인

생성되는 것:
- EC2 인스턴스 (Ubuntu 22.04 LTS, t2.micro)
- VPC, Subnet, Security Group
- SSH 키 자동 생성
- **Java 21, Gradle, sample-server 자동 설치**
- **zsh, fzf, Oh My Zsh 자동 설치**

## 2. 인스턴스 접속 (10초)

```bash
./scripts/connect.sh
```

접속되면 자동으로 zsh 셸이 실행됩니다!

## 3. fzf 테스트 (30초)

```bash
# 명령어 히스토리 검색
# Ctrl+R 누르기

# 파일 검색
# Ctrl+T 누르기

# 디렉토리 이동
# Alt+C (또는 Esc+C) 누르기
```

## 4. 실습 파일 가져오기 (1분)

### 방법 1: Git clone

```bash
git clone https://github.com/youngsu5582/fzf-hands-on-lab-repository.git
cd fzf-hands-on-lab-repository
```

### 방법 2: 로컬 파일 복사

로컬 터미널에서:

```bash
# 인스턴스 IP 확인
cd opentofu
./scripts/status.sh

# 실습 파일 복사
scp -i fzf-lab-key.pem -r ../step ec2-user@<인스턴스_IP>:~/
```

## 5. 실습 시작 (2분)

```bash
cd fzf-hands-on-lab-repository/step/step1
cat README.md

# 문제 파일 로드
source problem.zsh

# 함수 실행
find-sample
```

## 6. 실습 종료 후 정리

```bash
# 로컬 터미널에서
cd opentofu
./scripts/destroy.sh
```

입력: `yes`

---

## 트러블슈팅

### "AWS profile 'joyson' not found"

```bash
aws configure --profile joyson
# Access Key ID, Secret Key, Region(ap-northeast-2) 입력
```

### "terraform.tfstate not found"

인프라가 생성되지 않았습니다:
```bash
./scripts/create.sh
```

### SSH 접속이 안 됨

인스턴스가 완전히 시작될 때까지 기다리세요 (약 1-2분).

```bash
# 상태 확인
./scripts/status.sh

# 1-2분 후 다시 시도
./scripts/connect.sh
```

### zsh가 안 뜨는 경우

```bash
# 수동으로 zsh 실행
exec zsh

# 또는 설정 스크립트 실행
bash ~/setup-zsh.sh
```

---

## 비용

- **t2.micro**: 프리티어 (월 750시간 무료)
- **30GB EBS**: 프리티어 (월 30GB 무료)
- **예상 비용**: **$0** (프리티어 내)

**중요**: 사용 후 반드시 삭제하세요!

```bash
./scripts/destroy.sh
```

---

## 명령어 요약

```bash
# 생성
./scripts/create.sh

# 접속
./scripts/connect.sh

# 상태
./scripts/status.sh

# 삭제
./scripts/destroy.sh
```

편하게 실습하세요! 🚀
