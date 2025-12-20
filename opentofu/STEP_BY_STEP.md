# EC2 인스턴스 관리 - 단계별 가이드

## 🎯 전체 플로우

```
생성 → 접속 → 사용 → 중지 → 시작 → 사용 → 삭제
```

---

## Step 1: 인스턴스 생성

### 1-1. 디렉토리 이동
```bash
cd opentofu
```

### 1-2. 생성 스크립트 실행
```bash
./scripts/create.sh
```

### 1-3. 대기 및 확인
- 화면에 인프라 계획이 표시됨
- `yes` 입력
- 약 3-5분 대기

### 1-4. 완료 확인
```bash
========================================
  EC2 Instance Created Successfully!
========================================

Connect using: ssh -i fzf-lab-key.pem ec2-user@13.125.123.45

To connect later, run: ./scripts/connect.sh
To destroy, run: ./scripts/destroy.sh
```

**✅ 생성 완료!**

---

## Step 2: 인스턴스 접속

### 2-1. SSH 접속
```bash
./scripts/connect.sh
```

### 2-2. 접속 확인
```bash
# Ubuntu EC2 프롬프트가 보임
ubuntu@ip-10-0-1-123:~$
```

### 2-3. 설치 확인
```bash
# Java 버전 확인
java -version
# openjdk version "21.0.1" 2023-10-17 LTS

# Gradle 버전 확인
gradle -version
# Gradle 8.5

# fzf 테스트
Ctrl+R  # 명령어 히스토리 검색
```

**✅ 접속 완료!**

---

## Step 3: 서버 실행

### 3-1. 서버 시작
```bash
# 방법 1: 간편 스크립트
~/start-server.sh

# 방법 2: 직접 실행
cd ~/fzf-hands-on-lab-repository/sample-server
./gradlew bootRun
```

### 3-2. 서버 실행 확인
```bash
# 별도 터미널에서 (EC2 내부)
curl http://localhost:8080/actuator/health

# 출력:
{"status":"UP"}
```

### 3-3. 외부에서 접속 확인

**로컬 터미널 (새 창):**
```bash
# IP 확인
cd opentofu
./scripts/status.sh

# 출력에서 server_url 확인
# server_url: http://13.125.123.45:8080

# 접속 테스트
curl http://13.125.123.45:8080/actuator/health

# 또는 브라우저에서
# http://13.125.123.45:8080/actuator/health
```

**✅ 서버 실행 완료!**

---

## Step 4: 인스턴스 중지 (실습 종료)

### 4-1. 서버 종료
```bash
# EC2에서 Ctrl+C로 서버 종료
^C

# SSH 연결 종료
exit
```

### 4-2. 인스턴스 중지
```bash
# 로컬 터미널에서
./scripts/stop.sh
```

### 4-3. 확인 입력
```
Do you want to stop this instance? (yes/no): yes
```

### 4-4. 대기
```
Instance is stopping. This may take a few minutes.
```

### 4-5. 상태 확인
```bash
./scripts/status.sh
# 또는
aws ec2 describe-instances \
    --instance-ids $(tofu output -raw instance_id) \
    --profile joyson \
    --region ap-northeast-2 \
    --query 'Reservations[0].Instances[0].State.Name' \
    --output text
# 출력: stopped
```

**✅ 인스턴스 중지 완료!**

**비용 상태:**
- EC2 요금: $0 (중지됨)
- EBS 요금: 프리티어 내 무료

---

## Step 5: 인스턴스 재시작 (다음날 실습)

### 5-1. 인스턴스 시작
```bash
./scripts/start.sh
```

### 5-2. 대기
```
Instance is starting. This may take a few minutes.
Waiting for instance to be ready...
```

### 5-3. 완료 확인
```
========================================
  Instance Started Successfully!
========================================

instance_id: i-0123456789abcdef0
instance_public_ip: 54.180.200.100  ← 새 IP!
...
```

**⚠️ 주의: IP 주소가 변경되었습니다!**

### 5-4. 새 IP로 접속
```bash
./scripts/connect.sh
# 자동으로 새 IP로 접속됨
```

### 5-5. 데이터 확인
```bash
# 모든 파일이 그대로 있음
ls ~/fzf-hands-on-lab-repository
# 출력: opentofu  README.md  sample-server  setup-stash.sh  step

# 서버 재시작
~/start-server.sh
```

**✅ 인스턴스 재시작 완료!**

---

## Step 6: 인스턴스 재부팅 (Restart)

### 6-1. 재부팅 실행
```bash
./scripts/restart.sh
```

### 6-2. 확인 입력
```
Do you want to restart this instance? (yes/no): yes
```

### 6-3. 대기
```
Instance is restarting. This may take a few minutes.
Waiting for instance to be ready...
```

### 6-4. 완료
```
========================================
  Instance Restarted Successfully!
========================================

To connect: ./scripts/connect.sh
```

**✅ IP 주소는 유지됩니다!**

---

## Step 7: 인스턴스 삭제 (프로젝트 종료)

### 7-1. 삭제 실행
```bash
./scripts/destroy.sh
```

### 7-2. 현재 상태 확인
```
Current infrastructure:
instance_id: i-0123456789abcdef0
instance_public_ip: 13.125.123.45
```

### 7-3. 확인 입력
```
Are you sure you want to DESTROY all resources? (yes/no): yes
```

### 7-4. 대기
```
Destroying infrastructure...
```

### 7-5. 완료
```
========================================
  All resources have been destroyed!
========================================
```

**✅ 모든 리소스 삭제 완료!**

**비용 상태: $0**

---

## 📋 명령어 체크리스트

### 최초 1회
- [ ] `./scripts/create.sh` - 인스턴스 생성

### 매일 사용
- [ ] `./scripts/start.sh` - 아침: 시작
- [ ] `./scripts/connect.sh` - 접속
- [ ] `~/start-server.sh` - 서버 실행
- [ ] `./scripts/stop.sh` - 저녁: 중지

### 문제 해결
- [ ] `./scripts/status.sh` - 상태 확인
- [ ] `./scripts/restart.sh` - 재부팅

### 프로젝트 종료
- [ ] `./scripts/destroy.sh` - 삭제

---

## ⏱️ 예상 시간

| 작업 | 시간 |
|------|------|
| 생성 (create) | 3-5분 |
| 접속 (connect) | 즉시 |
| 중지 (stop) | 30초-1분 |
| 시작 (start) | 1-2분 |
| 재시작 (restart) | 1-2분 |
| 삭제 (destroy) | 2-3분 |

---

## 🔄 실전 시나리오

### 시나리오 1: 하루 실습
```bash
# 오전 9시
./scripts/create.sh      # 5분
./scripts/connect.sh     # 즉시

# 실습 중...

# 오후 6시
exit
./scripts/destroy.sh     # 3분
```

### 시나리오 2: 일주일 프로젝트
```bash
# 월요일 오전
./scripts/create.sh      # 최초 생성

# 월-금 매일
./scripts/start.sh       # 아침
./scripts/connect.sh
# 작업...
exit
./scripts/stop.sh        # 저녁

# 금요일 저녁
./scripts/destroy.sh     # 프로젝트 완료
```

### 시나리오 3: 장기 프로젝트
```bash
# 1주차
./scripts/create.sh      # 최초 생성

# 매일
./scripts/start.sh       # 아침
./scripts/stop.sh        # 저녁

# 주말: 중지 상태 유지
# (비용: 프리티어 내 무료)

# 2주차 월요일
./scripts/start.sh       # 계속 사용

# 프로젝트 종료
./scripts/destroy.sh
```

---

## ❓ FAQ

### Q1. stop과 destroy의 차이는?
- **stop**: 데이터 유지, 나중에 재시작 가능
- **destroy**: 모든 데이터 삭제, 복구 불가능

### Q2. IP가 계속 바뀌는데?
- stop → start 시 IP 변경됨
- `./scripts/status.sh`로 새 IP 확인
- restart는 IP 유지

### Q3. 비용이 얼마나?
- 프리티어: 월 750시간 무료
- stopped 상태: EC2 요금 없음
- EBS: 30GB까지 무료

### Q4. 실수로 destroy 했어요!
- 복구 불가능
- `./scripts/create.sh`로 새로 생성

### Q5. 서버가 자동 실행 안 되나요?
- 현재는 수동 실행
- 필요시 systemd 서비스 설정 가능

---

## 🎓 학습 포인트

이 실습을 통해 배울 수 있는 것:
1. ✅ IaC (Infrastructure as Code) - OpenTofu
2. ✅ AWS EC2 인스턴스 관리
3. ✅ 클라우드 비용 최적화 (stop/start)
4. ✅ SSH 원격 접속
5. ✅ Java/Gradle 빌드
6. ✅ Spring Boot 애플리케이션 배포

즐거운 실습 되세요! 🚀
