# 🛠️ Guia de Troubleshooting

Este guia contém soluções para problemas comuns encontrados durante instalação e uso do ambiente Ubuntu Desktop configurado por este repositório.

## 📋 Índice

- [Instalação](#instalação)
- [Ansible](#ansible)
- [ASDF Version Manager](#asdf-version-manager)
- [Emacs](#emacs)
- [Vim](#vim)
- [Tmux](#tmux)
- [Git](#git)
- [Docker](#docker)
- [Shell e Terminal](#shell-e-terminal)
- [Ubuntu Autoinstall](#ubuntu-autoinstall)
- [Performance](#performance)

---

## 🚀 Instalação

### Problema: Bootstrap não cria symlinks

**Sintomas**:
```bash
./bootstrap
# Não acontece nada ou erro "file exists"
```

**Causas possíveis**:
1. Arquivos já existem no destino
2. Permissões incorretas
3. Script não é executável

**Soluções**:

```bash
# 1. Forçar recriação de symlinks
./bootstrap --force

# 2. Remover arquivos existentes manualmente
rm ~/.bashrc ~/.vimrc ~/.tmux.conf ~/.gitconfig
./bootstrap

# 3. Tornar script executável
chmod +x bootstrap
./bootstrap

# 4. Verificar o que seria criado (dry-run)
./bootstrap --dry-run
```

### Problema: Erro de permissão ao executar scripts

**Sintomas**:
```bash
./bootstrap
bash: ./bootstrap: Permission denied
```

**Solução**:
```bash
# Adicionar permissão de execução
chmod +x bootstrap
chmod +x setup-binaries.sh

# Ou executar com bash
bash bootstrap
```

### Problema: Git clone muito lento

**Sintomas**: Clone do repositório demora muito tempo.

**Soluções**:

```bash
# 1. Clone shallow (sem histórico completo)
git clone --depth 1 https://github.com/pahagon/my-ubuntu-desktop.git

# 2. Clone apenas branch específico
git clone -b main --single-branch https://github.com/pahagon/my-ubuntu-desktop.git

# 3. Verificar conexão de internet
ping github.com
```

---

## 🤖 Ansible

### Problema: "ansible-playbook: command not found"

**Sintomas**: Comando ansible-playbook não encontrado.

**Soluções**:

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install ansible

# Verificar instalação
ansible --version

# Instalar via pip (alternativa)
pip install ansible
```

### Problema: "Failed to connect to host"

**Sintomas**:
```
fatal: [localhost]: UNREACHABLE! => {"changed": false, "msg": "Failed to connect to the host via ssh"}
```

**Causas**: Ansible tentando conectar via SSH ao localhost.

**Soluções**:

```yaml
# Certifique-se que o playbook tem:
- hosts: localhost
  connection: local  # Adicione esta linha
```

Ou execute com:
```bash
ansible-playbook playbook.yml --connection=local
```

### Problema: "Permission denied" durante execução

**Sintomas**:
```
fatal: [localhost]: FAILED! => {"msg": "Missing become password"}
```

**Soluções**:

```bash
# Use a flag --ask-become-pass
ansible-playbook workstation.yml --ask-become-pass

# Ou defina senha via variável (NÃO RECOMENDADO para produção)
ansible-playbook workstation.yml -e ansible_become_pass=senha
```

### Problema: Playbook falha em "apt update"

**Sintomas**: Erro ao atualizar cache do apt.

**Soluções**:

```bash
# 1. Atualizar manualmente primeiro
sudo apt update
sudo apt upgrade

# 2. Limpar cache do apt
sudo apt clean
sudo rm -rf /var/lib/apt/lists/*
sudo apt update

# 3. Verificar sources.list
sudo nano /etc/apt/sources.list
```

### Problema: Módulo Ansible não encontrado

**Sintomas**:
```
ERROR! couldn't resolve module/action 'community.general.snap'
```

**Soluções**:

```bash
# Instalar coleção necessária
ansible-galaxy collection install community.general

# Listar coleções instaladas
ansible-galaxy collection list
```

### Problema: Playbook muito lento

**Sintomas**: Execução demora muito mais que o esperado.

**Soluções**:

```bash
# 1. Desabilitar gathering de facts se não necessário
# No playbook:
gather_facts: no

# 2. Usar pipelining (mais rápido)
# Em ansible.cfg:
[defaults]
pipelining = True

# 3. Aumentar paralelismo
ansible-playbook playbook.yml --forks=10
```

---

## 📦 ASDF Version Manager

### Problema: "asdf: command not found"

**Sintomas**: Comando asdf não funciona após instalação.

**Causas**: Shell não recarregou configuração.

**Soluções**:

```bash
# 1. Recarregar bashrc
source ~/.bashrc

# 2. Abrir novo terminal
exec bash

# 3. Verificar se está no PATH
echo $PATH | grep asdf

# 4. Adicionar manualmente ao bashrc (se necessário)
echo '. $HOME/.asdf/asdf.sh' >> ~/.bashrc
echo '. $HOME/.asdf/completions/asdf.bash' >> ~/.bashrc
source ~/.bashrc
```

### Problema: Plugin não instala

**Sintomas**:
```bash
asdf plugin add python
# Falha com erro de rede ou "plugin already exists"
```

**Soluções**:

```bash
# 1. Verificar se plugin já existe
asdf plugin list

# 2. Atualizar lista de plugins
asdf plugin update --all

# 3. Remover e reinstalar plugin
asdf plugin remove python
asdf plugin add python

# 4. Instalar plugin com URL específica
asdf plugin add python https://github.com/asdf-community/asdf-python.git
```

### Problema: Versão instalada mas não disponível

**Sintomas**:
```bash
asdf install python 3.12.0
# Sucesso, mas python --version mostra versão antiga
```

**Soluções**:

```bash
# 1. Definir versão global
asdf global python 3.12.0

# 2. Verificar versões instaladas
asdf list python

# 3. Verificar qual versão está ativa
asdf current python

# 4. Reshim (recriar shims)
asdf reshim python
```

### Problema: Dependências de build faltando

**Sintomas**:
```bash
asdf install python 3.12.0
# Falha com erro "No module named '_ssl'"
```

**Soluções**:

```bash
# Ubuntu - Instalar dependências de build
sudo apt install -y \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    wget \
    curl \
    llvm \
    libncurses5-dev \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libffi-dev \
    liblzma-dev \
    python3-openssl \
    git

# Reinstalar Python
asdf uninstall python 3.12.0
asdf install python 3.12.0
```

---

## 🎨 Emacs

### Problema: Emacs não inicia

**Sintomas**:
```bash
emacs
# Tela preta ou erro
```

**Soluções**:

```bash
# 1. Iniciar em modo debug
emacs --debug-init

# 2. Iniciar sem configuração
emacs -Q

# 3. Verificar logs de erro
tail -f ~/.emacs.d/warnings.log

# 4. Limpar cache e pacotes
rm -rf ~/.emacs.d/straight/build
rm -rf ~/.emacs.d/elpa
emacs  # Reinstalará pacotes
```

### Problema: Pacotes não instalam (straight.el)

**Sintomas**: Erro ao instalar pacotes via straight.el.

**Soluções**:

```bash
# 1. Limpar cache do straight.el
rm -rf ~/.emacs.d/straight/build-cache.el
rm -rf ~/.emacs.d/straight/build

# 2. Atualizar straight.el
# No Emacs: M-x straight-pull-all

# 3. Rebuild pacotes
# No Emacs: M-x straight-rebuild-all

# 4. Verificar conexão com GitHub
git ls-remote https://github.com/radian-software/straight.el.git
```

### Problema: Evil mode não funciona

**Sintomas**: Keybindings do Vim não funcionam no Emacs.

**Soluções**:

```elisp
;; Verificar se evil está carregado
;; No Emacs: M-x describe-variable RET evil-mode

;; Ativar manualmente
M-x evil-mode

;; Adicionar ao init.el se não estiver:
(require 'evil)
(evil-mode 1)
```

### Problema: Copilot não conecta

**Sintomas**: GitHub Copilot não sugere código.

**Soluções**:

```bash
# 1. Verificar se Node.js está instalado
node --version

# 2. No Emacs, fazer login
M-x copilot-login

# 3. Verificar status
M-x copilot-diagnose

# 4. Reinstalar copilot.el
rm -rf ~/.emacs.d/straight/repos/copilot.el
# Reiniciar Emacs
```

### Problema: LSP muito lento

**Sintomas**: LSP (Language Server Protocol) deixa Emacs lento.

**Soluções**:

```elisp
;; Adicionar ao init.el:
(setq lsp-log-io nil)  ; Desabilitar logging
(setq lsp-enable-file-watchers nil)  ; Desabilitar file watching
(setq lsp-idle-delay 0.5)  ; Aumentar delay
(setq gc-cons-threshold 100000000)  ; Aumentar GC threshold
(setq read-process-output-max (* 1024 1024))  ; Aumentar buffer de leitura
```

---

## 📝 Vim

### Problema: Plugins não carregam

**Sintomas**: Plugins Vundle não funcionam.

**Soluções**:

```bash
# 1. Instalar Vundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# 2. Instalar plugins
vim +PluginInstall +qall

# 3. Limpar e reinstalar
rm -rf ~/.vim/bundle/*
vim +PluginInstall +qall
```

### Problema: Cores não aparecem

**Sintomas**: Tema/cores não funcionam no terminal.

**Soluções**:

```bash
# 1. Verificar suporte a cores
echo $TERM

# 2. Definir TERM correto
export TERM=xterm-256color

# 3. No vimrc, forçar 256 cores
set t_Co=256
set termguicolors
```

---

## 🖥️ Tmux

### Problema: Powerline não aparece

**Sintomas**: Status line do Tmux não mostra Powerline.

**Soluções**:

```bash
# 1. Verificar se powerline está instalado
pip show powerline-status

# 2. Instalar se necessário
pip install powerline-status

# 3. Verificar configuração no tmux.conf
cat ~/.tmux.conf | grep powerline

# 4. Reiniciar Tmux
tmux kill-server
tmux
```

### Problema: Mouse não funciona

**Sintomas**: Cliques do mouse não funcionam no Tmux.

**Soluções**:

```bash
# Adicionar ao ~/.tmux.conf
set -g mouse on

# Recarregar configuração
tmux source-file ~/.tmux.conf
```

### Problema: Copy/paste não funciona

**Sintomas**: Não consegue copiar do Tmux para clipboard do sistema.

**Soluções**:

```bash
# 1. Instalar xsel/xclip
sudo apt install xsel xclip

# 2. Configurar no tmux.conf
bind -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "xclip -in -selection clipboard"

# 3. Recarregar tmux
tmux source-file ~/.tmux.conf
```

---

## 🔧 Git

### Problema: Git push requer senha toda vez

**Sintomas**: Git pede senha SSH/HTTPS a cada push.

**Soluções**:

```bash
# 1. Usar SSH ao invés de HTTPS
git remote set-url origin git@github.com:usuario/repo.git

# 2. Configurar SSH agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa

# 3. Cache de credenciais (HTTPS)
git config --global credential.helper cache
git config --global credential.helper 'cache --timeout=3600'
```

### Problema: "Permission denied (publickey)"

**Sintomas**: Erro ao fazer git clone/push via SSH.

**Soluções**:

```bash
# 1. Gerar chave SSH
ssh-keygen -t ed25519 -C "seu-email@example.com"

# 2. Adicionar ao SSH agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# 3. Adicionar chave pública ao GitHub
cat ~/.ssh/id_ed25519.pub
# Copiar e adicionar em github.com/settings/keys

# 4. Testar conexão
ssh -T git@github.com
```

### Problema: Aliases não funcionam

**Sintomas**: Aliases do Git não são reconhecidos.

**Soluções**:

```bash
# 1. Verificar se gitconfig está linkado
ls -la ~/.gitconfig

# 2. Criar symlink manualmente se necessário
ln -sf ~/dot/git/gitconfig ~/.gitconfig

# 3. Testar alias
git config --get-regexp alias
```

---

## 🐳 Docker

### Problema: "permission denied" ao usar Docker

**Sintomas**:
```bash
docker ps
# Got permission denied while trying to connect to the Docker daemon socket
```

**Soluções**:

```bash
# 1. Adicionar usuário ao grupo docker
sudo usermod -aG docker $USER

# 2. Fazer logout/login ou
newgrp docker

# 3. Verificar se está no grupo
groups | grep docker

# 4. Reiniciar serviço Docker
sudo systemctl restart docker
```

### Problema: Docker service não inicia

**Sintomas**:
```bash
sudo systemctl start docker
# Job for docker.service failed
```

**Soluções**:

```bash
# 1. Verificar logs
sudo journalctl -u docker.service -n 50

# 2. Verificar status
sudo systemctl status docker

# 3. Remover conflitos
sudo apt remove docker docker-engine docker.io containerd runc
sudo apt install docker-ce docker-ce-cli containerd.io

# 4. Reiniciar daemon
sudo systemctl daemon-reload
sudo systemctl start docker
```

---

## 🐚 Shell e Terminal

### Problema: Bash não carrega configurações

**Sintomas**: Aliases, funções não funcionam.

**Soluções**:

```bash
# 1. Verificar se bashrc está linkado
ls -la ~/.bashrc

# 2. Recarregar configuração
source ~/.bashrc

# 3. Verificar erros de sintaxe
bash -n ~/.bashrc

# 4. Debug: ver o que está carregando
bash -x ~/.bashrc
```

### Problema: Powerline não aparece no Bash

**Sintomas**: Prompt não mostra Powerline.

**Soluções**:

```bash
# 1. Instalar powerline
pip install powerline-status

# 2. Instalar fontes
sudo apt install fonts-powerline

# 3. Verificar se está no bashrc
cat ~/.bashrc | grep powerline

# 4. Adicionar manualmente se necessário
echo 'if [ -f /usr/share/powerline/bindings/bash/powerline.sh ]; then
    source /usr/share/powerline/bindings/bash/powerline.sh
fi' >> ~/.bashrc
```

### Problema: Cores quebradas no terminal

**Sintomas**: Caracteres estranhos ou cores erradas.

**Soluções**:

```bash
# 1. Definir TERM correto
export TERM=xterm-256color

# 2. Adicionar ao bashrc
echo 'export TERM=xterm-256color' >> ~/.bashrc

# 3. Reinstalar locale
sudo locale-gen en_US.UTF-8
export LANG=en_US.UTF-8
```

---

## 🤖 Ubuntu Autoinstall

### Problema: VM não inicia autoinstall

**Sintomas**: VM inicia, mas não executa instalação automática.

**Soluções**:

```bash
# 1. Verificar se ISOs estão anexados
VBoxManage showvminfo ubuntu-autoinstall | grep "IDE"

# 2. Recriar ISO de autoinstall
make create_autoinstall_iso

# 3. Verificar conteúdo do autoinstall.yml
cat autoinstall.yml

# 4. Verificar logs durante boot
# Pressione ESC durante boot para ver console
```

### Problema: Erro "cloud-init" durante instalação

**Sintomas**: Mensagem de erro relacionada a cloud-init.

**Soluções**:

```bash
# 1. Validar sintaxe do autoinstall.yml
python3 -c "import yaml; yaml.safe_load(open('autoinstall.yml'))"

# 2. Verificar indentação (deve ser 2 espaços)
cat -A autoinstall.yml

# 3. Testar em VM diferente
make vm-clean
make vm-create
```

---

## ⚡ Performance

### Problema: Sistema lento após instalação

**Sintomas**: Ubuntu está lento, alto uso de CPU/RAM.

**Soluções**:

```bash
# 1. Verificar processos
htop

# 2. Desabilitar serviços desnecessários
sudo systemctl disable snapd.service
sudo systemctl mask snapd.service

# 3. Limpar cache
sudo apt clean
sudo apt autoclean
sudo apt autoremove

# 4. Verificar disco
df -h
sudo du -sh /* | sort -h
```

### Problema: Emacs muito lento

**Sintomas**: Emacs demora para abrir ou responder.

**Soluções**:

```elisp
;; Adicionar ao init.el:

;; Aumentar garbage collection threshold
(setq gc-cons-threshold 100000000)

;; Desabilitar features pesadas
(setq lsp-enable-file-watchers nil)
(setq company-idle-delay 0.3)

;; Lazy load de pacotes
(use-package meu-pacote
  :defer t)  ; Carrega apenas quando necessário
```

---

## 📞 Suporte Adicional

Se o problema persistir:

1. **Abrir Issue**: https://github.com/pahagon/my-ubuntu-desktop/issues
2. **Verificar Issues Existentes**: Talvez alguém já teve o mesmo problema
3. **Logs**: Sempre inclua logs relevantes ao reportar problemas
4. **Ambiente**: Especifique versão do Ubuntu, hardware, etc.

---

**Última atualização**: 2025-12-18
