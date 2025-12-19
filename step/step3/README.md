## FZF Step3. FZF 파이프라인

FZF 는 결국
INPUT 으로 오는 요소를 FZF 로 선택하고, OUTPUT 으로 수행을 하는 것이다.

FZF 와 리눅스 및 여러 CLI 명령어들을 조합해 원하는 기능을 만들수 있다.

### CLI

사용자가 입력하는 모든 명령어들

- Linux 명령어
  - kill -signal PID : PID 에 해당하는 프로세스 signal 에 따라 종료 ( -9 : SIGKILL, -15 : SIGTERM ) 
  - ps aux : 실행중인 모든 프로세스 목록 보여줌
  - mktemp : 스크립트 내에서 임시 파일, 임시 디렉토리 생성
  - grep : 패턴에 맞는 줄을 필터링
  - curl : URL 로 HTTP 요청을 보냄
  - jq : JSON 데이터를 필터링하고, 원하는 방식으로 변환

> jq 는 설명만 들으면 이해할 수 없다.
> sample.json 을 추출하며 학습해보자.


- Git 명령어
  - git checkout : 브랜치, 커밋으로 작업 위치 이동
  - git pull : 원격 저장소에서 변경 사항을 가져와 현재 브랜치와 병합
  - git stash : 작업 중인 변경 사항을 임시로 저장
  - git branch -D : 로컬 브랜치 삭제
  - git show : 특정 커밋의 상세 내용 조회

- Aws 명령어
  - aws ec2 describe-instances : ec2 인스턴스의 상태 묘사
```shell
aws ec2 describe-instances --profile $profile --region "$region" \
                    --filters "Name=tag:Name,Values=*${name_filter}*" "Name=instance-state-name,Values=running" \
                    --query 'Reservations[].Instances[].[InstanceId, PublicIpAddress, PrivateIpAddress, InstanceType, Tags[?Key==`Name`]|[0].Value, State.Name, Placement.AvailabilityZone]' \
                    --output text
```
  - aws s3 ls : 버킷 목록 조회
  - aws s3 cp "s3://$bucket/$object_key" "./$filename" : 버킷에서 특정 파일을 특정 경로로 파일 다운로드

- JIRA 명령어
- Obsidian 명령어
- Confluence Wiki 명령어

등등...