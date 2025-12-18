# 🌳 Estratégia de Branching

Este documento define a estratégia de branching e workflow de desenvolvimento para o My Ubuntu Desktop.

## 📋 Índice

- [Visão Geral](#visão-geral)
- [Estrutura de Branches](#estrutura-de-branches)
- [Workflow de Desenvolvimento](#workflow-de-desenvolvimento)
- [Nomenclatura de Branches](#nomenclatura-de-branches)
- [Proteção de Branches](#proteção-de-branches)
- [Releases](#releases)
- [Exemplos Práticos](#exemplos-práticos)

---

## 🎯 Visão Geral

Este projeto utiliza uma estratégia de branching simplificada baseada em **trunk-based development** com **feature branches de curta duração**.

### Por que Trunk-Based Development?

- **Simplicidade**: Apenas um branch principal (main)
- **Integração contínua**: Mudanças são integradas frequentemente
- **Menos conflitos**: Branches de curta duração reduzem merge conflicts
- **Deploy rápido**: main está sempre em estado deployável
- **Ideal para projetos pessoais**: Overhead mínimo de gerenciamento

---

## 🌿 Estrutura de Branches

### Branch Principal

**`main`**
- **Propósito**: Branch principal e fonte da verdade
- **Status**: Sempre estável e deployável
- **Proteção**: Requer Pull Request para mudanças
- **Commits diretos**: ❌ Não permitido
- **Base para**: Todos os feature branches

### Branches Temporários

**Feature Branches**
- **Formato**: `feature/<nome-descritivo>`
- **Duração**: Curta (1-7 dias idealmente)
- **Origem**: Criados a partir de `main`
- **Destino**: Merged de volta para `main` via PR
- **Deletados**: Após merge bem-sucedido

**Fix Branches**
- **Formato**: `fix/<nome-do-bug>`
- **Duração**: Muito curta (1-3 dias)
- **Propósito**: Corrigir bugs
- **Destino**: Merged para `main` via PR

**Docs Branches**
- **Formato**: `docs/<topico>`
- **Duração**: Curta (1-5 dias)
- **Propósito**: Melhorias de documentação
- **Destino**: Merged para `main` via PR

**Chore Branches**
- **Formato**: `chore/<tarefa>`
- **Duração**: Curta
- **Propósito**: Manutenção, refatoração, etc.
- **Destino**: Merged para `main` via PR

---

## 🔄 Workflow de Desenvolvimento

### 1. Começar Nova Feature

```bash
# 1. Atualizar main
git checkout main
git pull origin main

# 2. Criar feature branch
git checkout -b feature/minha-nova-feature

# 3. Fazer mudanças
# ... editar arquivos ...

# 4. Commit seguindo Conventional Commits
git add .
git commit -m "feat: adiciona suporte para Rust via ASDF"

# 5. Push do branch
git push -u origin feature/minha-nova-feature
```

### 2. Abrir Pull Request

```bash
# Via GitHub CLI
gh pr create --base main \
  --title "feat: Adiciona suporte para Rust" \
  --body "Descrição detalhada das mudanças..."

# Ou via interface web do GitHub
```

### 3. Revisão e Merge

```bash
# Após aprovação do PR (automático ou manual):
# - PR é merged para main
# - Branch é deletado automaticamente (opcional no GitHub)

# Localmente, atualizar main e limpar
git checkout main
git pull origin main
git branch -d feature/minha-nova-feature
git remote prune origin
```

### 4. Sincronizar com Main Frequentemente

```bash
# Se sua feature branch está desatualizada:
git checkout feature/minha-feature
git fetch origin
git rebase origin/main  # Ou: git merge origin/main

# Resolver conflitos se houver
# Continuar desenvolvimento
```

---

## 📝 Nomenclatura de Branches

### Formato Geral

```
<type>/<short-description>
```

### Types Aceitos

| Type | Descrição | Exemplo |
|------|-----------|---------|
| `feature/` | Nova funcionalidade | `feature/ansible-rust-playbook` |
| `fix/` | Correção de bug | `fix/asdf-path-loading` |
| `docs/` | Documentação | `docs/improve-readme` |
| `chore/` | Manutenção | `chore/update-dependencies` |
| `refactor/` | Refatoração | `refactor/bash-config-structure` |
| `test/` | Testes | `test/ansible-playbook-validation` |
| `perf/` | Performance | `perf/emacs-startup-time` |

### Regras de Nomenclatura

✅ **Bom**:
- `feature/docker-compose-support`
- `fix/tmux-clipboard-paste`
- `docs/add-faq-section`
- `chore/update-asdf-plugins`

❌ **Ruim**:
- `my-feature` (sem tipo)
- `feature/Feature_Add_Docker` (PascalCase)
- `fix/bug` (muito genérico)
- `feature/adiciona-suporte-rust` (não use acentos)

### Boas Práticas

- **Lowercase**: Use apenas minúsculas
- **Hífens**: Use `-` para separar palavras, não `_` ou espaços
- **Descritivo**: Nome deve ser claro e autoexplicativo
- **Curto**: Máximo 50 caracteres
- **Sem caracteres especiais**: Apenas `a-z`, `0-9` e `-`

---

## 🔒 Proteção de Branches

### Configurações do Branch `main`

Recomendações de proteção (configurar no GitHub):

#### Regras de Proteção
- ✅ **Require pull request before merging**: Sempre usar PR
- ✅ **Require approvals**: 1 aprovação (para projetos colaborativos)
- ✅ **Dismiss stale reviews**: Invalidar aprovações antigas
- ✅ **Require status checks**: CI/CD deve passar
- ✅ **Require branches to be up to date**: Branch deve estar atualizado
- ✅ **Include administrators**: Regras aplicam a todos

#### O que NÃO permitir
- ❌ **Commits diretos**: Ninguém commita diretamente no main
- ❌ **Force push**: Nunca fazer `git push --force` no main
- ❌ **Delete branch**: main não pode ser deletado

### Configurar Proteção

```bash
# Via GitHub CLI
gh api repos/:owner/:repo/branches/main/protection \
  --method PUT \
  --field required_pull_request_reviews[required_approving_review_count]=1 \
  --field enforce_admins=true \
  --field required_status_checks[strict]=true

# Ou configure via:
# GitHub.com → Settings → Branches → Add rule
```

---

## 🏷️ Releases

### Estratégia de Release

Este projeto usa **tags Git** para marcar releases:

```bash
# Formato: v<major>.<minor>.<patch>
# Exemplo: v1.0.0, v1.1.0, v2.0.0
```

### Semantic Versioning

Seguimos [Semantic Versioning 2.0.0](https://semver.org/):

- **MAJOR** (v1.0.0 → v2.0.0): Breaking changes
- **MINOR** (v1.0.0 → v1.1.0): Nova funcionalidade, backward compatible
- **PATCH** (v1.0.0 → v1.0.1): Bug fixes, backward compatible

### Criar Release

```bash
# 1. Atualizar main
git checkout main
git pull origin main

# 2. Criar tag
git tag -a v1.0.0 -m "Release v1.0.0: Initial stable release"

# 3. Push da tag
git push origin v1.0.0

# 4. Criar release no GitHub
gh release create v1.0.0 \
  --title "v1.0.0 - Initial Stable Release" \
  --notes "## What's Changed
- Feature 1
- Feature 2
- Bug fix 3"
```

### Release Notes

Cada release deve ter:
- **Título**: Versão e título descritivo
- **What's Changed**: Lista de mudanças principais
- **New Contributors**: Novos contribuidores (se houver)
- **Full Changelog**: Link para diff entre versões

**Exemplo**: Ver [GitHub Releases](https://github.com/pahagon/my-ubuntu-desktop/releases)

---

## 💡 Exemplos Práticos

### Exemplo 1: Adicionar Nova Feature

```bash
# Cenário: Adicionar playbook Ansible para Rust

# 1. Criar branch
git checkout main
git pull origin main
git checkout -b feature/ansible-rust-support

# 2. Criar arquivo
vim ansible/rust.yml
# ... adicionar conteúdo ...

# 3. Testar
ansible-playbook ansible/rust.yml --check

# 4. Commit
git add ansible/rust.yml
git commit -m "feat(ansible): adiciona playbook para instalação do Rust via ASDF"

# 5. Push e criar PR
git push -u origin feature/ansible-rust-support
gh pr create --base main --title "feat: Adiciona suporte para Rust via ASDF"

# 6. Após merge, limpar
git checkout main
git pull origin main
git branch -d feature/ansible-rust-support
```

### Exemplo 2: Corrigir Bug

```bash
# Cenário: Bash aliases não carregam no WSL

# 1. Criar branch de fix
git checkout main
git pull origin main
git checkout -b fix/bash-aliases-wsl

# 2. Investigar e corrigir
vim bash/rc
# ... fazer correção ...

# 3. Testar
source ~/.bashrc
# Verificar se aliases funcionam

# 4. Commit
git add bash/rc
git commit -m "fix(bash): corrige carregamento de aliases no WSL

Adiciona verificação de $WSL_DISTRO_NAME antes de carregar aliases
para garantir compatibilidade com Windows Subsystem for Linux."

# 5. Push e PR
git push -u origin fix/bash-aliases-wsl
gh pr create --base main --title "fix: Corrige carregamento de aliases no WSL"

# 6. Após merge
git checkout main
git pull origin main
git branch -d fix/bash-aliases-wsl
```

### Exemplo 3: Melhorar Documentação

```bash
# Cenário: Adicionar seção de troubleshooting no README

# 1. Branch de docs
git checkout -b docs/expand-troubleshooting

# 2. Editar
vim TROUBLESHOOTING.md
# ... adicionar novos problemas e soluções ...

# 3. Commit
git add TROUBLESHOOTING.md
git commit -m "docs: expande guia de troubleshooting com 10 novos casos

Adiciona soluções para:
- Docker permission denied
- ASDF command not found
- Emacs slow startup
..."

# 4. PR
git push -u origin docs/expand-troubleshooting
gh pr create --base main --title "docs: Expande guia de troubleshooting"
```

### Exemplo 4: Trabalhar em Feature de Longa Duração

```bash
# Cenário: Feature grande que levará 1-2 semanas

# 1. Criar feature branch
git checkout -b feature/complete-vim-config

# 2. Durante desenvolvimento, manter atualizado com main
# (fazer diariamente ou a cada 2-3 dias)
git fetch origin
git rebase origin/main
# Resolver conflitos se houver

# 3. Fazer commits pequenos e frequentes
git commit -m "feat(vim): adiciona suporte para Go"
git commit -m "feat(vim): configura LSP para Python"
git commit -m "feat(vim): adiciona temas adicionais"

# 4. Push frequentemente
git push origin feature/complete-vim-config

# 5. Abrir PR cedo (Draft PR)
gh pr create --draft \
  --base main \
  --title "WIP: Configuração completa do Vim"

# 6. Quando pronto, marcar como "Ready for review"
gh pr ready

# 7. Após aprovação e merge
git checkout main
git pull origin main
git branch -d feature/complete-vim-config
```

---

## 🔍 Inspeção e Debug

### Ver Estado dos Branches

```bash
# Branches locais
git branch

# Branches remotos
git branch -r

# Todos os branches
git branch -a

# Ver último commit de cada branch
git branch -v
```

### Ver Diferenças

```bash
# Diferença entre seu branch e main
git diff main..feature/minha-feature

# Commits que estão no seu branch mas não no main
git log main..feature/minha-feature --oneline
```

### Limpar Branches Obsoletos

```bash
# Listar branches já merged
git branch --merged main

# Deletar branches locais merged (exceto main)
git branch --merged main | grep -v "\* main" | xargs -n 1 git branch -d

# Limpar referências remotas obsoletas
git remote prune origin

# Ver branches remotos que foram deletados
git remote prune origin --dry-run
```

---

## 📚 Recursos Adicionais

- [Trunk Based Development](https://trunkbaseddevelopment.com/)
- [GitHub Flow](https://guides.github.com/introduction/flow/)
- [Semantic Versioning](https://semver.org/)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Git Best Practices](https://git-scm.com/book/en/v2/Distributed-Git-Contributing-to-a-Project)

---

## ❓ FAQ

### Posso commitar diretamente no main?

**Não.** Sempre use Pull Requests, mesmo para mudanças pequenas. Isso mantém histórico limpo e permite revisão.

### Quanto tempo um feature branch deve durar?

**Idealmente 1-7 dias.** Branches de longa duração acumulam conflitos. Se sua feature é grande, divida em PRs menores.

### Devo fazer rebase ou merge?

**Rebase** para manter histórico linear e limpo. Use `git rebase origin/main` ao invés de `git merge origin/main`.

### E se eu cometer um erro no main?

Use `git revert` para reverter o commit problemático. **Nunca** use `git push --force` no main.

```bash
# Reverter último commit
git revert HEAD

# Reverter commit específico
git revert abc123
```

### Posso ter múltiplos feature branches?

**Sim**, mas mantenha-os focados e de curta duração. Evite trabalhar em muitas features simultaneamente.

---

**Para dúvidas sobre contribuição, consulte**: [CONTRIBUTING.md](CONTRIBUTING.md)

**Última atualização**: 2025-12-18
