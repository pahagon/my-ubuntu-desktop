#!/bin/bash
# Smoke test - Verifica que todas as ferramentas foram instaladas corretamente

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

PASSED=0
FAILED=0
SKIPPED=0

pass() {
    echo -e "${GREEN}✓${NC} $1"
    ((PASSED++))
}

fail() {
    echo -e "${RED}✗${NC} $1"
    ((FAILED++))
}

skip() {
    echo -e "${YELLOW}⊘${NC} $1"
    ((SKIPPED++))
}

check_command() {
    local cmd="$1"
    local name="${2:-$cmd}"

    if command -v "$cmd" &> /dev/null; then
        local version=$($cmd --version 2>&1 | head -n1 || echo "unknown")
        pass "$name is installed: $version"
        return 0
    else
        fail "$name is NOT installed"
        return 1
    fi
}

check_file() {
    local file="$1"
    local name="${2:-$file}"

    if [ -f "$file" ]; then
        pass "$name exists"
        return 0
    else
        fail "$name does NOT exist"
        return 1
    fi
}

check_directory() {
    local dir="$1"
    local name="${2:-$dir}"

    if [ -d "$dir" ]; then
        pass "$name exists"
        return 0
    else
        fail "$name does NOT exist"
        return 1
    fi
}

check_symlink() {
    local link="$1"
    local target="$2"
    local name="${3:-$link}"

    if [ -L "$link" ]; then
        local actual_target=$(readlink -f "$link")
        if [[ "$actual_target" == *"$target"* ]]; then
            pass "$name -> $target"
            return 0
        else
            fail "$name points to wrong target: $actual_target (expected: $target)"
            return 1
        fi
    else
        fail "$name is NOT a symlink"
        return 1
    fi
}

echo "========================================="
echo "  Smoke Tests - Tool Installation"
echo "========================================="
echo ""

# ===========================================
# Core Tools
# ===========================================
echo "## Core Tools"
check_command git "Git"
check_command curl "Curl"
check_command wget "Wget" || skip "Wget (optional)"
check_command bash "Bash"
check_command tmux "Tmux" || skip "Tmux (optional)"
echo ""

# ===========================================
# ASDF Version Manager
# ===========================================
echo "## ASDF Version Manager"
check_directory "$HOME/.asdf" "ASDF installation"
check_file "$HOME/.asdf/asdf.sh" "ASDF script"

if [ -f "$HOME/.asdf/asdf.sh" ]; then
    source "$HOME/.asdf/asdf.sh"
    check_command asdf "ASDF command"
fi
echo ""

# ===========================================
# Programming Languages
# ===========================================
echo "## Programming Languages"

# Python
if command -v asdf &> /dev/null; then
    source "$HOME/.asdf/asdf.sh" 2>/dev/null || true

    if asdf plugin list | grep -q python; then
        pass "Python plugin installed"
        check_command python "Python" || check_command python3 "Python3"
        check_command pip "Pip" || check_command pip3 "Pip3"
    else
        skip "Python (not installed via ASDF)"
    fi

    # Node.js
    if asdf plugin list | grep -q nodejs; then
        pass "Node.js plugin installed"
        check_command node "Node.js"
        check_command npm "NPM"
    else
        skip "Node.js (not installed via ASDF)"
    fi

    # Go
    if asdf plugin list | grep -q golang; then
        pass "Go plugin installed"
        check_command go "Go"
    else
        skip "Go (not installed via ASDF)"
    fi

    # Ruby
    if asdf plugin list | grep -q ruby; then
        pass "Ruby plugin installed"
        check_command ruby "Ruby"
        check_command gem "Gem"
    else
        skip "Ruby (not installed via ASDF)"
    fi

    # Java
    if asdf plugin list | grep -q java; then
        pass "Java plugin installed"
        check_command java "Java"
    else
        skip "Java (not installed via ASDF)"
    fi
fi
echo ""

# ===========================================
# Editors
# ===========================================
echo "## Editors"
check_command vim "Vim" || skip "Vim (optional)"
check_command emacs "Emacs" || skip "Emacs (optional)"
check_command code "VS Code" || skip "VS Code (optional)"
echo ""

# ===========================================
# Containerization
# ===========================================
echo "## Containerization"
check_command docker "Docker" || skip "Docker (optional)"
if command -v docker &> /dev/null; then
    check_command docker-compose "Docker Compose" || skip "Docker Compose (optional)"
fi
echo ""

# ===========================================
# Cloud Tools
# ===========================================
echo "## Cloud Tools"
check_command aws "AWS CLI" || skip "AWS CLI (optional)"
check_command gh "GitHub CLI" || skip "GitHub CLI (optional)"
echo ""

# ===========================================
# Custom Binaries
# ===========================================
echo "## Custom Binaries"
check_file "$HOME/dot/bin/arduino-cli" "Arduino CLI" || skip "Arduino CLI (optional)"
check_file "$HOME/dot/bin/giffy" "Giffy script"
check_file "$HOME/dot/bin/webdir" "Webdir script"
check_file "$HOME/dot/bin/init-node-project" "Init-node-project script"
echo ""

# ===========================================
# Dotfiles Symlinks
# ===========================================
echo "## Dotfiles Symlinks"
check_symlink "$HOME/.bashrc" "dot/bash/rc" ".bashrc"
check_symlink "$HOME/.bash_profile" "dot/bash/profile" ".bash_profile" || skip ".bash_profile (optional)"
check_symlink "$HOME/.vimrc" "dot/vim/vimrc" ".vimrc" || skip ".vimrc (optional)"
check_symlink "$HOME/.tmux.conf" "dot/tmux/tmux.conf" ".tmux.conf" || skip ".tmux.conf (optional)"
check_symlink "$HOME/.gitconfig" "dot/git/gitconfig" ".gitconfig" || skip ".gitconfig (optional)"
echo ""

# ===========================================
# Configuration Directories
# ===========================================
echo "## Configuration Directories"
check_directory "$HOME/dot" "Dotfiles repository"
check_directory "$HOME/dot/bash" "Bash configs"
check_directory "$HOME/dot/vim" "Vim configs" || skip "Vim configs (optional)"
check_directory "$HOME/dot/emacs" "Emacs configs" || skip "Emacs configs (optional)"
check_directory "$HOME/dot/tmux" "Tmux configs" || skip "Tmux configs (optional)"
check_directory "$HOME/dot/git" "Git configs"
echo ""

# ===========================================
# Summary
# ===========================================
echo "========================================="
echo "  Summary"
echo "========================================="
echo -e "${GREEN}Passed:${NC}  $PASSED"
echo -e "${YELLOW}Skipped:${NC} $SKIPPED"
echo -e "${RED}Failed:${NC}  $FAILED"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✓ All critical tests passed!${NC}"
    exit 0
else
    echo -e "${RED}✗ Some tests failed. Please review.${NC}"
    exit 1
fi
