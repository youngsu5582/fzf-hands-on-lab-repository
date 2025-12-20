# AWS EC2 실습 환경 (OpenTofu)

OpenTofu를 사용하여 AWS EC2 인스턴스를 간편하게 생성, 접속, 삭제할 수 있는 실습 환경입니다.

## 사전 준비

### 1. OpenTofu 설치

```bash
# macOS (Homebrew)
brew install opentofu

# 기타 OS는 공식 문서 참고
# https://opentofu.org/docs/intro/install/
```

### 2. AWS CLI 설정

AWS profile `joyson`이 설정되어 있어야 합니다.

```bash
# AWS CLI 설치 (macOS)
brew install awscli

# Profile 설정
aws configure --profile joyson
# AWS Access Key ID: [YOUR_ACCESS_KEY]
# AWS Secret Access Key: [YOUR_SECRET_KEY]
# Default region name: ap-northeast-2
# Default output format: json

# 설정 확인
aws configure list --profile joyson
```

**주요 변경사항:**
- OS: Ubuntu 22.04 LTS (이전: Amazon Linux 2023)
- 사용자: ubuntu (이전: ec2-user)
- 패키지 관리자: apt-get (이전: yum)

### 3. jq 설치 (선택사항, 출력 포맷팅용)

```bash
brew install jq
```

## 빠른 시작

### EC2 인스턴스 생성

```bash
cd opentofu
./scripts/create.sh
```

이 스크립트는 다음을 수행합니다:
- OpenTofu 초기화
- 인프라 변경사항 미리보기 (plan)
- 확인 후 EC2 인스턴스 및 관련 리소스 생성
- SSH 키 자동 생성 (fzf-lab-key.pem)
- 접속 명령어 출력

### EC2 인스턴스 접속

```bash
./scripts/connect.sh
```

인스턴스에 자동으로 SSH 접속됩니다.

### 인스턴스 상태 확인

```bash
./scripts/status.sh
```

현재 인스턴스의 IP, DNS, SSH 명령어 등을 확인할 수 있습니다.

### 인스턴스 중지 (비용 절감)

```bash
./scripts/stop.sh
```

실습이 끝났지만 나중에 다시 사용할 예정이면 중지하세요.
- 데이터는 유지됩니다
- EC2 요금이 중지됩니다 (EBS는 소량 과금, 프리티어 내 무료)

### 인스턴스 시작 (재개)

```bash
./scripts/start.sh
```

중지된 인스턴스를 다시 시작합니다.
- 모든 데이터가 그대로 유지됩니다
- Public IP가 변경될 수 있습니다

### 인스턴스 재시작

```bash
./scripts/restart.sh
```

인스턴스를 재부팅합니다 (IP 유지).

### EC2 인스턴스 삭제

```bash
./scripts/destroy.sh
```

모든 리소스를 안전하게 삭제합니다.

**📖 상세 관리 가이드:** [INSTANCE_MANAGEMENT.md](INSTANCE_MANAGEMENT.md)

## 생성되는 리소스

- **VPC**: 10.0.0.0/16
- **Public Subnet**: 10.0.1.0/24
- **Internet Gateway**
- **Route Table**
- **Security Group**: SSH(22), HTTP(8080) 포트 허용
- **SSH Key Pair**: 자동 생성
- **EC2 Instance**: Ubuntu 22.04 LTS, t2.micro

## 자동 설치되는 도구

EC2 인스턴스 생성 시 다음 도구들이 자동으로 설치됩니다:

### 개발 환경
- ✅ **Java 21 LTS**: SDKMAN으로 관리
- ✅ **Gradle 8.5**: 빌드 도구
- ✅ **sample-server**: 자동 클론 및 빌드

### 터미널 환경
- ✅ **zsh**: 강력한 셸
- ✅ **Oh My Zsh**: zsh 설정 프레임워크
- ✅ **fzf**: 퍼지 파인더

### 기본 도구
- ✅ **git, vim, htop, curl, wget**: 개발 도구

**기본 셸이 zsh로 설정되므로 SSH 접속 시 바로 zsh를 사용할 수 있습니다!**

### 서버 실행

```bash
# EC2 접속 후
~/start-server.sh

# 또는
cd ~/fzf-hands-on-lab-repository/sample-server
./gradlew bootRun
```

**외부 접속:**
```bash
# 로컬에서
curl http://<EC2_IP>:8080/actuator/health

# 또는 브라우저에서
http://<EC2_IP>:8080/actuator/health
```

자세한 zsh 설정 방법은 [ZSH_SETUP.md](ZSH_SETUP.md)를 참고하세요.

## 구성 파일 설명

```
opentofu/
├── provider.tf      # AWS provider 설정
├── variables.tf     # 변수 정의
├── main.tf          # EC2 및 네트워크 리소스 정의
├── outputs.tf       # 출력 값 정의
├── .gitignore       # Git 제외 파일
├── scripts/
│   ├── create.sh    # 인스턴스 생성 스크립트
│   ├── connect.sh   # SSH 접속 스크립트
│   ├── destroy.sh   # 인스턴스 삭제 스크립트
│   └── status.sh    # 상태 확인 스크립트
└── README.md
```

## 커스터마이징

### 인스턴스 타입 변경

`variables.tf`에서 기본값을 변경하거나, 실행 시 변수를 전달할 수 있습니다:

```bash
# t2.small로 변경
tofu apply -var="instance_type=t2.small"
```

### 리전 변경

```bash
tofu apply -var="aws_region=us-east-1"
```

### 자주 사용하는 설정을 파일로 저장

`terraform.tfvars` 파일을 생성하여 변수 값을 저장할 수 있습니다:

```hcl
# terraform.tfvars
aws_profile      = "joyson"
aws_region       = "ap-northeast-2"
instance_type    = "t2.small"
instance_name    = "my-lab-instance"
```

## 수동 명령어 (직접 제어)

스크립트 대신 직접 OpenTofu 명령어를 사용할 수도 있습니다:

```bash
# 초기화
tofu init

# 계획 확인
tofu plan

# 인프라 생성
tofu apply

# 출력 확인
tofu output

# 인프라 삭제
tofu destroy
```

## 비용 안내

- **t2.micro**: AWS 프리티어 대상 (월 750시간 무료)
- **EBS 스토리지 (gp3)**: 30GB (프리티어 30GB까지 무료)
- **데이터 전송**: 15GB/월까지 무료

**중요**: 사용하지 않을 때는 반드시 `./scripts/destroy.sh`로 삭제하세요!

## 트러블슈팅

### 1. "AWS profile 'joyson' not found" 오류

```bash
aws configure --profile joyson
```

### 2. SSH 접속 시 "Permission denied" 오류

```bash
chmod 400 fzf-lab-key.pem
```

### 3. "terraform.tfstate" 파일이 없다는 오류

인프라가 생성되지 않았습니다. `./scripts/create.sh`를 먼저 실행하세요.

### 4. 인스턴스가 생성되었는데 접속이 안 됨

보안 그룹 설정을 확인하세요. 기본적으로 모든 IP(0.0.0.0/0)에서 SSH를 허용합니다.
특정 IP만 허용하려면 `variables.tf`의 `allowed_ssh_cidr`를 수정하세요.

## 참고 자료

- [OpenTofu 공식 문서](https://opentofu.org/docs/)
- [AWS EC2 문서](https://docs.aws.amazon.com/ec2/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
