#!/bin/bash

# Ubuntu 22.04 LTS에서 zsh 및 fzf 설정 스크립트
# EC2 인스턴스에 SSH 접속 후 실행하세요

set -e

echo "========================================="
echo "  Zsh & fzf Setup for Ubuntu 22.04 LTS"
echo "========================================="
echo ""

# Check if running as ubuntu
if [ "$USER" != "ubuntu" ]; then
    echo "Warning: This script is designed to run as ubuntu user"
fi

# Install zsh if not installed
if ! command -v zsh &> /dev/null; then
    echo "Installing zsh..."
    sudo apt-get update
    sudo apt-get install -y zsh
    echo "✓ zsh installed"
else
    echo "✓ zsh already installed"
fi

# Install fzf if not installed
if ! command -v fzf &> /dev/null; then
    echo "Installing fzf..."
    if [ ! -d "$HOME/.fzf" ]; then
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        ~/.fzf/install --all --no-bash --no-fish
        echo "✓ fzf installed"
    fi
else
    echo "✓ fzf already installed"
fi

# Install Oh My Zsh if not installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    export RUNZSH=no
    export KEEP_ZSHRC=yes
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    echo "✓ Oh My Zsh installed"
else
    echo "✓ Oh My Zsh already installed"
fi

# Add fzf to .zshrc if not already added
if [ -f ~/.zshrc ]; then
    if ! grep -q "fzf integration" ~/.zshrc; then
        echo "Configuring fzf in .zshrc..."
        cat >> ~/.zshrc <<'EOF'

# fzf integration
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# fzf 옵션 설정
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

# Ctrl+R: 명령어 히스토리 검색
# Ctrl+T: 파일 검색
# Alt+C: 디렉토리 이동
EOF
        echo "✓ fzf configured in .zshrc"
    else
        echo "✓ fzf already configured in .zshrc"
    fi
fi

# Change default shell to zsh
CURRENT_SHELL=$(getent passwd "$USER" | cut -d: -f7)
if [ "$CURRENT_SHELL" != "/bin/zsh" ]; then
    echo "Changing default shell to zsh..."
    sudo chsh -s /bin/zsh "$USER"
    echo "✓ Default shell changed to zsh"
    echo ""
    echo "========================================="
    echo "  Setup Complete!"
    echo "========================================="
    echo ""
    echo "Please logout and login again to use zsh."
    echo "Or run: exec zsh"
else
    echo "✓ Default shell is already zsh"
    echo ""
    echo "========================================="
    echo "  Setup Complete!"
    echo "========================================="
    echo ""
    echo "Run: exec zsh"
fi

echo ""
echo "Test fzf: Ctrl+R (history), Ctrl+T (files), Alt+C (directories)"
echo ""
