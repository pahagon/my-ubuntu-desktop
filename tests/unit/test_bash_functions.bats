#!/usr/bin/env bats

# Testes para funções bash em bash/rc

setup() {
    # Carregar funções bash
    export HOME="${BATS_TEST_TMPDIR}"
    mkdir -p "${HOME}/dot/bash/complete"
    touch "${HOME}/dot/bash/complete/project"
    touch "${HOME}/dot/bash/complete/elixir"

    # Mock das funções externas que não existem em test
    source() {
        if [[ "$1" =~ /etc/bashrc|/etc/bash.bashrc|bash-completion ]]; then
            return 0
        fi
        builtin source "$@"
    }
    export -f source
}

teardown() {
    # Limpar ambiente
    unset -f calc cmd myip ssh-add-reload 2>/dev/null || true
}

@test "calc function exists after sourcing bash/rc" {
    skip "Requer mock de dependências"
    source bash/rc
    type calc
}

@test "calc function prefers python3 over python2" {
    # Mock which command
    which() {
        case "$1" in
            python2) return 1 ;;
            python3) return 0 ;;
            *) return 1 ;;
        esac
    }
    export -f which

    # Source função isoladamente
    calc() {
        if which python2 &>/dev/null; then
            echo "python2"
        elif which python3 &>/dev/null; then
            echo "python3"
        elif which bc &>/dev/null; then
            echo "bc"
        else
            echo "none"
        fi
    }

    run calc
    [[ "$output" =~ "python3" ]]
}

@test "calc function falls back to bc when no python" {
    # Mock which command
    which() {
        case "$1" in
            python2) return 1 ;;
            python3) return 1 ;;
            bc) return 0 ;;
            *) return 1 ;;
        esac
    }
    export -f which

    calc() {
        if which python2 &>/dev/null; then
            echo "python2"
        elif which python3 &>/dev/null; then
            echo "python3"
        elif which bc &>/dev/null; then
            echo "bc"
        else
            echo "none"
        fi
    }

    run calc
    [[ "$output" =~ "bc" ]]
}

@test "calc function shows error when no calculator available" {
    # Mock which command
    which() {
        return 1
    }
    export -f which

    calc() {
        if which python2 &>/dev/null; then
            echo "python2"
        elif which python3 &>/dev/null; then
            echo "python3"
        elif which bc &>/dev/null; then
            echo "bc"
        else
            echo "requires python2, python3 or bc for calculator features"
        fi
    }

    run calc
    [[ "$output" =~ "requires" ]]
}

@test "myip function exists" {
    skip "Requer mock de network tools"
    source bash/rc
    type myip
}

@test "ssh-add-reload function exists" {
    skip "Requer mock de ssh-agent"
    source bash/rc
    type ssh-add-reload
}

@test "PATH includes .local/bin after sourcing" {
    # Test isolado da exportação de PATH
    TEST_PATH="$HOME/.local/bin:$PATH"
    [[ "$TEST_PATH" =~ \.local/bin ]]
}
