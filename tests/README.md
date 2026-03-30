# 🧪 Testes - My Ubuntu Desktop

Este diretório contém a suíte completa de testes para validar a instalação, configuração e funcionamento do ambiente Ubuntu Desktop.

## 📁 Estrutura

```
tests/
├── unit/                  # Testes unitários (scripts individuais)
│   ├── test_setup_binaries.bats
│   ├── test_bash_functions.bats
│   └── test_bin_scripts.bats
├── integration/           # Testes de integração (Ansible)
│   ├── test_workstation.yml
│   ├── test_docker.yml
│   └── test_python.yml
├── smoke/                 # Smoke tests (validação rápida)
│   ├── test_all_installed.sh
│   └── test_configs.sh
└── README.md
```

## 🎯 Tipos de Testes

### 1. Testes Unitários (BATS)

Testam scripts bash individuais em isolamento.

**Framework**: [BATS (Bash Automated Testing System)](https://github.com/bats-core/bats-core)

**Instalação**:
```bash
# Ubuntu/Debian
sudo apt install bats

# Ou via npm
npm install -g bats
```

**Executar**:
```bash
# Todos os testes
bats tests/unit/

# Teste específico
bats tests/unit/test_setup_binaries.bats

# Com output verbose
bats -t tests/unit/
```

**Exemplo**:
```bash
# tests/unit/test_bash_functions.bats
@test "calc function exists" {
    source bash/rc
    type calc
}

@test "myip function returns IP" {
    source bash/rc
    run myip
    [ "$status" -eq 0 ]
}
```

### 2. Testes de Integração (Molecule)

Testam playbooks Ansible em containers Docker.

**Framework**: [Molecule](https://molecule.readthedocs.io/)

**Instalação**:
```bash
pip install molecule molecule-docker ansible-lint
```

**Executar**:
```bash
# Testar playbook específico
cd ansible
molecule test

# Apenas criar e convergir (sem destruir)
molecule converge

# Verificar idempotência
molecule idempotence

# Verificar testes
molecule verify
```

**Fluxo**:
1. **Create**: Cria container Docker
2. **Converge**: Executa playbook
3. **Verify**: Roda testes de verificação
4. **Idempotence**: Re-executa playbook (deve ser idempotente)
5. **Destroy**: Destroi container

### 3. Smoke Tests

Testes rápidos de sanidade após instalação.

**Executar**:
```bash
# Validar todas as ferramentas instaladas
./tests/smoke/test_all_installed.sh

# Validar configurações
./tests/smoke/test_configs.sh
```

**Objetivo**: Validar rapidamente que:
- Binários estão instalados
- Configurações foram aplicadas
- Symlinks estão corretos
- Ferramentas funcionam

## 🚀 Executar Todos os Testes

```bash
# Script master que roda tudo
make test

# Ou manualmente:
bats tests/unit/
cd ansible && molecule test
./tests/smoke/test_all_installed.sh
```

## 📊 Cobertura de Testes

### Situação Atual

| Componente | Testes | Cobertura | Status |
|-----------|--------|-----------|--------|
| **Bash Scripts** | BATS | 0% → 60% | 🟡 Em progresso |
| **Ansible Playbooks** | Molecule | 0% → 60% | 🟡 Em progresso |
| **Smoke Tests** | Shell | 0% → 80% | 🟡 Em progresso |
| **CI/CD** | GitHub Actions | 0% → 90% | 🟡 Em progresso |

### Meta v1.0

- ✅ Unit tests: 60% cobertura
- ✅ Integration tests: 60% cobertura
- ✅ Smoke tests: 80% cobertura
- ✅ CI/CD: Rodar todos os testes automaticamente

## 🎨 Convenções

### Nomenclatura

- **Unit tests**: `test_<component>.bats`
- **Integration tests**: `test_<playbook>.yml`
- **Smoke tests**: `test_<category>.sh`

### Estrutura de Teste BATS

```bash
#!/usr/bin/env bats

# Setup executado antes de cada teste
setup() {
    # Preparar ambiente
    export TEST_DIR="$(mktemp -d)"
}

# Teardown executado após cada teste
teardown() {
    # Limpar ambiente
    rm -rf "$TEST_DIR"
}

# Teste individual
@test "descrição do que está sendo testado" {
    # Arrange (preparar)
    local input="valor"

    # Act (executar)
    run comando "$input"

    # Assert (verificar)
    [ "$status" -eq 0 ]
    [[ "$output" =~ "esperado" ]]
}
```

### Estrutura de Teste Molecule

```yaml
# ansible/molecule/default/verify.yml
---
- name: Verify
  hosts: all
  tasks:
    - name: Check if tool is installed
      command: which <tool>
      register: tool_check
      changed_when: false
      failed_when: tool_check.rc != 0

    - name: Verify tool version
      shell: <tool> --version
      register: version
      changed_when: false

    - name: Assert version is correct
      assert:
        that:
          - version.stdout is search("expected_version")
```

## 🔍 Debugging Testes

### BATS

```bash
# Verbose output
bats -t tests/unit/test_file.bats

# Apenas um teste específico
bats -f "test name pattern" tests/unit/

# Com trace de comandos
bats -x tests/unit/test_file.bats
```

### Molecule

```bash
# Login no container para debug
molecule login

# Manter container após falha
molecule test --destroy=never

# Ver logs detalhados
molecule --debug test
```

## 📚 Referências

- [BATS Documentation](https://bats-core.readthedocs.io/)
- [Molecule Documentation](https://molecule.readthedocs.io/)
- [Ansible Testing Strategies](https://docs.ansible.com/ansible/latest/reference_appendices/test_strategies.html)
- [Testing Bash Scripts](https://github.com/sstephenson/bats/wiki/Tutorial)

## 🐛 Troubleshooting

### BATS não encontrado

```bash
# Instalar BATS
git clone https://github.com/bats-core/bats-core.git
cd bats-core
sudo ./install.sh /usr/local
```

### Molecule falha com Docker

```bash
# Verificar Docker está rodando
sudo systemctl status docker

# Adicionar usuário ao grupo docker
sudo usermod -aG docker $USER
newgrp docker

# Testar acesso
docker ps
```

### Teste falha em CI mas passa localmente

```bash
# Reproduzir ambiente CI localmente
docker run -it ubuntu:24.04 bash
# Rodar testes dentro do container
```

---

**Última atualização**: 2025-12-19
