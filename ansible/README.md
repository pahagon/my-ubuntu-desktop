# Ansible Playbooks

Este diretório contém playbooks Ansible para automação da instalação e configuração de ferramentas de desenvolvimento no Ubuntu Desktop.

## 📋 Índice

- [Uso Rápido](#uso-rápido)
- [Playbooks Disponíveis](#playbooks-disponíveis)
- [Arquivos Compartilhados](#arquivos-compartilhados)
- [Customização](#customização)
- [Troubleshooting](#troubleshooting)

## 🚀 Uso Rápido

### Ambiente Mínimo

```bash
cd ansible
ansible-playbook desktop-minimal.yml -K
```

### Ambiente Completo

```bash
cd ansible
ansible-playbook desktop-full.yml -K
```

### Instalar Componente Específico

```bash
# Exemplo: Instalar apenas Docker
ansible-playbook docker.yml -K
```

### Modo Dry-run (teste sem executar)

```bash
ansible-playbook desktop-minimal.yml --check -K
```

---

## 📦 Playbooks Disponíveis

### desktop-minimal.yml
**Descrição**: Perfil de instalação para ambiente mínimo de desenvolvimento.

**Inclui**:
- workstation.yml, vim.yml, tmux.yml, powerline-fonts.yml
- node.yml, python.yml, github-cli.yml, claude-code.yml

**Uso**:
```bash
ansible-playbook desktop-minimal.yml -K
```

---

### desktop-full.yml
**Descrição**: Perfil de instalação completo — estende o minimal com todas as ferramentas.

**Inclui** (além do minimal):
- docker.yml, chrome.yml, golang.yml, java.yml
- ruby.yml, emacs27.yml, cursor.yml, arduino-cli.yml
- genisoimage.yml, datadog-ci.yml, graphviz.yml

**Uso**:
```bash
ansible-playbook desktop-full.yml -K
```

---

### workstation.yml
**Descrição**: Cria symlinks dos dotfiles e configura o locale `en_US.UTF-8`.

**O que faz**:
- Cria symlinks de todos os dotfiles para `$HOME`
- Gera o locale `en_US.UTF-8`
- Configura layout de teclado

**Uso**:
```bash
ansible-playbook workstation.yml -K
```

---

### docker.yml
**Descrição**: Instala Docker Engine e Docker Compose, adiciona usuário ao grupo docker.

**O que instala**:
- Docker Engine (última versão)
- Docker Compose
- Dependências (apt-transport-https, ca-certificates)

**Uso**:
```bash
ansible-playbook docker.yml -K
```

**Pós-instalação**: Faça logout/login para que grupo docker tenha efeito.

**Verificar instalação**:
```bash
docker --version
docker compose version
docker run hello-world
```

---

### python.yml
**Descrição**: Instala Python via ASDF version manager.

**O que instala**:
- ASDF (se não estiver instalado)
- Plugin Python para ASDF
- Python 3.12.2
- Dependências de build (make, build-essential, libssl-dev, etc.)

**Uso**:
```bash
ansible-playbook python.yml -K
```

**Pré-requisitos**: ASDF instalado (ou será instalado automaticamente)

**Verificar instalação**:
```bash
asdf list python
python --version
```

**Gerenciar versões**:
```bash
# Instalar outra versão
asdf install python 3.11.0

# Definir versão global
asdf global python 3.11.0

# Definir versão local (por projeto)
asdf local python 3.12.2
```

---

### node.yml
**Descrição**: Instala Node.js e Yarn via ASDF.

**O que instala**:
- ASDF (se não estiver instalado)
- Plugin Node.js para ASDF
- Node.js 20.12.0
- Yarn (via npm global)

**Uso**:
```bash
ansible-playbook node.yml -K
```

**Verificar instalação**:
```bash
asdf list nodejs
node --version
npm --version
yarn --version
```

---

### golang.yml
**Descrição**: Instala Go (Golang) via ASDF.

**O que instala**:
- ASDF (se não estiver instalado)
- Plugin Go para ASDF
- Go 1.17.1

**Uso**:
```bash
ansible-playbook golang.yml -K
```

**Verificar instalação**:
```bash
asdf list golang
go version
```

---

### ruby.yml
**Descrição**: Instala Ruby via ASDF.

**O que instala**:
- ASDF (se não estiver instalado)
- Plugin Ruby para ASDF
- Ruby 3.0.1
- Dependências de build (libssl-dev, libreadline-dev, etc.)

**Uso**:
```bash
ansible-playbook ruby.yml -K
```

**Verificar instalação**:
```bash
asdf list ruby
ruby --version
gem --version
```

---

### java.yml
**Descrição**: Instala Java Development Kit (JDK).

**O que instala**:
- OpenJDK (via apt)
- Variáveis de ambiente JAVA_HOME

**Uso**:
```bash
ansible-playbook java.yml -K
```

**Verificar instalação**:
```bash
java -version
javac -version
echo $JAVA_HOME
```

---

### emacs27.yml
**Descrição**: Instala Emacs 27+ via PPA oficial.

**O que instala**:
- Emacs 27 ou superior
- PPA da comunidade Emacs

**Uso**:
```bash
ansible-playbook emacs27.yml -K
```

**Pré-requisitos**: Ubuntu 24.04 LTS

**Verificar instalação**:
```bash
emacs --version
```

**Nota**: Configurações do Emacs estão em `~/dot/emacs/init.el`

---

### chrome.yml
**Descrição**: Instala Google Chrome navegador.

**O que instala**:
- Google Chrome (stable)
- Repositório oficial do Google

**Uso**:
```bash
ansible-playbook chrome.yml -K
```

**Verificar instalação**:
```bash
google-chrome --version
```

---

### github-cli.yml
**Descrição**: Instala GitHub CLI (gh).

**O que instala**:
- GitHub CLI oficial
- Repositório oficial do GitHub

**Uso**:
```bash
ansible-playbook github-cli.yml -K
```

**Pós-instalação**: Autenticar com GitHub
```bash
gh auth login
```

**Verificar instalação**:
```bash
gh --version
gh auth status
```

---

### virtualbox.yml
**Descrição**: Instala Oracle VirtualBox.

**O que instala**:
- VirtualBox (última versão)
- Extension Pack
- Repositório oficial da Oracle

**Uso**:
```bash
ansible-playbook virtualbox.yml -K
```

**Verificar instalação**:
```bash
VBoxManage --version
```

---

### qemu.yml
**Descrição**: Instala QEMU/KVM para virtualização.

**O que instala**:
- QEMU
- KVM
- libvirt
- virt-manager (GUI)

**Uso**:
```bash
ansible-playbook qemu.yml -K
```

**Pós-instalação**: Adicionar usuário ao grupo libvirt
```bash
sudo usermod -aG libvirt $USER
```

**Verificar instalação**:
```bash
qemu-system-x86_64 --version
virsh version
```

---

### theme-icons.yml
**Descrição**: Instala temas e ícones para GNOME.

**O que instala**:
- Papirus Icon Theme
- Temas GTK populares
- GNOME Shell Extensions

**Uso**:
```bash
ansible-playbook theme-icons.yml -K
```

**Aplicar tema**:
```bash
# Via GNOME Tweaks
gnome-tweaks

# Via linha de comando
gsettings set org.gnome.desktop.interface icon-theme 'Papirus'
```

---

### xsel.yml
**Descrição**: Instala xsel para integração do clipboard com o terminal.

**Uso**:
```bash
ansible-playbook xsel.yml -K
```

**Verificar instalação**:
```bash
xsel --version
```

---

### vim.yml
**Descrição**: Instala Vim e curl (dependência do vim-plug).

**Uso**:
```bash
ansible-playbook vim.yml -K
```

**Verificar instalação**:
```bash
vim --version
```

---

### tmux.yml
**Descrição**: Instala tmux.

**Uso**:
```bash
ansible-playbook tmux.yml -K
```

**Verificar instalação**:
```bash
tmux -V
```

---

### powerline-fonts.yml
**Descrição**: Instala as fontes Powerline (`fonts-powerline`).

**Uso**:
```bash
ansible-playbook powerline-fonts.yml -K
```

---

### claude-code.yml
**Descrição**: Instala o Claude Code via npm global.

**Pré-requisitos**: Node.js instalado via `node.yml`.

**Uso**:
```bash
ansible-playbook claude-code.yml
```

**Verificar instalação**:
```bash
claude --version
```

---

### cursor.yml
**Descrição**: Instala o Cursor IDE baixando o AppImage mais recente.

**Uso**:
```bash
ansible-playbook cursor.yml
```

**Verificar instalação**:
```bash
~/bin/Cursor-latest.AppImage --version
```

---

### arduino-cli.yml
**Descrição**: Baixa e instala o Arduino CLI em `~/bin/`.

**Uso**:
```bash
ansible-playbook arduino-cli.yml
```

**Verificar instalação**:
```bash
arduino-cli version
```

---

### datadog-ci.yml
**Descrição**: Baixa e instala o Datadog CI CLI em `~/bin/`.

**Uso**:
```bash
ansible-playbook datadog-ci.yml
```

**Verificar instalação**:
```bash
datadog-ci version
```

---

### argocd-cli.yml
**Descrição**: Baixa e instala o ArgoCD CLI em `~/bin/`.

**Uso**:
```bash
ansible-playbook argocd-cli.yml
```

**Verificar instalação**:
```bash
argocd version --client
```

---

### graphviz.yml
**Descrição**: Instala o Graphviz para geração de grafos e diagramas.

**Uso**:
```bash
ansible-playbook graphviz.yml -K
```

**Verificar instalação**:
```bash
dot -V
```

---

## 📄 Arquivos Compartilhados

### common_vars.yml
Define variáveis compartilhadas entre playbooks:
- `my_user`: Nome do usuário atual
- `my_home`: Diretório home do usuário

**Exemplo de uso no playbook**:
```yaml
vars_files:
  - common_vars.yml

tasks:
  - name: Exemplo
    debug:
      msg: "Usuário: {{ my_user }}, Home: {{ my_home }}"
```

### common_tasks.yml
Contém tarefas reutilizáveis, atualmente:
- Instalação do ASDF version manager

**Exemplo de uso no playbook**:
```yaml
- name: Instalar ASDF
  include_tasks: common_tasks.yml
```

---

## 🎨 Customização

### Modificar Versões

Para mudar a versão de uma ferramenta, edite o playbook correspondente:

```yaml
# Exemplo: python.yml
- name: Install Python
  shell: |
    asdf install python 3.11.0  # Mude aqui
    asdf global python 3.11.0
```

### Adicionar Novo Playbook

Crie um novo arquivo `minha-ferramenta.yml`:

```yaml
---
- name: Instalar Minha Ferramenta
  hosts: localhost
  become: true
  vars_files:
    - common_vars.yml

  tasks:
    - name: Adicionar repositório
      apt_repository:
        repo: ppa:meu-repo/ppa
        state: present

    - name: Instalar pacote
      apt:
        name: minha-ferramenta
        state: latest
        update_cache: yes
```

Execute:
```bash
ansible-playbook minha-ferramenta.yml -K
```

### Criar Profile de Instalação

Use `desktop-minimal.yml` como base ou crie um perfil customizado:

```yaml
---
- import_playbook: desktop-minimal.yml
- import_playbook: docker.yml
- import_playbook: golang.yml
```

Execute:
```bash
ansible-playbook meu-perfil.yml -K
```

---

## 🛠️ Troubleshooting

### Erro: "Failed to connect to the host via ssh"

**Problema**: Ansible está tentando conectar via SSH ao localhost.

**Solução**: Certifique-se de que `hosts: localhost` está definido no playbook e que você não está usando inventory externo.

### Erro: "Permission denied"

**Problema**: Tarefa requer privilégios sudo.

**Solução**: Use a flag `-K`:
```bash
ansible-playbook playbook.yml -K
```

### Erro: "Module not found"

**Problema**: Módulo Ansible não instalado.

**Solução**: Instalar Ansible completo:
```bash
sudo apt update
sudo apt install ansible
```

### ASDF command not found após instalação

**Problema**: Shell não recarregou configurações.

**Solução**:
```bash
source ~/.bashrc
# ou
exec bash
```

### Playbook muito lento

**Problema**: apt update executando toda vez.

**Solução**: Use cache de fatos:
```bash
ansible-playbook playbook.yml -K --fact-caching
```

### Verificar sintaxe antes de executar

```bash
ansible-playbook playbook.yml --syntax-check
```

### Modo verbose para debug

```bash
ansible-playbook playbook.yml -vvv -K
```

---

## 📚 Recursos Adicionais

- [Ansible Documentation](https://docs.ansible.com/)
- [Ansible Best Practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)
- [Ansible Galaxy](https://galaxy.ansible.com/) - Roles pré-construídos
- [ASDF Documentation](https://asdf-vm.com/)

---

## 🤝 Contribuindo

Ao criar ou modificar playbooks:

1. **Idempotência**: Playbooks devem ser executáveis múltiplas vezes sem efeitos colaterais
2. **Documentação**: Adicione comentários explicando tarefas complexas
3. **Testes**: Teste em VM antes de commitar
4. **Versionamento**: Use variáveis para versões de software
5. **Naming**: Use nomes descritivos para tarefas

**Exemplo de boa tarefa**:
```yaml
- name: Instalar Docker Engine via repositório oficial
  apt:
    name: docker-ce
    state: present
  register: docker_install
```

---

**Última atualização**: 2026-03-30
