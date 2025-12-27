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
        read -r -p "Deseja sobrescrever? (s/N): " -n 1 REPLY
        echo
        if [[ ! $REPLY =~ ^[Ss]$ ]]; then
            log_info "Pulando instalação do Arduino CLI"
            return
        fi
    fi

    ARDUINO_VERSION="0.35.3"
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
# Cursor IDE
# ===============================================
install_cursor() {
    log_info "Instalando Cursor IDE..."

    # Detectar a última versão instalada
    LATEST_CURSOR=$(find "$BIN_DIR" -maxdepth 1 -name "Cursor-*.AppImage" 2>/dev/null | sort -V | tail -n1)

    if [ -n "$LATEST_CURSOR" ]; then
        log_warn "Cursor já instalado: $(basename "$LATEST_CURSOR")"
        read -r -p "Deseja baixar a versão mais recente? (s/N): " -n 1 REPLY
        echo
        if [[ ! $REPLY =~ ^[Ss]$ ]]; then
            log_info "Pulando instalação do Cursor"
            return
        fi
    fi

    # URL da última versão do Cursor (pode variar - verificar site oficial)
    log_info "Buscando última versão do Cursor..."
    CURSOR_URL="https://downloader.cursor.sh/linux/appImage/x64"

    log_info "Baixando Cursor IDE..."
    CURSOR_FILE="$BIN_DIR/Cursor-latest.AppImage"

    if curl -fsSL "$CURSOR_URL" -o "$CURSOR_FILE"; then
        chmod +x "$CURSOR_FILE"
        log_info "Cursor instalado com sucesso em $CURSOR_FILE"
        log_info "Você pode renomear o arquivo para incluir a versão específica"
    else
        log_error "Falha ao baixar Cursor IDE"
        rm -f "$CURSOR_FILE"
        return 1
    fi
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
    echo "2) Instalar Cursor IDE"
    echo "3) Instalar tudo"
    echo "4) Sair"
    echo "========================================="
}

main() {
    if [ "$1" == "--all" ]; then
        install_arduino_cli
        install_cursor
        exit 0
    fi

    while true; do
        show_menu
        read -r -p "Escolha uma opção: " choice

        case $choice in
            1)
                install_arduino_cli
                ;;
            2)
                install_cursor
                ;;
            3)
                install_arduino_cli
                install_cursor
                ;;
            4)
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
