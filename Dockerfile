# 1. Ubuntu 22.04 LTS 베이스 이미지를 사용
FROM ubuntu:22.04

# 2. 환경 변수 설정
ENV DEBIAN_FRONTEND=noninteractive

# 3. 시스템 업데이트 및 필수 도구 설치
RUN apt-get update && \
    apt-get install -y \
        curl \
        git \
        jq \
        zsh \
        fzf \
        procps \
        # -------------------------------------
        --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# 4. 아키텍처에 독립적인 JAVA_HOME 설정 (매우 중요)
# /usr/lib/jvm/default-java는 대개 OS가 관리하는 기본 JDK 경로를 가리키는 심볼릭 링크입니다.
ENV JAVA_HOME=/usr/lib/jvm/default-java
ENV PATH=$PATH:$JAVA_HOME/bin

# 5. Zsh을 기본 쉘로 설정
RUN chsh -s /usr/bin/zsh root

# 6. Oh My Zsh 설치
# 설치 실패 시에도 빌드는 계속되도록 || true 추가
# Oh My Zsh 설치 스크립트가 chsh 명령을 다시 실행하려고 시도할 때 오류가 발생할 수 있습니다.
# 이를 방지하기 위해 RUN 명령을 분리하거나 아래처럼 ZSH=no 플래그를 사용할 수 있습니다.
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended || true

# 7. 작업 디렉토리 설정 (선택 사항이지만, 소스 코드를 복사하고 gradlew를 실행하기 위해 권장)
WORKDIR /app

COPY step ./step

# 8. 기본 실행 명령 설정
CMD ["/usr/bin/zsh"]