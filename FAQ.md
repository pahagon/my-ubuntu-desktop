# ❓ Perguntas Frequentes (FAQ)

Respostas para as perguntas mais comuns sobre o My Ubuntu Desktop.

## 📋 Índice

- [Geral](#geral)
- [Instalação](#instalação)
- [Configuração](#configuração)
- [Ferramentas](#ferramentas)
- [Customização](#customização)
- [Atualização](#atualização)

---

## 🌐 Geral

### O que é este projeto?

Este é um sistema completo de gerenciamento de configurações (dotfiles) e automação para Ubuntu Desktop. Ele automatiza a instalação e configuração de um ambiente de desenvolvimento completo usando Infrastructure as Code (IaC) com Ansible.

### Para quem é este projeto?

- Desenvolvedores que usam Ubuntu Desktop
- Pessoas que querem um ambiente de desenvolvimento reproduzível
- Usuários que frequentemente precisam configurar novas máquinas
- Qualquer um que queira aprender sobre automação de ambientes Linux

### Qual Ubuntu é suportado?

Oficialmente testado em **Ubuntu 24.04 LTS**. Outras versões podem funcionar mas não são garantidas.

### Quanto espaço em disco é necessário?

- **Repositório git**: ~23MB
- **Após instalação completa**: ~10-15GB (dependendo dos pacotes instalados)
- **Working directory** (com binários locais): ~1.8GB

### Posso usar em outras distribuições Linux?

O projeto é otimizado para Ubuntu, mas com modificações pode funcionar em:
- **Debian**: Alta compatibilidade (ajustar alguns PPAs)
- **Linux Mint**: Alta compatibilidade
- **Pop!_OS**: Alta compatibilidade
- **Fedora/Arch**: Requer adaptação significativa (diferentes package managers)

### Este projeto é gratuito?

Sim! Licenciado sob MIT License. Use, modifique e distribua livremente.

---

## 🚀 Instalação

### Quanto tempo leva a instalação completa?

- **Setup básico** (bootstrap): 1-2 minutos
- **Workstation playbook**: 10-15 minutos
- **Instalação completa** (todos os playbooks): 30-45 minutos

Depende da velocidade da internet e do hardware.

### Posso instalar apenas parte das configurações?

Sim! O projeto é modular. Você pode:
- Executar apenas playbooks específicos
- Criar symlinks seletivos
- Escolher quais ferramentas instalar

```bash
# Exemplo: apenas Docker
ansible-playbook ansible/docker.yml --ask-become-pass
```

### Preciso de conhecimento avançado?

**Conhecimento básico necessário**:
- Terminal Linux básico
- Comandos como `cd`, `ls`, `git`
- Conceito de sudo/permissões

**Não precisa saber**:
- Ansible (os playbooks já estão prontos)
- Programação
- Administração avançada de sistemas

### E se eu já tenho configurações personalizadas?

O `bootstrap` criará backups automáticos dos seus arquivos existentes com sufixo `.backup`. Você pode:
1. Fazer backup manual antes: `cp ~/.bashrc ~/.bashrc.old`
2. Mesclar suas configurações depois
3. Usar o projeto em um novo usuário/máquina

### Posso testar sem afetar meu sistema?

Sim! Recomendamos testar em:
- **VirtualBox VM**: Use o `Makefile` incluído para criar VM de teste
- **Docker container**: Para testes isolados
- **Outro usuário**: Crie um usuário de teste no Ubuntu

```bash
# Criar VM de teste
make vm-create
make vm-start
```

---

## 🔧 Configuração

### Como desfazer a instalação?

```bash
# 1. Remover symlinks
rm ~/.bashrc ~/.vimrc ~/.tmux.conf ~/.gitconfig

# 2. Restaurar backups (se existirem)
mv ~/.bashrc.backup ~/.bashrc

# 3. Desinstalar pacotes via apt (exemplo)
sudo apt remove package-name

# 4. Remover ASDF
rm -rf ~/.asdf
```

### Onde estão as configurações?

Todas as configurações ficam em `~/dot/`:
- **Bash**: `~/dot/bash/`
- **Vim**: `~/dot/vim/`
- **Emacs**: `~/dot/emacs/`
- **Tmux**: `~/dot/tmux/`
- **Git**: `~/dot/git/`

Os arquivos em `~/.bashrc`, `~/.vimrc`, etc. são **symlinks** apontando para `~/dot/`.

### Como atualizar apenas uma ferramenta?

```bash
# Exemplo: Atualizar apenas Python
cd ansible
ansible-playbook python.yml --ask-become-pass
```

### Posso usar meu próprio .vimrc/.bashrc?

Sim! Duas opções:

**Opção 1**: Editar os arquivos em `~/dot/`
```bash
vim ~/dot/bash/rc  # Suas mudanças afetam ~/.bashrc via symlink
```

**Opção 2**: Sobrescrever symlinks
```bash
rm ~/.bashrc  # Remove symlink
vim ~/.bashrc  # Cria arquivo próprio
```

### Como adicionar aliases personalizados?

```bash
# Editar arquivo de aliases
vim ~/dot/bash/alias

# Adicionar seu alias
alias meucomando='echo "Hello World"'

# Recarregar
source ~/.bashrc
```

---

## 🛠️ Ferramentas

### Por que ASDF ao invés de pyenv/nvm/rbenv?

ASDF é um **gerenciador unificado** de versões para múltiplas linguagens:
- **Uma ferramenta** ao invés de pyenv + nvm + rbenv + gvm
- **Sintaxe consistente** entre linguagens
- **Menor overhead** de memória
- **Mais simples** de gerenciar

### Posso usar Docker ao invés de ASDF?

Sim! Docker e ASDF não são mutuamente exclusivos:
- **Docker**: Para ambientes de produção e isolamento completo
- **ASDF**: Para desenvolvimento local com múltiplas versões

Muitos desenvolvedores usam ambos.

### Por que Emacs E Vim?

Configurações para ambos são incluídas porque:
- **Preferências pessoais** variam
- **Casos de uso diferentes**: Emacs para projetos grandes, Vim para edições rápidas
- **Aprender ambos** é valioso

Use o que preferir, ou ambos!

### Qual a diferença entre Emacs e Vim configurados?

**Emacs (27+)**:
- 50+ pacotes instalados
- Evil mode (emula Vim)
- LSP, Copilot, Projectile
- IDE completo
- Melhor para projetos grandes

**Vim**:
- Configuração mais leve
- Startup mais rápido
- Melhor para edições rápidas via SSH
- Menos recursos que Emacs

### Preciso do Powerline?

Não é obrigatório, mas recomendado:
- **Visual**: Status line bonita e informativa
- **Funcional**: Mostra git branch, status, etc.
- **Consistente**: Mesma aparência em Bash, Vim, Emacs, Tmux

Para remover:
```bash
pip uninstall powerline-status
# Remover linhas relacionadas dos dotfiles
```

---

## 🎨 Customização

### Como mudar o tema do Emacs?

```elisp
;; Editar ~/dot/emacs/init.el
;; Procurar por theme e alterar:
(load-theme 'dracula t)  ; Mudar para seu tema preferido

;; Temas disponíveis:
;; - dracula, solarized-dark, monokai, zenburn, etc.
```

### Como adicionar novos playbooks Ansible?

```bash
# 1. Criar novo playbook
vim ~/dot/ansible/minha-tool.yml

# 2. Seguir estrutura padrão (ver ansible/README.md)

# 3. Testar
ansible-playbook ansible/minha-tool.yml --check

# 4. Executar
ansible-playbook ansible/minha-tool.yml --ask-become-pass
```

### Posso mudar versões das linguagens?

Sim! ASDF permite múltiplas versões:

```bash
# Instalar nova versão
asdf install python 3.11.0

# Usar globalmente
asdf global python 3.11.0

# Ou por projeto
cd meu-projeto
asdf local python 3.11.0  # Cria .tool-versions
```

### Como personalizar o prompt do Bash?

```bash
# Editar ~/dot/bash/rc
vim ~/dot/bash/rc

# Procurar por PS1 e personalizar
export PS1="\u@\h:\w\$ "

# Recarregar
source ~/.bashrc
```

### Como adicionar mais aliases do Git?

```bash
# Editar ~/dot/git/gitconfig
vim ~/dot/git/gitconfig

# Na seção [alias], adicionar:
[alias]
    meucomando = !git status && git log -1

# Usar
git meucomando
```

---

## 🔄 Atualização

### Como atualizar o repositório?

```bash
cd ~/dot
git pull origin main
./bootstrap  # Atualizar symlinks se necessário
```

### Como atualizar ferramentas instaladas?

```bash
# Ubuntu packages
sudo apt update && sudo apt upgrade

# ASDF plugins
asdf plugin update --all

# Emacs packages
# No Emacs: M-x straight-pull-all

# Vim plugins
vim +PluginUpdate +qall
```

### Vou perder minhas customizações ao atualizar?

**Não perde** se você:
- Editou arquivos em `~/dot/` (recomendado)
- Fez commit das suas mudanças no git

**Pode perder** se:
- Editou arquivos fora de `~/dot/` que não são symlinks
- Sobrescreveu symlinks com arquivos próprios

**Melhor prática**: Sempre edite arquivos em `~/dot/` e faça commits.

### Como contribuir melhorias de volta?

```bash
# 1. Fork o repositório no GitHub

# 2. Clone seu fork
git clone git@github.com:seu-usuario/my-ubuntu-desktop.git

# 3. Crie branch para sua feature
git checkout -b feature/minha-melhoria

# 4. Faça suas mudanças e commit
git add .
git commit -m "feat: adiciona suporte para Rust"

# 5. Push para seu fork
git push origin feature/minha-melhoria

# 6. Abra Pull Request no GitHub
```

### Com que frequência devo atualizar?

**Recomendação**:
- **Sistema Ubuntu**: Mensalmente ou quando há atualizações de segurança
- **Dotfiles repo**: A cada 3-6 meses ou quando precisar de features novas
- **Linguagens (ASDF)**: Quando seu projeto precisar de versão específica
- **Emacs/Vim plugins**: A cada 2-3 meses

---

## 🐛 Problemas Comuns

### "Command not found" após instalação

**Causa**: Shell não recarregou configurações.

**Solução**:
```bash
source ~/.bashrc
# ou
exec bash
```

### Ansible pede senha múltiplas vezes

**Causa**: Flag `--ask-become-pass` não usada ou senha incorreta.

**Solução**:
```bash
ansible-playbook playbook.yml --ask-become-pass
```

### Git push pede senha toda vez

**Causa**: Usando HTTPS ao invés de SSH.

**Solução**:
```bash
git remote set-url origin git@github.com:usuario/repo.git
```

### Docker "permission denied"

**Causa**: Usuário não está no grupo docker.

**Solução**:
```bash
sudo usermod -aG docker $USER
newgrp docker
```

### Para mais problemas, consulte [TROUBLESHOOTING.md](TROUBLESHOOTING.md)

---

## 📚 Recursos

### Onde aprender mais?

- **Ansible**: https://docs.ansible.com/
- **ASDF**: https://asdf-vm.com/
- **Emacs**: https://www.gnu.org/software/emacs/manual/
- **Vim**: https://www.vim.org/docs.php
- **Tmux**: https://github.com/tmux/tmux/wiki

### Documentação adicional neste repo

- [README.md](README.md) - Visão geral e instalação
- [TROUBLESHOOTING.md](TROUBLESHOOTING.md) - Soluções detalhadas
- [ansible/README.md](ansible/README.md) - Documentação dos playbooks
- [semantic-commit-messages.md](semantic-commit-messages.md) - Estilo de commits

### Como obter ajuda?

1. **Consultar documentação** neste repo primeiro
2. **Buscar issues existentes**: https://github.com/pahagon/my-ubuntu-desktop/issues
3. **Abrir novo issue** com detalhes do problema
4. **Incluir logs e contexto** (versão Ubuntu, comando executado, erro completo)

---

## 💡 Dicas

### Dica 1: Use dotfiles em múltiplas máquinas

```bash
# Máquina 1 (desktop)
cd ~/dot
git add .
git commit -m "feat: adiciona novo alias"
git push

# Máquina 2 (laptop)
cd ~/dot
git pull
source ~/.bashrc  # Alias disponível imediatamente!
```

### Dica 2: Crie seu próprio branch para customizações

```bash
cd ~/dot
git checkout -b meu-setup
# Faça suas customizações
git commit -am "meu setup pessoal"

# Atualizar com mudanças do upstream
git fetch origin main
git rebase origin/main
```

### Dica 3: Use Ansible tags para instalação seletiva

```yaml
# Em um playbook, adicione tags
- name: Instalar pacote
  apt:
    name: pacote
  tags: [essencial]

- name: Instalar pacote opcional
  apt:
    name: opcional
  tags: [opcional]
```

```bash
# Executar apenas tarefas com tag específica
ansible-playbook playbook.yml --tags essencial
```

### Dica 4: Crie aliases para comandos frequentes

```bash
# Em ~/dot/bash/alias
alias dotupdate='cd ~/dot && git pull && source ~/.bashrc'
alias dotstatus='cd ~/dot && git status'
alias dotedit='cd ~/dot && $EDITOR'
```

### Dica 5: Documente suas customizações

Crie um arquivo `CUSTOM.md` no seu fork:
```markdown
# Minhas Customizações

- Mudei tema do Emacs para nord
- Adicionei alias para kubectl
- Instalei plugin X no Vim
```

---

**Não encontrou sua pergunta?**

Abra uma issue: https://github.com/pahagon/my-ubuntu-desktop/issues/new

---

**Última atualização**: 2025-12-18
