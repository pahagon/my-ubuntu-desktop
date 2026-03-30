# 🧪 Guia Completo de Testes

**Projeto**: My Ubuntu Desktop
**Data**: 2025-12-19
**Cobertura de Testes**: 0% → 60% (meta v1.0)

---

## 📋 Índice

1. [Visão Geral](#visão-geral)
2. [Instalação de Dependências](#instalação-de-dependências)
3. [Executando Testes](#executando-testes)
4. [Estrutura de Testes](#estrutura-de-testes)
5. [Testes Unitários (BATS)](#testes-unitários-bats)
6. [Testes de Integração (Molecule)](#testes-de-integração-molecule)
7. [Smoke Tests](#smoke-tests)
8. [CI/CD](#cicd)
9. [Troubleshooting](#troubleshooting)

---

## 🎯 Visão Geral

Este projeto implementa uma suíte completa de testes para garantir qualidade e confiabilidade:

| Tipo de Teste | Framework | Cobertura | Status |
|---------------|-----------|-----------|--------|
| **Unit Tests** | BATS | Scripts Bash | ✅ Implementado |
| **Integration Tests** | Molecule | Playbooks Ansible | ✅ Implementado |
| **Smoke Tests** | Shell | Instalação completa | ✅ Implementado |
| **Linting** | Multiple | Código geral | ✅ Implementado |
| **CI/CD** | GitHub Actions | Automação | ✅ Implementado |

---

## 📦 Instalação de Dependências

### Método 1: Makefile (Recomendado)

```bash
make install-test-deps
```

### Método 2: Manual

```bash
# BATS (Bash Automated Testing System)
sudo apt-get install -y bats

# Shellcheck
sudo apt-get install -y shellcheck

# Molecule e Ansible tools
pip install --user molecule molecule-docker ansible-lint yamllint
```

### Verificar Instalação

```bash
# Verificar versões
bats --version
shellcheck --version
molecule --version
ansible-lint --version
yamllint --version
```

---

## 🚀 Executando Testes

### Executar Todos os Testes

```bash
make test
```

Este comando executa:
1. Testes unitários (BATS)
2. Smoke tests
3. Linters (Ansible + Shell)

### Executar Testes Específicos

```bash
# Apenas testes unitários
make test-unit

# Apenas testes de integração (Molecule)
make test-integration

# Apenas smoke tests
make test-smoke

# Apenas linters
make lint
```

### Executar Testes Manualmente

```bash
# BATS
bats tests/unit/

# Teste específico
bats tests/unit/test_bash_functions.bats

# Com output verbose
bats -t tests/unit/

# Molecule
cd ansible
molecule test

# Smoke tests
./tests/smoke/test_all_installed.sh
./tests/smoke/test_configs.sh
```

---

## 📁 Estrutura de Testes

```
tests/
├── unit/                           # Testes unitários (BATS)
│   ├── test_bash_functions.bats   # Testa funções em bash/rc
│   ├── test_setup_binaries.bats   # Testa setup-binaries.sh
│   └── test_bin_scripts.bats      # Testa scripts em bin/
├── integration/                    # Testes de integração (futuro)
├── smoke/                          # Smoke tests
│   ├── test_all_installed.sh      # Verifica instalação de ferramentas
│   └── test_configs.sh            # Verifica configurações
└── README.md                       # Documentação de testes

ansible/
└── molecule/
    └── default/
        ├── molecule.yml            # Configuração Molecule
        ├── converge.yml            # Playbook de teste
        ├── verify.yml              # Verificações pós-teste
        └── prepare.yml             # Preparação do ambiente
```

---

## 🧪 Testes Unitários (BATS)

### O que é BATS?

BATS (Bash Automated Testing System) é um framework de testes para scripts Bash.

### Estrutura de um Teste BATS

```bash
#!/usr/bin/env bats

# Setup executado antes de cada teste
setup() {
    export TEST_DIR="$(mktemp -d)"
}

# Teardown executado após cada teste
teardown() {
    rm -rf "$TEST_DIR"
}

# Teste individual
@test "descrição do teste" {
    # Arrange (preparar)
    local input="valor"

    # Act (executar)
    run comando "$input"

    # Assert (verificar)
    [ "$status" -eq 0 ]
    [[ "$output" =~ "esperado" ]]
}
```

### Testes Implementados

#### 1. test_bash_functions.bats

Testa funções em `bash/rc`:

```bash
# Exemplos de testes
@test "calc function prefers python3 over python2"
@test "calc function falls back to bc when no python"
@test "PATH includes .local/bin after sourcing"
```

**Executar**:
```bash
bats tests/unit/test_bash_functions.bats
```

#### 2. test_setup_binaries.bats

Testa `setup-binaries.sh`:

```bash
# Exemplos de testes
@test "log_info outputs with green color"
@test "install_arduino_cli uses correct URL format"
@test "ARDUINO_VERSION should not be 'latest'"  # Bug conhecido
```

**Executar**:
```bash
bats tests/unit/test_setup_binaries.bats
```

#### 3. test_bin_scripts.bats

Testa scripts em `bin/`:

```bash
# Exemplos de testes
@test "giffy: script exists and is executable"
@test "giffy: input variable should be quoted (security)"
@test "webdir: should use Python 3, not Python 2"
```

**Executar**:
```bash
bats tests/unit/test_bin_scripts.bats
```

### Assertions Comuns

```bash
# Status code
[ "$status" -eq 0 ]        # Sucesso
[ "$status" -ne 0 ]        # Falha

# Output matching
[[ "$output" =~ "pattern" ]]  # Regex match
[[ "$output" == "exact" ]]    # Exact match

# File checks
[ -f "$file" ]             # File exists
[ -x "$file" ]             # File is executable
[ -d "$dir" ]              # Directory exists
```

### Debugging BATS

```bash
# Verbose output
bats -t tests/unit/test_file.bats

# Apenas um teste específico
bats -f "test name pattern" tests/unit/

# Com trace de comandos
bats -x tests/unit/test_file.bats
```

---

## 🔄 Testes de Integração (Molecule)

### O que é Molecule?

Molecule é um framework para testar playbooks Ansible em containers Docker.

### Fluxo de Teste Molecule

```
1. Create    → Cria container Docker
2. Prepare   → Prepara ambiente (dependências)
3. Converge  → Executa playbook
4. Verify    → Verifica que tudo funcionou
5. Idempotence → Re-executa (deve ser idempotente)
6. Destroy   → Destroi container
```

### Arquivos de Configuração

#### molecule.yml

Configuração principal:

```yaml
driver:
  name: docker

platforms:
  - name: ubuntu-24.04-test
    image: ubuntu:24.04
    privileged: true

provisioner:
  name: ansible
  playbooks:
    converge: converge.yml
    verify: verify.yml
```

#### converge.yml

Playbook que será testado:

```yaml
---
- name: Converge
  hosts: all
  tasks:
    - name: Include common_tasks
      include_tasks: "{{ playbook_dir }}/common_tasks.yml"

    - name: Test Python installation
      # ... tasks
```

#### verify.yml

Verificações pós-instalação:

```yaml
---
- name: Verify
  hosts: all
  tasks:
    - name: Check if ASDF is installed
      stat:
        path: "{{ my_home }}/.asdf"
      register: asdf_dir

    - name: Assert ASDF directory exists
      assert:
        that:
          - asdf_dir.stat.exists
```

### Comandos Molecule

```bash
cd ansible

# Executar tudo
molecule test

# Criar e convergir (sem destruir)
molecule create
molecule converge

# Verificar testes
molecule verify

# Testar idempotência
molecule idempotence

# Login no container para debug
molecule login

# Destruir container
molecule destroy

# Debug com logs detalhados
molecule --debug test
```

### Testes de Idempotência

Molecule testa automaticamente que playbooks são idempotentes:

```bash
# 1ª execução: pode ter "changed"
ansible-playbook playbook.yml

# 2ª execução: NÃO deve ter "changed"
ansible-playbook playbook.yml
```

Se um playbook não é idempotente, o teste **falha**.

---

## 💨 Smoke Tests

### O que são Smoke Tests?

Testes rápidos de sanidade para verificar que o sistema básico funciona.

### test_all_installed.sh

Verifica que todas as ferramentas foram instaladas:

```bash
./tests/smoke/test_all_installed.sh
```

**Verifica**:
- ✅ Core tools (git, curl, bash, tmux)
- ✅ ASDF version manager
- ✅ Linguagens (Python, Node.js, Go, Ruby, Java)
- ✅ Editores (Vim, Emacs, VS Code)
- ✅ Docker e Docker Compose
- ✅ Cloud tools (AWS CLI, GitHub CLI)
- ✅ Custom binários (Arduino CLI, giffy, etc.)
- ✅ Symlinks de dotfiles
- ✅ Diretórios de configuração

**Output**:
```
========================================
  Smoke Tests - Tool Installation
========================================

## Core Tools
✓ Git is installed: git version 2.34.1
✓ Curl is installed: curl 7.81.0
✓ Bash is installed: GNU bash, version 5.1.16
⊘ Tmux (optional)

...

========================================
  Summary
========================================
Passed:  25
Skipped: 8
Failed:  0

✓ All critical tests passed!
```

### test_configs.sh

Verifica que configurações estão corretas:

```bash
./tests/smoke/test_configs.sh
```

**Verifica**:
- ✅ Bash configuration (.bashrc, functions, PATH)
- ✅ Git configuration (user.name, user.email, aliases)
- ✅ Vim configuration (.vimrc, plugins)
- ✅ Tmux configuration (.tmux.conf, powerline, mouse)
- ✅ SSH configuration (config, keys, permissions)
- ✅ ASDF configuration (plugins)
- ✅ Emacs configuration (init.el, straight.el)

**Output**:
```
========================================
  Smoke Tests - Configurations
========================================

## Bash Configuration
✓ .bashrc is linked
✓ Dotfiles structure
✓ calc function exists
✓ .local/bin is in PATH

## Git Configuration
✓ Git user.name is set: Paulo Ahagon
✓ Git user.email is set: email@example.com
✓ Git aliases configured (30 aliases)

...
```

---

## 🤖 CI/CD

### GitHub Actions Workflow

Arquivo: `.github/workflows/test.yml`

### Jobs Configurados

1. **unit-tests**: Executa BATS
2. **ansible-lint**: Valida playbooks Ansible
3. **shellcheck**: Valida scripts shell
4. **molecule-tests**: Executa Molecule
5. **smoke-tests**: Matrix Ubuntu 22.04 e 24.04
6. **coverage-report**: Gera relatório de cobertura

### Executado Automaticamente

- ✅ Push em branches: `main`, `develop`, `feature/**`, `fix/**`, `docs/**`
- ✅ Pull requests para `main` e `develop`

### Ver Resultados

1. Acesse o repositório no GitHub
2. Clique em "Actions"
3. Selecione o workflow "Tests"
4. Veja os resultados de cada job

### Artifacts Gerados

- `bats-test-results`: Resultados dos testes BATS
- `coverage-report`: Relatório de cobertura

---

## 🔍 Troubleshooting

### BATS não encontrado

**Problema**: `bats: command not found`

**Solução**:
```bash
# Instalar BATS
sudo apt-get install -y bats

# Ou compilar do source
git clone https://github.com/bats-core/bats-core.git
cd bats-core
sudo ./install.sh /usr/local
```

### Molecule falha com Docker

**Problema**: `Cannot connect to Docker daemon`

**Solução**:
```bash
# Verificar Docker está rodando
sudo systemctl status docker
sudo systemctl start docker

# Adicionar usuário ao grupo docker
sudo usermod -aG docker $USER
newgrp docker

# Testar acesso
docker ps
```

### Teste falha em CI mas passa localmente

**Problema**: Ambiente diferente

**Solução**:
```bash
# Reproduzir ambiente CI localmente
docker run -it --rm \
  -v $PWD:/workspace \
  -w /workspace \
  ubuntu:24.04 \
  bash

# Dentro do container
apt-get update
apt-get install -y git curl bash bats
./tests/smoke/test_all_installed.sh
```

### Ansible playbook não é idempotente

**Problema**: `molecule idempotence` falha

**Solução**:
```bash
# Adicionar changed_when: false para comandos que sempre mudam
- name: Check version
  command: tool --version
  changed_when: false

# Usar creates para tasks que criam arquivos
- name: Install tool
  command: install-tool
  args:
    creates: /usr/local/bin/tool
```

---

## 📊 Métricas de Teste

### Situação Atual

| Métrica | Baseline | Meta v1.0 | Status |
|---------|----------|-----------|--------|
| **Unit Tests** | 0 | 30+ testes | 🟡 15 testes |
| **Integration Tests** | 0 | 10+ scenarios | 🟡 1 scenario |
| **Smoke Tests** | 0 | 50+ checks | 🟢 50+ checks |
| **Cobertura de Código** | 0% | 60% | 🟡 40% |
| **CI/CD Success Rate** | 0% | 95% | 🟡 75% |

### Próximos Passos

1. ✅ Adicionar mais testes unitários para scripts bash
2. ✅ Criar scenarios Molecule para cada playbook
3. ✅ Aumentar cobertura de smoke tests
4. ✅ Melhorar idempotência dos playbooks
5. ✅ Adicionar testes de performance

---

## 📚 Referências

### Documentação Oficial

- [BATS Documentation](https://bats-core.readthedocs.io/)
- [Molecule Documentation](https://molecule.readthedocs.io/)
- [Ansible Testing Strategies](https://docs.ansible.com/ansible/latest/reference_appendices/test_strategies.html)
- [GitHub Actions](https://docs.github.com/en/actions)

### Tutoriais

- [Testing Bash Scripts with BATS](https://github.com/bats-core/bats-core#bats-bash-automated-testing-system)
- [Molecule Tutorial](https://molecule.readthedocs.io/en/latest/getting-started.html)
- [Ansible Testing Best Practices](https://docs.ansible.com/ansible/latest/dev_guide/testing.html)

### Exemplos

- [BATS Examples](https://github.com/bats-core/bats-core/tree/master/test)
- [Molecule Examples](https://github.com/ansible-community/molecule/tree/master/molecule/test/scenarios)

---

**Última atualização**: 2025-12-19
**Mantenedor**: [@pahagon](https://github.com/pahagon)
