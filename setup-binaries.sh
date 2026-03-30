#!/bin/bash
# Script para download e instalação de dependências binárias
# Uso: ./setup-binaries.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="$SCRIPT_DIR/bin"

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Criar diretório bin se não existir
mkdir -p "$BIN_DIR"

# ===============================================
# Arduino CLI
# ===============================================
install_arduino_cli() {
    log_info "Instalando Arduino CLI..."

    if [ -f "$BIN_DIR/arduino-cli" ]; then
        log_warn "Arduino CLI já existe em $BIN_DIR/arduino-cli"
        read -p "Deseja sobrescrever? (s/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Ss]$ ]]; then
            log_info "Pulando instalação do Arduino CLI"
            return
        fi
    fi

    ARDUINO_VERSION="latest"
    ARDUINO_URL="https://downloads.arduino.cc/arduino-cli/arduino-cli_${ARDUINO_VERSION}_Linux_64bit.tar.gz"

    log_info "Baixando Arduino CLI de $ARDUINO_URL..."
    curl -fsSL "$ARDUINO_URL" -o "/tmp/arduino-cli.tar.gz"

    log_info "Extraindo Arduino CLI..."
    tar -xzf "/tmp/arduino-cli.tar.gz" -C "$BIN_DIR"
    chmod +x "$BIN_DIR/arduino-cli"

    rm "/tmp/arduino-cli.tar.gz"
    log_info "Arduino CLI instalado com sucesso em $BIN_DIR/arduino-cli"
}

# ===============================================
# Menu principal
# ===============================================
show_menu() {
    echo ""
    echo "========================================="
    echo "  Setup de Dependências Binárias"
    echo "========================================="
    echo "1) Instalar Arduino CLI"
    echo "2) Sair"
    echo "========================================="
}

main() {
    if [ "$1" == "--all" ]; then
        install_arduino_cli
        exit 0
    fi

    while true; do
        show_menu
        read -p "Escolha uma opção: " choice

        case $choice in
            1)
                install_arduino_cli
                ;;
            2)
                log_info "Saindo..."
                exit 0
                ;;
            *)
                log_error "Opção inválida!"
                ;;
        esac
    done
}

# Executar
main "$@"
