.PHONY: help create connect status stop start restart destroy clean

help:
	@echo "========================================="
	@echo "  AWS EC2 실습 환경 관리"
	@echo "========================================="
	@echo ""
	@echo "사용 가능한 명령어:"
	@echo "  make create     - EC2 인스턴스 생성"
	@echo "  make connect    - EC2 인스턴스 접속"
	@echo "  make status     - 인스턴스 상태 확인"
	@echo "  make stop       - 인스턴스 중지"
	@echo "  make start      - 인스턴스 시작"
	@echo "  make restart    - 인스턴스 재시작"
	@echo "  make destroy    - EC2 인스턴스 삭제"
	@echo "  make clean      - 로컬 상태 파일 정리"
	@echo ""

create:
	@./scripts/create.sh

connect:
	@./scripts/connect.sh

status:
	@./scripts/status.sh

stop:
	@./scripts/stop.sh

start:
	@./scripts/start.sh

restart:
	@./scripts/restart.sh

destroy:
	@./scripts/destroy.sh

clean:
	@echo "Cleaning up local files..."
	@rm -rf .terraform/
	@rm -f .terraform.lock.hcl
	@rm -f terraform.tfstate*
	@rm -f *.pem
	@echo "Done!"
