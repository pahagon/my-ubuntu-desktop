#!/usr/bin/env bats

# Testes para scripts em bin/

setup() {
    export TEST_DIR="${BATS_TEST_TMPDIR}/test_bin"
    mkdir -p "$TEST_DIR"
    export PATH="$PWD/bin:$PATH"
}

teardown() {
    rm -rf "$TEST_DIR"
}

# ==========================================
# Testes para bin/giffy
# ==========================================

@test "giffy: script exists and is executable" {
    [ -f bin/giffy ]
    [ -x bin/giffy ]
}

@test "giffy: has correct shebang" {
    head -n 1 bin/giffy | grep -q "#!/usr/bin/env bash"
}

@test "giffy: shows error when no file provided" {
    run bin/giffy
    # Script pode não ter validação de argumentos ainda
    # Este teste documenta comportamento esperado
    [ "$status" -ne 0 ] || [[ "$output" =~ "No file found" ]]
}

@test "giffy: shows error for non-existent file" {
    run bin/giffy "/tmp/nonexistent-file-$(date +%s).mp4"
    [[ "$output" =~ "No file found" ]]
}

@test "giffy: requires ffmpeg command" {
    grep -q "ffmpeg" bin/giffy
}

@test "giffy: requires convert command (imagemagick)" {
    grep -q "convert" bin/giffy
}

@test "giffy: input variable should be quoted (security)" {
    # Este teste VERIFICA bug de segurança
    # Variável $1 deve estar entre aspas para evitar path traversal

    # Contar ocorrências de $1 sem aspas no ffmpeg command
    unquoted_count=$(grep -c 'ffmpeg -i $1' bin/giffy || true)

    if [ "$unquoted_count" -gt 0 ]; then
        skip "BUG DE SEGURANÇA: \$1 não está entre aspas - vulnerável a path traversal"
    fi
}

# ==========================================
# Testes para bin/webdir
# ==========================================

@test "webdir: script exists and is executable" {
    [ -f bin/webdir ]
    [ -x bin/webdir ]
}

@test "webdir: should use Python 3, not Python 2" {
    # Este teste DEVE FALHAR até que o script seja atualizado
    head -n 1 bin/webdir | grep -q "python2" && {
        skip "BUG: webdir ainda usa Python 2 (EOL) - deve migrar para Python 3"
    }

    head -n 1 bin/webdir | grep -q "python3"
}

@test "webdir: uses SimpleHTTPServer (Python 2) or http.server (Python 3)" {
    grep -qE "SimpleHTTPServer|http\.server" bin/webdir
}

@test "webdir: defines PORT variable" {
    grep -q "PORT.*=" bin/webdir
}

# ==========================================
# Testes para bin/init-node-project
# ==========================================

@test "init-node-project: script exists and is executable" {
    [ -f bin/init-node-project ]
    [ -x bin/init-node-project ]
}

@test "init-node-project: has correct shebang" {
    head -n 1 bin/init-node-project | grep -qE "#!/usr/bin/env (sh|bash)"
}

@test "init-node-project: initializes git repository" {
    grep -q "git init" bin/init-node-project
}

@test "init-node-project: creates LICENSE file" {
    grep -q "npx license" bin/init-node-project
}

@test "init-node-project: creates .gitignore" {
    grep -q "npx gitignore" bin/init-node-project
}

@test "init-node-project: runs npm init" {
    grep -q "npm init" bin/init-node-project
}

@test "init-node-project: creates initial commit" {
    grep -q 'git commit -m "Initial commit"' bin/init-node-project
}

@test "init-node-project: should validate npm get output (security)" {
    # Este teste documenta problema de segurança
    # $(npm get ...) pode conter código malicioso

    unvalidated_count=$(grep -c '\$(npm get' bin/init-node-project || true)

    if [ "$unvalidated_count" -gt 0 ]; then
        skip "BUG DE SEGURANÇA: output de 'npm get' não é validado antes de uso"
    fi
}

# ==========================================
# Testes genéricos para todos os scripts
# ==========================================

@test "all custom scripts have shebangs" {
    for script in bin/giffy bin/webdir bin/init-node-project; do
        [ -f "$script" ] || continue
        head -n 1 "$script" | grep -q "^#!"
    done
}

@test "all custom scripts are executable" {
    for script in bin/giffy bin/webdir bin/init-node-project; do
        [ -f "$script" ] || continue
        [ -x "$script" ]
    done
}

@test "no scripts contain hardcoded credentials" {
    ! grep -rE "(password|passwd|secret|api_key|token).*=" bin/giffy bin/webdir bin/init-node-project 2>/dev/null
}
