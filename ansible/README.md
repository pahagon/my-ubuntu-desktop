# Ansible Playbooks

Este diretório contém playbooks Ansible para automação da instalação e configuração de ferramentas de desenvolvimento no Ubuntu Desktop.

## 📋 Índice

- [Uso Rápido](#uso-rápido)
- [Playbooks Disponíveis](#playbooks-disponíveis)
- [Arquivos Compartilhados](#arquivos-compartilhados)
- [Customização](#customização)
- [Troubleshooting](#troubleshooting)

## 🚀 Uso Rápido

### Instalar Tudo

```bash
cd ansible
ansible-playbook workstation.yml --ask-become-pass
```

### Instalar Componente Específico

```bash
# Exemplo: Instalar apenas Docker
ansible-playbook docker.yml --ask-become-pass
```

### Modo Dry-run (teste sem executar)

```bash
ansible-playbook workstation.yml --check --ask-become-pass
```

---

## 📦 Playbooks Disponíveis

### workstation.yml
**Descrição**: Playbook principal que instala ferramentas essenciais e cria symlinks dos dotfiles.

**O que instala**:
- Firefox
- GNOME Tweaks
- Git, Vim, Tmux
- Rxvt-unicode (terminal)
- Powerline (status line)
- Python 3 + pip
- Curl, htop, xsel
- LastPass CLI
- Markdown, genisoimage

**Uso**:
```bash
ansible-playbook workstation.yml --ask-become-pass
```

**Pré-requisitos**: Nenhum

**Nota**: Este é o ponto de entrada recomendado para setup inicial.

---

### docker.yml
**Descrição**: Instala Docker Engine e Docker Compose, adiciona usuário ao grupo docker.

**O que instala**:
- Docker Engine (última versão)
- Docker Compose
- Dependências (apt-transport-https, ca-certificates)

**Uso**:
```bash
ansible-playbook docker.yml --ask-become-pass
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
ansible-playbook python.yml --ask-become-pass
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
ansible-playbook node.yml --ask-become-pass
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
ansible-playbook golang.yml --ask-become-pass
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
ansible-playbook ruby.yml --ask-become-pass
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
ansible-playbook java.yml --ask-become-pass
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
ansible-playbook emacs27.yml --ask-become-pass
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
ansible-playbook chrome.yml --ask-become-pass
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
ansible-playbook github-cli.yml --ask-become-pass
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
ansible-playbook virtualbox.yml --ask-become-pass
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
ansible-playbook qemu.yml --ask-become-pass
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
ansible-playbook theme-icons.yml --ask-become-pass
```

**Aplicar tema**:
```bash
# Via GNOME Tweaks
gnome-tweaks

# Via linha de comando
gsettings set org.gnome.desktop.interface icon-theme 'Papirus'
```

---

### droidcam.yml
**Descrição**: Instala DroidCam para usar smartphone como webcam.

**O que instala**:
- DroidCam client
- Kernel modules necessários

**Uso**:
```bash
ansible-playbook droidcam.yml --ask-become-pass
```

**Pós-instalação**:
1. Instalar app DroidCam no smartphone
2. Conectar via USB ou WiFi
3. Iniciar `droidcam`

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
ansible-playbook minha-ferramenta.yml --ask-become-pass
```

### Criar Profile de Instalação

Combine múltiplos playbooks em um novo arquivo `dev-complete.yml`:

```yaml
---
- import_playbook: workstation.yml
- import_playbook: docker.yml
- import_playbook: python.yml
- import_playbook: node.yml
- import_playbook: golang.yml
```

Execute:
```bash
ansible-playbook dev-complete.yml --ask-become-pass
```

---

## 🛠️ Troubleshooting

### Erro: "Failed to connect to the host via ssh"

**Problema**: Ansible está tentando conectar via SSH ao localhost.

**Solução**: Certifique-se de que `hosts: localhost` está definido no playbook e que você não está usando inventory externo.

### Erro: "Permission denied"

**Problema**: Tarefa requer privilégios sudo.

**Solução**: Use a flag `--ask-become-pass`:
```bash
ansible-playbook playbook.yml --ask-become-pass
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
ansible-playbook playbook.yml --ask-become-pass --fact-caching
```

### Verificar sintaxe antes de executar

```bash
ansible-playbook playbook.yml --syntax-check
```

### Modo verbose para debug

```bash
ansible-playbook playbook.yml -vvv --ask-become-pass
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

**Última atualização**: 2025-12-18
