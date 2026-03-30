#!/bin/bash
# Smoke test - Verifica que configurações estão corretas

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

check_config_value() {
    local file="$1"
    local pattern="$2"
    local name="$3"

    if [ ! -f "$file" ]; then
        skip "$name (file not found: $file)"
        return 1
    fi

    if grep -q "$pattern" "$file"; then
        pass "$name is configured"
        return 0
    else
        fail "$name is NOT configured in $file"
        return 1
    fi
}

check_bash_function() {
    local function_name="$1"

    # Carregar bash/rc
    if [ -f "$HOME/dot/bash/rc" ]; then
        source "$HOME/dot/bash/rc" 2>/dev/null || true

        if type "$function_name" &> /dev/null; then
            pass "Bash function '$function_name' exists"
            return 0
        else
            fail "Bash function '$function_name' does NOT exist"
            return 1
        fi
    else
        skip "Bash function '$function_name' (bash/rc not found)"
        return 1
    fi
}

echo "========================================="
echo "  Smoke Tests - Configurations"
echo "========================================="
echo ""

# ===========================================
# Bash Configuration
# ===========================================
echo "## Bash Configuration"

if [ -f "$HOME/.bashrc" ]; then
    pass ".bashrc is linked"

    # Verificar que .bashrc carrega dotfiles
    check_config_value "$HOME/.bashrc" "dot/bash" "Dotfiles sourcing in .bashrc" || \
    check_config_value "$HOME/dot/bash/rc" "dot/bash" "Dotfiles structure"
else
    fail ".bashrc is NOT linked"
fi

# Verificar funções bash
check_bash_function "calc" || skip "calc function (optional)"
check_bash_function "myip" || skip "myip function (optional)"
check_bash_function "ssh-add-reload" || skip "ssh-add-reload function (optional)"

# Verificar PATH
if [[ ":$PATH:" == *":$HOME/.local/bin:"* ]]; then
    pass ".local/bin is in PATH"
else
    fail ".local/bin is NOT in PATH"
fi

echo ""

# ===========================================
# Git Configuration
# ===========================================
echo "## Git Configuration"

if command -v git &> /dev/null; then
    # Verificar user.name
    GIT_USER=$(git config --global user.name 2>/dev/null || echo "")
    if [ -n "$GIT_USER" ]; then
        pass "Git user.name is set: $GIT_USER"
    else
        fail "Git user.name is NOT set"
    fi

    # Verificar user.email
    GIT_EMAIL=$(git config --global user.email 2>/dev/null || echo "")
    if [ -n "$GIT_EMAIL" ]; then
        pass "Git user.email is set: $GIT_EMAIL"
    else
        fail "Git user.email is NOT set"
    fi

    # Verificar aliases
    if git config --global --get-regexp alias &> /dev/null; then
        ALIAS_COUNT=$(git config --global --get-regexp alias | wc -l)
        pass "Git aliases configured ($ALIAS_COUNT aliases)"
    else
        skip "Git aliases (none configured)"
    fi
else
    skip "Git configuration (git not installed)"
fi

echo ""

# ===========================================
# Vim Configuration
# ===========================================
echo "## Vim Configuration"

if [ -f "$HOME/.vimrc" ]; then
    pass ".vimrc is linked"

    # Verificar Vundle
    check_config_value "$HOME/.vimrc" "Vundle" "Vundle plugin manager" || \
    skip "Vundle (not configured)"

    # Verificar diretório de plugins
    if [ -d "$HOME/dot/vim/bundle" ]; then
        PLUGIN_COUNT=$(ls -1 "$HOME/dot/vim/bundle" 2>/dev/null | wc -l)
        pass "Vim plugins directory exists ($PLUGIN_COUNT plugins)"
    else
        skip "Vim plugins (bundle directory not found)"
    fi
else
    skip ".vimrc (not linked)"
fi

echo ""

# ===========================================
# Tmux Configuration
# ===========================================
echo "## Tmux Configuration"

if [ -f "$HOME/.tmux.conf" ]; then
    pass ".tmux.conf is linked"

    # Verificar powerline
    check_config_value "$HOME/.tmux.conf" "powerline" "Powerline integration" || \
    skip "Powerline (not configured)"

    # Verificar mouse support
    check_config_value "$HOME/.tmux.conf" "mouse" "Mouse support" || \
    skip "Mouse support (not configured)"
else
    skip ".tmux.conf (not linked)"
fi

echo ""

# ===========================================
# SSH Configuration
# ===========================================
echo "## SSH Configuration"

if [ -f "$HOME/.ssh/config" ]; then
    pass "SSH config exists"

    # Verificar permissões
    PERMS=$(stat -c "%a" "$HOME/.ssh/config" 2>/dev/null || stat -f "%Lp" "$HOME/.ssh/config" 2>/dev/null)
    if [ "$PERMS" = "600" ] || [ "$PERMS" = "644" ]; then
        pass "SSH config has safe permissions ($PERMS)"
    else
        fail "SSH config has unsafe permissions ($PERMS)"
    fi

    # Verificar ForwardAgent
    if grep -q "ForwardAgent yes" "$HOME/.ssh/config"; then
        fail "SECURITY: ForwardAgent is enabled globally (should be per-host)"
    else
        pass "ForwardAgent is not enabled globally"
    fi
else
    skip "SSH config (not found)"
fi

# Verificar chaves SSH
if [ -d "$HOME/.ssh" ]; then
    if ls "$HOME/.ssh"/id_* &> /dev/null; then
        KEY_COUNT=$(ls -1 "$HOME/.ssh"/id_* 2>/dev/null | grep -v ".pub" | wc -l)
        pass "SSH keys found ($KEY_COUNT keys)"

        # Verificar permissões das chaves
        for key in "$HOME/.ssh"/id_*; do
            [ -f "$key" ] || continue
            [[ "$key" == *.pub ]] && continue

            PERMS=$(stat -c "%a" "$key" 2>/dev/null || stat -f "%Lp" "$key" 2>/dev/null)
            if [ "$PERMS" = "600" ]; then
                pass "SSH key $key has safe permissions"
            else
                fail "SSH key $key has unsafe permissions ($PERMS)"
            fi
        done
    else
        skip "SSH keys (none found)"
    fi
fi

echo ""

# ===========================================
# ASDF Configuration
# ===========================================
echo "## ASDF Configuration"

if [ -d "$HOME/.asdf" ]; then
    pass "ASDF is installed"

    # Verificar .asdfrc
    if [ -f "$HOME/.asdfrc" ]; then
        pass ".asdfrc exists"
    else
        skip ".asdfrc (not found)"
    fi

    # Verificar plugins
    if [ -f "$HOME/.asdf/asdf.sh" ]; then
        source "$HOME/.asdf/asdf.sh" 2>/dev/null || true

        if command -v asdf &> /dev/null; then
            PLUGIN_COUNT=$(asdf plugin list 2>/dev/null | wc -l)
            if [ "$PLUGIN_COUNT" -gt 0 ]; then
                pass "ASDF plugins installed ($PLUGIN_COUNT plugins)"
            else
                skip "ASDF plugins (none installed)"
            fi
        fi
    fi
else
    skip "ASDF (not installed)"
fi

echo ""

# ===========================================
# Emacs Configuration
# ===========================================
echo "## Emacs Configuration"

if [ -d "$HOME/dot/emacs" ]; then
    pass "Emacs config directory exists"

    # Verificar init.el
    if [ -f "$HOME/dot/emacs/init.el" ]; then
        pass "init.el exists"
    else
        fail "init.el does NOT exist"
    fi

    # Verificar straight.el
    if [ -d "$HOME/dot/emacs/straight" ]; then
        pass "straight.el package manager installed"
    else
        skip "straight.el (not installed)"
    fi
else
    skip "Emacs configuration (not found)"
fi

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
    echo -e "${GREEN}✓ All configuration tests passed!${NC}"
    exit 0
else
    echo -e "${RED}✗ Some configuration tests failed. Please review.${NC}"
    exit 1
fi
