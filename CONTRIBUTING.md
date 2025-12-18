# 🤝 Guia de Contribuição

Obrigado por considerar contribuir para o My Ubuntu Desktop! Este documento fornece diretrizes para contribuições.

## 📋 Índice

- [Como Contribuir](#como-contribuir)
- [Código de Conduta](#código-de-conduta)
- [Reportando Bugs](#reportando-bugs)
- [Sugerindo Features](#sugerindo-features)
- [Pull Requests](#pull-requests)
- [Estilo de Código](#estilo-de-código)
- [Commits](#commits)
- [Testes](#testes)
- [Documentação](#documentação)

---

## 🚀 Como Contribuir

Existem várias formas de contribuir:

### 1. 🐛 Reportar Bugs
Encontrou um problema? [Abra uma issue](https://github.com/pahagon/my-ubuntu-desktop/issues/new?template=bug_report.md)

### 2. 💡 Sugerir Features
Tem uma ideia? [Sugira uma feature](https://github.com/pahagon/my-ubuntu-desktop/issues/new?template=feature_request.md)

### 3. 📝 Melhorar Documentação
Documentação nunca é demais! PRs com melhorias na doc são sempre bem-vindos.

### 4. 💻 Contribuir com Código
- Corrigir bugs
- Adicionar novos playbooks Ansible
- Melhorar configurações existentes
- Adicionar suporte a novas ferramentas

### 5. 🧪 Testar
- Testar em diferentes versões do Ubuntu
- Validar playbooks
- Reportar problemas de compatibilidade

---

## 📜 Código de Conduta

Este projeto segue um código de conduta baseado no [Contributor Covenant](https://www.contributor-covenant.org/). Ao participar, você concorda em:

- **Ser respeitoso**: Trate todos com respeito
- **Ser inclusivo**: Aceite diferentes perspectivas
- **Ser colaborativo**: Trabalhe junto para o bem do projeto
- **Focar no que é melhor**: Pense no benefício da comunidade

Comportamentos inaceitáveis:
- Linguagem ofensiva ou discriminatória
- Assédio ou intimidação
- Ataques pessoais
- Publicação de informação privada de terceiros

**Reporte comportamento inadequado**: abra uma issue ou contate @pahagon.

---

## 🐛 Reportando Bugs

### Antes de Reportar

1. **Verifique a documentação**: Consulte [README](README.md), [FAQ](FAQ.md) e [TROUBLESHOOTING](TROUBLESHOOTING.md)
2. **Busque issues existentes**: Talvez já tenha sido reportado
3. **Teste na versão mais recente**: `git pull origin main`
4. **Reproduza em ambiente limpo**: Use VM se possível

### Como Reportar

Crie uma [nova issue](https://github.com/pahagon/my-ubuntu-desktop/issues/new) incluindo:

**Template de Bug Report**:

```markdown
## Descrição do Bug
[Descrição clara e concisa do problema]

## Como Reproduzir
Passos para reproduzir o comportamento:
1. Execute '...'
2. Veja o erro '...'

## Comportamento Esperado
[O que deveria acontecer]

## Comportamento Atual
[O que está acontecendo]

## Screenshots
[Se aplicável, adicione screenshots]

## Ambiente
- OS: Ubuntu 24.04 LTS
- Versão do projeto: [commit hash ou tag]
- Ansible version: [ansible --version]
- Playbook executado: [nome do playbook]

## Logs
```
[Cole aqui logs relevantes]
```

## Informações Adicionais
[Qualquer outra informação relevante]
```

---

## 💡 Sugerindo Features

### Antes de Sugerir

1. **Verifique se já existe**: Busque em issues fechadas e abertas
2. **Considere o escopo**: A feature se encaixa no projeto?
3. **Pense na implementação**: Como seria implementado?

### Como Sugerir

Crie uma [nova issue](https://github.com/pahagon/my-ubuntu-desktop/issues/new) incluindo:

**Template de Feature Request**:

```markdown
## Resumo da Feature
[Descrição curta e clara]

## Motivação
Por que esta feature é útil?
- Caso de uso 1
- Caso de uso 2

## Solução Proposta
Como você imagina que funcionaria?

## Alternativas Consideradas
Outras abordagens que você pensou?

## Informações Adicionais
[Screenshots, exemplos, links, etc.]
```

---

## 🔧 Pull Requests

### Processo

1. **Fork** o repositório
2. **Clone** seu fork: `git clone git@github.com:seu-usuario/my-ubuntu-desktop.git`
3. **Crie branch**: `git checkout -b feature/minha-feature`
4. **Faça mudanças**: Implemente sua feature/fix
5. **Teste**: Certifique-se que funciona
6. **Commit**: Use [conventional commits](#commits)
7. **Push**: `git push origin feature/minha-feature`
8. **Abra PR**: Via interface do GitHub

### Checklist de PR

Antes de abrir PR, certifique-se que:

- [ ] Código funciona e foi testado
- [ ] Segue o [estilo de código](#estilo-de-código)
- [ ] Commits seguem [conventional commits](#commits)
- [ ] Documentação foi atualizada (se necessário)
- [ ] README atualizado (se adicionou feature)
- [ ] Sem arquivos desnecessários commitados
- [ ] PR tem descrição clara

### Template de PR

```markdown
## Descrição
[Descreva suas mudanças]

## Motivação e Contexto
Por que esta mudança é necessária? Que problema resolve?

## Como foi testado?
Descreva como você testou suas mudanças:
- [ ] Testado em Ubuntu 24.04 LTS
- [ ] Testado em VM limpa
- [ ] Playbook executado sem erros
- [ ] Configuração funciona após reboot

## Tipo de mudança
- [ ] Bug fix (non-breaking change que corrige issue)
- [ ] New feature (non-breaking change que adiciona funcionalidade)
- [ ] Breaking change (fix ou feature que quebra funcionalidade existente)
- [ ] Documentação

## Screenshots (se aplicável)
[Adicione screenshots]

## Checklist
- [ ] Código segue estilo do projeto
- [ ] Comentei código complexo
- [ ] Atualizei documentação
- [ ] Minhas mudanças não geram novos warnings
- [ ] Testei em ambiente limpo
```

### Revisão

- PRs serão revisados pelo mantenedor
- Feedback será dado via comentários
- Mudanças podem ser solicitadas
- Após aprovação, PR será merged

---

## 🎨 Estilo de Código

### Ansible Playbooks

```yaml
---
# Nome descritivo
- name: Install Docker Engine
  hosts: localhost
  connection: local
  become: true
  vars_files:
    - common_vars.yml

  # Variáveis em snake_case
  vars:
    docker_version: "24.0"

  tasks:
    # Nome claro para cada tarefa
    - name: Add Docker GPG key
      apt_key:
        url: https://download.docker.com/linux/ubuntu/gpg
        state: present

    # Indentação: 2 espaços
    - name: Install Docker packages
      apt:
        name:
          - docker-ce
          - docker-ce-cli
        state: present
        update_cache: yes

    # Register para capturar output
    - name: Check Docker version
      command: docker --version
      register: docker_version_output
      changed_when: false

    # Debug quando útil
    - name: Display Docker version
      debug:
        msg: "Installed: {{ docker_version_output.stdout }}"
```

**Boas práticas**:
- Nomes descritivos para tarefas
- Use `changed_when: false` para comandos idempotentes
- Agrupe tarefas relacionadas
- Comente seções complexas
- Use variáveis para valores que mudam

### Bash

```bash
#!/bin/bash
# Descrição do script

# Use set -e para parar em erros
set -e

# Constantes em UPPER_CASE
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly CONFIG_FILE="$HOME/.config/myapp/config"

# Funções em snake_case
install_package() {
    local package_name="$1"

    echo "Installing $package_name..."
    sudo apt install -y "$package_name"
}

# Main
main() {
    if [ "$#" -ne 1 ]; then
        echo "Usage: $0 <package>"
        exit 1
    fi

    install_package "$1"
}

main "$@"
```

**Boas práticas**:
- Use `shellcheck` para validar
- Quote variáveis: `"$VAR"`
- Use `local` em funções
- Valide argumentos
- Retorne exit codes apropriados

### Documentação (Markdown)

```markdown
# Título (H1)

Parágrafo introdutório.

## Seção (H2)

### Subseção (H3)

**Bold** para ênfase, *itálico* para termos.

- Lista não ordenada
- Item 2
  - Subitem

1. Lista ordenada
2. Item 2

`código inline` para comandos.

\`\`\`bash
# Bloco de código
comando --flag
\`\`\`

[Links](https://example.com)

> Citação ou nota importante
```

**Boas práticas**:
- Um H1 por documento
- Use H2 para seções principais
- Código sempre em blocos ou inline
- Links descritivos
- Quebras de linha apropriadas

---

## 📝 Commits

Este projeto usa [Conventional Commits](https://www.conventionalcommits.org/).

### Formato

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- **feat**: Nova feature
- **fix**: Correção de bug
- **docs**: Mudanças na documentação
- **style**: Formatação, espaços (não muda código)
- **refactor**: Refatoração de código
- **perf**: Melhorias de performance
- **test**: Adição ou correção de testes
- **chore**: Tarefas de manutenção
- **ci**: Mudanças em CI/CD

### Exemplos

```bash
# Feature
feat(ansible): adiciona playbook para Rust

# Bug fix
fix(bash): corrige carregamento de aliases no WSL

# Documentação
docs(readme): atualiza instruções de instalação

# Chore
chore(gitignore): adiciona *.log ao gitignore

# Breaking change
feat(asdf)!: atualiza para ASDF v0.18.0

BREAKING CHANGE: Requer reinstalação do ASDF
```

### Boas Práticas

- **Imperativo**: "adiciona" não "adicionado" ou "adicionando"
- **Minúsculas**: subject em lowercase
- **Sem ponto final**: no final do subject
- **Limite**: 50 caracteres para subject
- **Body**: Explique o "porquê", não o "o quê"
- **Footer**: Para breaking changes ou close issues

```bash
# Bom
feat(vim): adiciona plugin para Go

# Ruim
feat(vim): Adicionado plugin para Go.
```

---

## 🧪 Testes

### Testar Playbooks

```bash
# 1. Validar sintaxe
ansible-playbook playbook.yml --syntax-check

# 2. Dry-run (não executa, apenas mostra o que faria)
ansible-playbook playbook.yml --check --ask-become-pass

# 3. Executar em VM
# Use VirtualBox ou Docker para testar isoladamente

# 4. Verificar idempotência
# Execute duas vezes, segunda vez não deve ter "changed"
ansible-playbook playbook.yml --ask-become-pass
ansible-playbook playbook.yml --ask-become-pass  # Deve ser idempotente
```

### Testar Bash Scripts

```bash
# Validar sintaxe
bash -n script.sh

# Shellcheck (static analysis)
shellcheck script.sh

# Executar com debug
bash -x script.sh

# Testar em ambiente limpo
docker run -it ubuntu:24.04 bash
# ... copiar e testar script
```

### Testar Dotfiles

```bash
# Criar usuário de teste
sudo useradd -m testuser
sudo su - testuser

# Clonar e testar
git clone https://github.com/seu-usuario/my-ubuntu-desktop.git ~/dot
cd ~/dot
./bootstrap

# Verificar symlinks
ls -la ~/.bashrc ~/.vimrc ~/.tmux.conf

# Testar configurações
bash --login
vim
tmux
```

---

## 📚 Documentação

### O que Documentar

Quando adicionar:
- **Novo playbook**: Adicione em `ansible/README.md`
- **Nova feature**: Atualize `README.md`
- **Nova configuração**: Documente em `CUSTOMIZATION.md`
- **Novo problema conhecido**: Adicione em `TROUBLESHOOTING.md`

### Como Documentar

```markdown
## Título da Feature

### O que faz
[Descrição clara]

### Como usar
\`\`\`bash
comando --exemplo
\`\`\`

### Exemplo
[Exemplo prático]

### Troubleshooting
Problema comum: Solução
```

### Documentação no Código

```yaml
---
# Playbook: Install Docker Engine
# Descrição: Instala Docker CE e Docker Compose
# Dependências: Ubuntu 24.04 LTS
# Autor: Nome <email>

- name: Install Docker
  hosts: localhost
  tasks:
    # Adiciona chave GPG do repositório oficial
    - name: Add Docker GPG key
      apt_key:
        url: https://download.docker.com/linux/ubuntu/gpg
```

---

## 🏆 Reconhecimento

Contribuidores serão reconhecidos:
- Nome no `README.md` (seção Agradecimentos)
- Menção nos release notes
- Co-autoria nos commits (se aplicável)

---

## 📞 Dúvidas?

- **Issues**: Para bugs e features
- **Discussions**: Para perguntas e discussões gerais
- **Email**: Para assuntos privados

---

## 📄 Licença

Ao contribuir, você concorda que suas contribuições serão licenciadas sob a mesma licença do projeto (MIT License).

---

**Obrigado por contribuir! 🎉**

Este projeto é mantido por [@pahagon](https://github.com/pahagon) e melhorado por [contribuidores incríveis](https://github.com/pahagon/my-ubuntu-desktop/graphs/contributors).

---

**Última atualização**: 2025-12-18
