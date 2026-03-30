# My Ubuntu Desktop

Sistema completo de gerenciamento de configurações (dotfiles) e automação para ambiente de desenvolvimento Ubuntu Desktop. Este repositório fornece uma configuração Infrastructure-as-Code (IaC) para setup rápido e reproduzível de ambientes Ubuntu com ferramentas de desenvolvimento, editores configurados e ambiente shell customizado.

![Ubuntu](https://img.shields.io/badge/Ubuntu-24.04_LTS-E95420?style=flat-square&logo=ubuntu&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-blue.svg?style=flat-square)

## 🎯 Visão Geral

Este projeto automatiza a configuração completa de um ambiente Ubuntu Desktop focado em desenvolvimento, incluindo:

- **18+ playbooks Ansible** para instalação automatizada de ferramentas
- **Configurações completas** para Emacs (50+ pacotes), Vim, Tmux, Bash
- **Gerenciamento de versões** com ASDF para Python, Node.js, Go, Ruby
- **Ubuntu Autoinstall** com cloud-init para instalação desatendida
- **CI/CD** com GitHub Actions para validação automatizada
- **Repositório limpo**: apenas ~23MB (binários não são versionados)

## ✨ Principais Recursos

### Automação Completa
- **Ansible Playbooks**: Instalação automatizada de Docker, Python, Node.js, Ruby, Go, Java, Emacs, Chrome, GitHub CLI e mais
- **Ubuntu Autoinstall**: Instalação desatendida via cloud-init para deploy em VMs ou bare-metal
- **VirtualBox/QEMU**: Automação via Makefile para testes de instalação
- **GitHub Actions**: Validação contínua da configuração de autoinstall

### Editores e IDEs
- **Emacs 27+**: Configuração extensiva com 50+ pacotes
  - Evil mode (vim keybindings)
  - Helm, Projectile, Magit
  - CIDER (Clojure), Alchemist (Elixir)
  - GitHub Copilot integration
  - LSP support
- **Vim**: Configuração com plugins (Vundle, Supertab, language support)
- **Cursor IDE**: Suporte para múltiplas versões via AppImage

### Ambiente Shell
- **Bash**: Configuração modular com aliases, functions e completions
- **Tmux**: Keybindings vim-like, mouse support, powerline integration
- **Powerline**: Status line visual consistente em Bash, Tmux, Emacs e Vim
- **Git**: 30+ aliases úteis e configuração otimizada

### Linguagens e Ferramentas
- **ASDF Version Manager**: Gerenciamento unificado de versões
  - Python 3.12.2
  - Node.js 20.12.0 (com Yarn)
  - Go 1.17.1
  - Ruby 3.0.1
- **Docker & Docker Compose**
- **Arduino CLI** para desenvolvimento Arduino
- **AWS CLI** com configuração de ambientes
- **Terraform** support

## 📁 Estrutura do Repositório

```
.
├── ansible/                  # Playbooks Ansible
│   ├── common_tasks.yml      # Tarefas reutilizáveis
│   ├── common_vars.yml       # Variáveis compartilhadas
│   ├── workstation.yml       # Playbook principal (symlinks + locale)
│   ├── chrome.yml            # Instalação do Google Chrome
│   ├── docker.yml            # Instalação do Docker
│   ├── emacs27.yml           # Instalação do Emacs 27
│   ├── github-cli.yml        # Instalação do GitHub CLI
│   ├── golang.yml            # Setup Go via ASDF
│   ├── java.yml              # Setup Java via ASDF
│   ├── node.yml              # Setup Node.js via ASDF
│   ├── powerline-fonts.yml   # Instalação das fontes Powerline
│   ├── python.yml            # Setup Python via ASDF
│   ├── qemu.yml              # Instalação do QEMU
│   ├── ruby.yml              # Setup Ruby via ASDF
│   ├── theme-icons.yml       # Instalação de temas e ícones
│   ├── tmux.yml              # Instalação do tmux
│   └── virtualbox.yml        # Instalação do VirtualBox
├── bash/                 # Configuração Bash
│   ├── rc                # Runtime configuration
│   ├── profile           # Environment variables
│   ├── alias             # Command aliases
│   ├── asdf              # ASDF initialization
│   └── aws               # AWS CLI setup
├── emacs/                # Configuração Emacs (~600MB com pacotes)
│   ├── init.el           # Configuração principal
│   ├── lisp/             # Custom Elisp
│   └── config/           # Configurações modulares
├── vim/                  # Configuração Vim
│   ├── vimrc             # Main config (8K linhas)
│   └── bundle/           # Plugins
├── tmux/                 # Configuração Tmux
│   └── tmux.conf         # Config com vim bindings
├── git/                  # Configuração Git
│   ├── gitconfig         # User settings + aliases
│   └── gitignore         # Global gitignore
├── linux/                # Configuração X11
│   ├── Xresources        # X11 resources
│   └── Xmodmap           # Keyboard mapping
├── bin/                  # Scripts e binários
│   ├── giffy             # Utilitário para GIFs
│   ├── init-node-project # Inicialização de projetos Node
│   └── webdir            # Servidor web simples
├── ssh/                  # Configuração SSH
│   └── config            # SSH client config
├── autoinstall.yml       # Ubuntu cloud-init autoinstall
├── Makefile              # Automação VirtualBox
├── setup-binaries.sh     # Download de dependências binárias
└── .github/workflows/    # GitHub Actions CI/CD

```

## 🚀 Instalação

### Pré-requisitos

- Ubuntu 24.04 LTS
- Conexão com internet
- Git instalado
- Sudo privileges

### Instalação Rápida

```bash
# 1. Clonar o repositório
git clone https://github.com/pahagon/my-ubuntu-desktop.git ~/dot
cd ~/dot

# 2. Executar bootstrap (cria symlinks dos dotfiles)
./bootstrap

# 3. Instalar ferramentas via Ansible
cd ansible
ansible-playbook workstation.yml --ask-become-pass

# 4. (Opcional) Instalar dependências binárias
cd ..
./setup-binaries.sh
```

### Instalação Modular

Você pode instalar componentes específicos:

```bash
# Instalar apenas Docker
ansible-playbook ansible/docker.yml --ask-become-pass

# Instalar Python + ASDF
ansible-playbook ansible/python.yml --ask-become-pass

# Instalar Node.js
ansible-playbook ansible/nodejs.yml --ask-become-pass

# Instalar Emacs
ansible-playbook ansible/emacs.yml --ask-become-pass
```

### Dependências Binárias

Binários grandes (AppImages, executáveis) não são versionados no git. Use o script de setup:

```bash
./setup-binaries.sh
```

O script oferece instalação interativa de:
- **Arduino CLI**: Para desenvolvimento Arduino
- **Cursor IDE**: Editor moderno baseado em VS Code

Para instalar tudo automaticamente:
```bash
./setup-binaries.sh --all
```

## 🔧 Configuração

### Bash

As configurações Bash são carregadas em camadas:
1. `bash/profile` - Environment variables e inicialização
2. `bash/rc` - Runtime configuration, functions
3. `bash/alias` - Command aliases
4. `bash/asdf` - ASDF version manager
5. `bash/aws` - AWS CLI configuration

### Emacs

Configuração gerenciada via `straight.el` para package management reproduzível:
- **init.el**: Configuração principal em `emacs/init.el:1`
- **Packages**: Definidos em straight.el (30+ repositórios)
- **Temas**: Dracula, Solarized, e outros
- **Copilot**: GitHub Copilot integrado

Para recarregar configuração: `M-x eval-buffer` no init.el

### Vim

- **Vundle**: Plugin manager
- **Configuração**: `vim/vimrc:1` (8K linhas)
- **Temas**: Railscasts e outros

### Git

30+ aliases úteis definidos em `git/gitconfig:1`:
```bash
git st      # status
git co      # checkout
git br      # branch
git lg      # log gráfico bonito
# ... e muitos outros
```

### Tmux

- **Prefix**: `Ctrl+b` (padrão)
- **Vim bindings**: Navegação estilo vim
- **Mouse support**: Enabled
- **Powerline**: Status line integrada

## 🐳 Docker

Docker e Docker Compose são instalados via `ansible/docker.yml:1`. Usuário é adicionado ao grupo docker automaticamente.

## 📦 ASDF Version Manager

Gerenciador unificado de versões para múltiplas linguagens:

```bash
# Listar versões instaladas
asdf list

# Instalar nova versão
asdf install python 3.12.0

# Definir versão global
asdf global python 3.12.0

# Definir versão local (por projeto)
asdf local nodejs 20.12.0
```

## 🤖 Ubuntu Autoinstall

O arquivo `autoinstall.yml:1` fornece configuração cloud-init para instalação desatendida do Ubuntu:

### Testar Autoinstall Localmente

```bash
# Criar VM VirtualBox com autoinstall
make vm-create
make vm-start

# Limpar VM
make vm-clean
```

### Deploy em Produção

O autoinstall pode ser usado para:
- Instalação em bare-metal via USB bootável
- Deploy em VMs (VirtualBox, QEMU/KVM, VMware)
- Provisionamento de cloud instances

## 🔄 CI/CD

GitHub Actions valida automaticamente a configuração de autoinstall em `.github/workflows/autoinstall-test.yml:1`.

## 🎨 Customização

### Adicionar Novo Playbook Ansible

```yaml
# ansible/meu-tool.yml
---
- name: Instalar Meu Tool
  hosts: localhost
  become: true
  vars_files:
    - common_vars.yml
  tasks:
    - name: Instalar pacotes
      apt:
        name:
          - meu-pacote
        state: present
```

### Adicionar Alias Bash

Edite `bash/alias:1` e adicione:
```bash
alias meucomando='echo "Hello World"'
```

Depois recarregue: `source ~/.bashrc`

### Adicionar Git Alias

Edite `git/gitconfig:1`:
```ini
[alias]
    meucomando = !git status && git log -1
```

## 📊 Métricas do Repositório

- **Tamanho do repositório git**: ~23MB (limpo!)
- **Working directory**: ~1.8GB (com binários locais)
- **Ansible playbooks**: 18+
- **Emacs packages**: 50+
- **Linguagens suportadas**: Python, Node.js, Go, Ruby, Java, Elixir
- **Commits**: Seguem [Conventional Commits](semantic-commit-messages.md)

## 🔐 Segurança

- Arquivos de chave SSH são ignorados via `.gitignore`
- Credenciais AWS não são versionadas
- `.env` files automaticamente ignorados
- Recomendação: Use `git-secrets` para prevenir commit de secrets

## 🛠️ Troubleshooting

### Symlinks não criados

```bash
cd ~/dot
./bootstrap --force
```

### Ansible falha com "permissão negada"

Certifique-se de executar com `--ask-become-pass`:
```bash
ansible-playbook workstation.yml --ask-become-pass
```

### Emacs não carrega pacotes

```bash
# Reinstalar pacotes straight.el
rm -rf ~/.emacs.d/straight
emacs  # Packages serão reinstalados automaticamente
```

### ASDF comando não encontrado

```bash
# Reinstalar ASDF
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0
source ~/.bashrc
```

## 🤝 Contribuindo

Contribuições são bem-vindas! Consulte [CONTRIBUTING.md](CONTRIBUTING.md) para o processo completo e [BRANCHING.md](BRANCHING.md) para a estratégia de branches.

**Quick start**:

1. Fork o repositório
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças seguindo [Conventional Commits](semantic-commit-messages.md)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

### Estilo de Commits

Este projeto usa [Semantic Commit Messages](semantic-commit-messages.md):

```
feat: adiciona suporte para Rust via ASDF
fix: corrige path do Python no ansible
docs: atualiza README com instruções de troubleshooting
chore: atualiza .gitignore para ignorar .env files
```

## 📝 License

MIT License - veja [LICENSE](LICENSE.md) para detalhes.

Copyright (c) 2019-2025 Paulo Ahagon

## 🙏 Agradecimentos

- **Ansible Community** - Automação IaC
- **Emacs Community** - straight.el, evil-mode, e pacotes incríveis
- **ASDF Team** - Version manager unificado
- **Ubuntu** - Sistema operacional base
- **Powerline** - Status line visual
- **Todos os contribuidores** de ferramentas open-source usadas neste projeto

## 📚 Recursos Adicionais

- [Ansible Documentation](https://docs.ansible.com/)
- [Ubuntu Autoinstall](https://ubuntu.com/server/docs/install/autoinstall)
- [ASDF Documentation](https://asdf-vm.com/)
- [Emacs Documentation](https://www.gnu.org/software/emacs/manual/)
- [Tmux Documentation](https://github.com/tmux/tmux/wiki)

---

⭐ Se este projeto foi útil para você, considere dar uma estrela!

**Maintainer**: [@pahagon](https://github.com/pahagon)
