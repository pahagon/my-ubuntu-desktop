# 🎨 Guia de Customização

Este guia explica como personalizar o ambiente Ubuntu Desktop para suas necessidades específicas.

## 📋 Índice

- [Filosofia de Customização](#filosofia-de-customização)
- [Bash](#bash)
- [Git](#git)
- [Emacs](#emacs)
- [Vim](#vim)
- [Tmux](#tmux)
- [Ansible Playbooks](#ansible-playbooks)
- [Temas e Aparência](#temas-e-aparência)
- [Linguagens de Programação](#linguagens-de-programação)
- [Exemplos Práticos](#exemplos-práticos)

---

## 💡 Filosofia de Customização

### Princípios

1. **Edite sempre em `~/dot/`**: Mudanças são propagadas via symlinks
2. **Commite suas mudanças**: Mantenha histórico e sincronize entre máquinas
3. **Use branches**: Crie branch pessoal para customizações específicas
4. **Documente**: Adicione comentários explicando suas customizações
5. **Teste antes**: Use `--check` ou VMs para testar mudanças significativas

### Estrutura de Arquivos

```
~/dot/
├── bash/          # Configurações Bash
│   ├── rc         # Runtime (aliases, functions)
│   ├── profile    # Environment variables
│   └── alias      # Aliases separados
├── vim/           # Configurações Vim
│   └── vimrc      # Config principal
├── emacs/         # Configurações Emacs
│   └── init.el    # Config principal
├── git/           # Configurações Git
│   └── gitconfig  # User + aliases
└── tmux/          # Configurações Tmux
    └── tmux.conf  # Config principal
```

**Regra de ouro**: `~/.bashrc` → **symlink** → `~/dot/bash/rc`

---

## 🐚 Bash

### Adicionar Aliases

**Arquivo**: `~/dot/bash/alias`

```bash
# Editar
vim ~/dot/bash/alias

# Adicionar aliases
alias ll='ls -lah'
alias gs='git status'
alias gp='git push'
alias dc='docker compose'
alias k='kubectl'

# Aliases com argumentos (usar função)
gco() {
    git checkout "$@"
}

# Recarregar
source ~/.bashrc
```

### Adicionar Funções Personalizadas

**Arquivo**: `~/dot/bash/rc`

```bash
# Editar
vim ~/dot/bash/rc

# Adicionar ao final do arquivo
# Função para criar diretório e entrar nele
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Função para buscar em histórico
hg() {
    history | grep "$1"
}

# Função para extrair qualquer arquivo compactado
extract() {
    if [ -f "$1" ] ; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar x "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "'$1' não pode ser extraído" ;;
        esac
    else
        echo "'$1' não é um arquivo válido"
    fi
}
```

### Customizar Prompt (PS1)

**Arquivo**: `~/dot/bash/rc`

```bash
# Prompt simples
export PS1="\u@\h:\w\$ "

# Prompt colorido
export PS1="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "

# Prompt com git branch
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}
export PS1="\u@\h:\w \$(parse_git_branch)\$ "
```

### Variáveis de Ambiente

**Arquivo**: `~/dot/bash/profile`

```bash
# Editar
vim ~/dot/bash/profile

# Adicionar variáveis
export EDITOR=vim
export VISUAL=vim
export PAGER=less
export BROWSER=firefox

# Adicionar ao PATH
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# Java
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

# Go
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

# Recarregar
source ~/.bash_profile
```

### Bash Completion Customizado

**Arquivo**: `~/dot/bash/complete/meu-comando`

```bash
# Criar arquivo de completion
vim ~/dot/bash/complete/meu-comando

# Exemplo: completion para comando "deploy"
_deploy_completion() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts="dev staging production"

    if [[ ${cur} == * ]] ; then
        COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
        return 0
    fi
}
complete -F _deploy_completion deploy

# Sourced automaticamente pelo bash/rc
```

---

## 🔧 Git

### Adicionar Aliases

**Arquivo**: `~/dot/git/gitconfig`

```ini
[alias]
    # Status e info
    st = status
    s = status --short
    info = remote show origin

    # Log formatado
    lg = log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
    l = log --oneline -10
    la = log --oneline --all --graph

    # Branch
    br = branch
    bra = branch -a
    brd = branch -d

    # Checkout
    co = checkout
    cob = checkout -b

    # Commit
    c = commit
    ca = commit -a
    cm = commit -m
    cam = commit -am
    amend = commit --amend

    # Push/Pull
    p = push
    pl = pull
    pom = push origin main

    # Diff
    d = diff
    dc = diff --cached

    # Stash
    sl = stash list
    sa = stash apply
    ss = stash save

    # Undo
    undo = reset --soft HEAD^
    unstage = reset HEAD --

    # Aliases úteis
    last = log -1 HEAD
    visual = log --graph --all --oneline
    contributors = shortlog -sn
```

### Configurar Usuário

```bash
# Editar gitconfig
vim ~/dot/git/gitconfig

[user]
    name = Seu Nome
    email = seu-email@example.com

[github]
    user = seu-usuario-github
```

### Gitignore Global

**Arquivo**: `~/dot/git/gitignore`

```ini
# Editar
vim ~/dot/git/gitignore

# Sistema
.DS_Store
Thumbs.db
*.swp
*.swo
*~

# IDEs
.vscode/
.idea/
*.iml

# Linguagens
__pycache__/
*.pyc
node_modules/
*.class
target/

# Secrets
.env
.env.local
*.pem
*.key
credentials.json

# Build
dist/
build/
*.log
```

---

## 🎨 Emacs

### Adicionar Pacotes

**Arquivo**: `~/dot/emacs/init.el`

```elisp
;; Adicionar novo pacote com straight.el
(straight-use-package 'nome-do-pacote)

;; Ou com use-package + straight
(use-package nome-do-pacote
  :straight t
  :config
  (setq opcao t))

;; Exemplo: Adicionar Rust support
(use-package rust-mode
  :straight t
  :mode "\\.rs\\'"
  :config
  (setq rust-format-on-save t))

(use-package cargo
  :straight t
  :hook (rust-mode . cargo-minor-mode))
```

### Customizar Keybindings

```elisp
;; Adicionar ao init.el

;; Keybinding global
(global-set-key (kbd "C-c s") 'save-buffer)
(global-set-key (kbd "C-c k") 'kill-buffer)

;; Keybinding para modo específico
(define-key python-mode-map (kbd "C-c C-t") 'python-pytest)

;; Com evil mode
(evil-define-key 'normal global-map (kbd ",w") 'save-buffer)
```

### Mudar Tema

```elisp
;; Editar init.el

;; Instalar tema
(straight-use-package 'doom-themes)

;; Aplicar tema
(load-theme 'doom-one t)

;; Outros temas populares:
;; - doom-nord
;; - doom-tomorrow-night
;; - dracula
;; - solarized-dark
;; - monokai
```

### Configurar LSP

```elisp
;; Adicionar ao init.el

(use-package lsp-mode
  :straight t
  :init
  (setq lsp-keymap-prefix "C-c l")
  :hook ((python-mode . lsp)
         (javascript-mode . lsp)
         (typescript-mode . lsp))
  :commands lsp)

;; UI melhorada
(use-package lsp-ui
  :straight t
  :commands lsp-ui-mode
  :config
  (setq lsp-ui-doc-enable t
        lsp-ui-doc-position 'at-point))

;; Integração com company (autocomplete)
(use-package company-lsp
  :straight t
  :commands company-lsp)
```

### Performance do Emacs

```elisp
;; Adicionar no início do init.el

;; Aumentar garbage collection threshold
(setq gc-cons-threshold 100000000)

;; Aumentar data read
(setq read-process-output-max (* 1024 1024))

;; Reduzir startup time
(setq package-enable-at-startup nil)

;; Lazy load de pacotes
(use-package pacote-pesado
  :defer t        ; Carrega sob demanda
  :commands comando-do-pacote)
```

---

## 📝 Vim

### Adicionar Plugins (Vundle)

**Arquivo**: `~/dot/vim/vimrc`

```vim
" Adicionar entre call vundle#begin() e call vundle#end()

Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-fugitive'          " Git integration
Plugin 'scrooloose/nerdtree'         " File explorer
Plugin 'vim-airline/vim-airline'     " Status line
Plugin 'junegunn/fzf.vim'            " Fuzzy finder
Plugin 'dense-analysis/ale'          " Linting
Plugin 'sheerun/vim-polyglot'        " Language support

" Instalar
:PluginInstall
```

### Customizar Keybindings

```vim
" Adicionar ao vimrc

" Leader key
let mapleader = ","

" Save com leader w
nnoremap <leader>w :w<CR>

" Quit com leader q
nnoremap <leader>q :q<CR>

" NERDTree toggle
nnoremap <leader>n :NERDTreeToggle<CR>

" Buffer navigation
nnoremap <C-n> :bnext<CR>
nnoremap <C-p> :bprev<CR>

" Split navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
```

### Mudar Tema

```vim
" Instalar plugin de tema
Plugin 'morhetz/gruvbox'

" Aplicar tema
colorscheme gruvbox
set background=dark

" Outros temas populares:
" - dracula, solarized, molokai, onedark
```

### Configurações Úteis

```vim
" Adicionar ao vimrc

" Números de linha
set number
set relativenumber

" Indentação
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent

" Busca
set hlsearch      " Highlight search
set incsearch     " Incremental search
set ignorecase    " Case insensitive
set smartcase     " Smart case

" Interface
set cursorline    " Highlight current line
set showmatch     " Show matching brackets
set wildmenu      " Visual autocomplete

" Performance
set lazyredraw    " Redraw only when needed
set ttyfast       " Faster scrolling
```

---

## 🖥️ Tmux

### Customizar Keybindings

**Arquivo**: `~/dot/tmux/tmux.conf`

```bash
# Mudar prefix de C-b para C-a
unbind C-b
set -g prefix C-a
bind C-a send-prefix

# Split mais intuitivos
bind | split-window -h
bind - split-window -v
unbind '"'
unbind %

# Navegação vim-like entre panes
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

# Resize de panes
bind -r H resize-pane -L 5
bind -r J resize-pane -D 5
bind -r K resize-pane -U 5
bind -r L resize-pane -R 5

# Reload config
bind r source-file ~/.tmux.conf \; display "Config reloaded!"

# Recarregar
tmux source-file ~/.tmux.conf
```

### Customizar Aparência

```bash
# Cores
set -g default-terminal "screen-256color"

# Status bar
set -g status-style bg=black,fg=white
set -g status-left '#[fg=green]#H '
set -g status-right '#[fg=yellow]%H:%M %d-%b-%y'

# Pane borders
set -g pane-border-style fg=blue
set -g pane-active-border-style fg=red

# Window status
setw -g window-status-current-style fg=black,bg=green
```

### Plugins do Tmux (TPM)

```bash
# Instalar TPM
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Adicionar ao tmux.conf
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'tmux-plugins/tmux-resurrect'  # Salvar sessões
set -g @plugin 'tmux-plugins/tmux-continuum'   # Auto-save sessões

# Initialize TPM (manter no final do arquivo)
run '~/.tmux/plugins/tpm/tpm'

# Instalar plugins: prefix + I
# Atualizar plugins: prefix + U
```

---

## 🤖 Ansible Playbooks

### Criar Novo Playbook

**Arquivo**: `~/dot/ansible/minha-ferramenta.yml`

```yaml
---
- name: Instalar Minha Ferramenta
  hosts: localhost
  connection: local
  become: true
  vars_files:
    - common_vars.yml

  vars:
    tool_version: "1.2.3"

  tasks:
    - name: Adicionar repositório
      apt_repository:
        repo: ppa:meu-repo/ppa
        state: present
        update_cache: yes

    - name: Instalar pacote
      apt:
        name:
          - minha-ferramenta
          - dependencia1
          - dependencia2
        state: present

    - name: Criar diretório de configuração
      file:
        path: "{{ my_home }}/.minha-ferramenta"
        state: directory
        owner: "{{ my_user }}"
        group: "{{ my_user }}"

    - name: Copiar arquivo de configuração
      template:
        src: templates/config.yml.j2
        dest: "{{ my_home }}/.minha-ferramenta/config.yml"
        owner: "{{ my_user }}"
        group: "{{ my_user }}"

    - name: Verificar instalação
      command: minha-ferramenta --version
      register: version_output
      changed_when: false

    - name: Exibir versão instalada
      debug:
        msg: "Instalado: {{ version_output.stdout }}"

# Executar:
# ansible-playbook ansible/minha-ferramenta.yml --ask-become-pass
```

### Modificar Playbook Existente

```yaml
# Exemplo: Adicionar Python 3.11 ao python.yml

# Editar ansible/python.yml
vim ansible/python.yml

# Adicionar tarefa:
- name: Install Python 3.11
  shell: |
    source {{ my_home }}/.asdf/asdf.sh
    asdf install python 3.11.0
    asdf global python 3.11.0
  args:
    executable: /bin/bash
```

### Criar Profile de Instalação

**Arquivo**: `~/dot/ansible/dev-complete.yml`

```yaml
---
# Profile: Desenvolvimento Completo

- name: Setup Workstation Base
  import_playbook: workstation.yml

- name: Install Docker
  import_playbook: docker.yml

- name: Install Programming Languages
  import_playbook: python.yml

- import_playbook: node.yml
- import_playbook: golang.yml
- import_playbook: ruby.yml

- name: Install Editors
  import_playbook: emacs27.yml

- name: Install Tools
  import_playbook: github-cli.yml

# Executar:
# ansible-playbook ansible/dev-complete.yml --ask-become-pass
```

---

## 🎨 Temas e Aparência

### GNOME Theme

```bash
# Instalar tema
sudo apt install gnome-tweaks
ansible-playbook ansible/theme-icons.yml --ask-become-pass

# Aplicar via GUI
gnome-tweaks

# Ou via CLI
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
gsettings set org.gnome.desktop.interface icon-theme 'Papirus'
gsettings set org.gnome.desktop.interface cursor-theme 'DMZ-White'
```

### Terminal Colors

**Arquivo**: `~/dot/linux/Xresources`

```bash
# Editar
vim ~/dot/linux/Xresources

! Dracula Theme
*.foreground: #F8F8F2
*.background: #282A36
*.color0:     #000000
*.color1:     #FF5555
*.color2:     #50FA7B
*.color3:     #F1FA8C
*.color4:     #BD93F9
*.color5:     #FF79C6
*.color6:     #8BE9FD
*.color7:     #BFBFBF

! Aplicar
xrdb -merge ~/.Xresources
```

### Fontes

```bash
# Instalar Nerd Fonts
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/FiraCode.zip
unzip FiraCode.zip
rm FiraCode.zip
fc-cache -fv

# Configurar terminal para usar FiraCode
```

---

## 🌐 Linguagens de Programação

### Adicionar Nova Linguagem via ASDF

```bash
# 1. Adicionar plugin
asdf plugin add rust

# 2. Listar versões disponíveis
asdf list all rust

# 3. Instalar versão
asdf install rust 1.70.0

# 4. Definir versão global
asdf global rust 1.70.0

# 5. Criar playbook Ansible
vim ansible/rust.yml
```

**Exemplo de playbook Rust**:

```yaml
---
- name: Install Rust via ASDF
  hosts: localhost
  connection: local
  vars_files:
    - common_vars.yml

  tasks:
    - include_tasks: common_tasks.yml

    - name: Add Rust plugin
      shell: |
        source {{ my_home }}/.asdf/asdf.sh
        asdf plugin add rust || true
      args:
        executable: /bin/bash

    - name: Install Rust
      shell: |
        source {{ my_home }}/.asdf/asdf.sh
        asdf install rust 1.70.0
        asdf global rust 1.70.0
      args:
        executable: /bin/bash
```

### Configurar por Projeto

```bash
# Criar .tool-versions no projeto
cd meu-projeto
asdf local python 3.11.0
asdf local nodejs 18.0.0

# Arquivo .tool-versions criado:
cat .tool-versions
python 3.11.0
nodejs 18.0.0

# ASDF usará automaticamente essas versões neste diretório
```

---

## 💡 Exemplos Práticos

### Exemplo 1: Setup para Web Development

```bash
# 1. Instalar ferramentas base
ansible-playbook ansible/workstation.yml --ask-become-pass

# 2. Instalar Node.js e Docker
ansible-playbook ansible/node.yml --ask-become-pass
ansible-playbook ansible/docker.yml --ask-become-pass

# 3. Adicionar aliases úteis
echo "alias nr='npm run'" >> ~/dot/bash/alias
echo "alias nrd='npm run dev'" >> ~/dot/bash/alias
echo "alias dc='docker compose'" >> ~/dot/bash/alias

# 4. Instalar extensões Emacs para web
# Adicionar ao init.el:
# - web-mode
# - emmet-mode
# - prettier-js

# 5. Recarregar
source ~/.bashrc
```

### Exemplo 2: Setup para Data Science

```bash
# 1. Instalar Python com dependências
ansible-playbook ansible/python.yml --ask-become-pass

# 2. Instalar pacotes Python
pip install numpy pandas matplotlib jupyter scikit-learn

# 3. Configurar Jupyter
jupyter notebook --generate-config

# 4. Adicionar aliases
echo "alias jn='jupyter notebook'" >> ~/dot/bash/alias
echo "alias jl='jupyter lab'" >> ~/dot/bash/alias

# 5. Instalar suporte Python no Emacs
# Adicionar ao init.el:
# - python-mode
# - elpy (Emacs Lisp Python Environment)
```

### Exemplo 3: Setup Multi-Machine Sync

```bash
# Máquina 1 (principal)
cd ~/dot
git checkout -b meu-setup
# ... fazer customizações ...
git add .
git commit -m "meu setup personalizado"
git push origin meu-setup

# Máquina 2 (secundária)
git clone git@github.com:seu-usuario/my-ubuntu-desktop.git ~/dot
cd ~/dot
git checkout meu-setup
./bootstrap
cd ansible
ansible-playbook workstation.yml --ask-become-pass
```

---

## 📚 Recursos

- [Bash Guide](https://www.gnu.org/software/bash/manual/)
- [Ansible Best Practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)
- [Emacs Wiki](https://www.emacswiki.org/)
- [Vim Tips](https://vim.fandom.com/wiki/Vim_Tips_Wiki)
- [Tmux Guide](https://github.com/tmux/tmux/wiki)

---

**Dúvidas?** Consulte [FAQ.md](FAQ.md) ou abra uma issue.

**Última atualização**: 2025-12-18
