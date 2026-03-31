#!/bin/bash
set -e

REPO_URL="https://github.com/pahagon/my-ubuntu-desktop.git"
DOT_DIR="$HOME/dot"

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log_info()  { echo -e "${GREEN}[INFO]${NC}  $1"; }
log_warn()  { echo -e "${YELLOW}[WARN]${NC}  $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# -----------------------------------------------
# Dependências base
# -----------------------------------------------
log_info "Atualizando apt e instalando dependências base..."
sudo apt update -qq
sudo apt install -y git ansible

# -----------------------------------------------
# Clonar repositório
# -----------------------------------------------
if [ -d "$DOT_DIR/.git" ]; then
    log_warn "Repositório já existe em $DOT_DIR. Atualizando..."
    git -C "$DOT_DIR" pull
elif [ -d "$DOT_DIR" ]; then
    log_error "$DOT_DIR existe mas não é um repositório Git. Remova ou renomeie o diretório e tente novamente."
    exit 1
else
    log_info "Clonando repositório em $DOT_DIR..."
    git clone "$REPO_URL" "$DOT_DIR"
fi

# -----------------------------------------------
# Executar playbook
# -----------------------------------------------
PLAYBOOK="${1:-desktop-minimal.yml}"

log_info "Executando ansible-playbook $PLAYBOOK..."
ansible-playbook "$DOT_DIR/ansible/$PLAYBOOK" -K
