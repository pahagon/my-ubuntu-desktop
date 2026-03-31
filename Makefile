TEMP_DIR    := /tmp/ubuntu-autoinstall
ISO_URL     := https://releases.ubuntu.com/24.04.1/ubuntu-24.04.1-desktop-amd64.iso
ISO_FILE    := $(TEMP_DIR)/ubuntu.iso
VM_NAME     := ubuntu-autoinstall
DISK_FILE   := $(TEMP_DIR)/ubuntu.vdi
AUTOINSTALL_DIR := $(TEMP_DIR)/nocloud
AUTOINSTALL_ISO := $(TEMP_DIR)/autoinstall.iso
VM_MEMORY   := 2048
VM_CPUS     := 2
VM_DISK_SIZE := 10000

MOLECULE_SCENARIOS := vim tmux docker

.PHONY: all vm-test test test-all clean \
        download_iso create_vm create_autoinstall_iso attach_iso start_vm \
        $(addprefix test-,$(MOLECULE_SCENARIOS))

all: download_iso create_vm attach_iso start_vm

# -----------------------------------------------
# VirtualBox — testa Ubuntu Autoinstall
# -----------------------------------------------
create_vm:
	@if ! VBoxManage list vms | grep -q '"$(VM_NAME)"'; then \
		echo "Creating VM: $(VM_NAME)"; \
		VBoxManage createvm --name $(VM_NAME) --ostype Ubuntu_64 --register; \
		VBoxManage modifyvm $(VM_NAME) --memory $(VM_MEMORY) --cpus $(VM_CPUS) --vram 16; \
		VBoxManage createhd --filename $(DISK_FILE) --size $(VM_DISK_SIZE); \
		VBoxManage storagectl $(VM_NAME) --name "SATA Controller" --add sata --controller IntelAHCI; \
		VBoxManage storageattach $(VM_NAME) --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium $(DISK_FILE); \
		VBoxManage storagectl $(VM_NAME) --name "IDE Controller" --add ide; \
	else \
		echo "VM $(VM_NAME) already exists."; \
	fi

create_autoinstall_iso:
	@mkdir -p $(AUTOINSTALL_DIR)
	@cp -u autoinstall.yml $(AUTOINSTALL_DIR)/user-data
	@echo "instance-id: $(VM_NAME)" > $(AUTOINSTALL_DIR)/meta-data
	@genisoimage -output $(AUTOINSTALL_ISO) -volid cidata -joliet -rock $(AUTOINSTALL_DIR)

attach_iso: create_vm create_autoinstall_iso
	@echo "Attaching ISO files..."
	@VBoxManage storageattach $(VM_NAME) --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium $(ISO_FILE)
	@VBoxManage storageattach $(VM_NAME) --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium $(AUTOINSTALL_ISO)

start_vm:
	@echo "Starting VM: $(VM_NAME)..."
	@VBoxManage startvm $(VM_NAME) --type headless

download_iso:
	@if [ ! -f $(ISO_FILE) ]; then \
		echo "Downloading ISO from $(ISO_URL)..."; \
		mkdir -p $(TEMP_DIR); \
		curl -L -o $(ISO_FILE) $(ISO_URL); \
	else \
		echo "ISO already exists at $(ISO_FILE)."; \
	fi

vm-test: download_iso create_vm attach_iso start_vm

# -----------------------------------------------
# Molecule — testa playbooks Ansible
# -----------------------------------------------
$(addprefix test-,$(MOLECULE_SCENARIOS)):
	cd ansible && molecule test --scenario-name $(subst test-,,$@)

test:
	@for scenario in $(MOLECULE_SCENARIOS); do \
		echo "Running molecule scenario: $$scenario"; \
		(cd ansible && molecule test --scenario-name $$scenario) || exit 1; \
	done

# -----------------------------------------------
# Tudo
# -----------------------------------------------
test-all: vm-test test

# -----------------------------------------------
# Limpeza
# -----------------------------------------------
clean:
	@if VBoxManage list vms | grep -q '"$(VM_NAME)"'; then \
		echo "Removing VM: $(VM_NAME)"; \
		VBoxManage unregistervm $(VM_NAME) --delete; \
	fi
	@rm -f $(AUTOINSTALL_ISO) $(DISK_FILE)
	@rm -rf $(AUTOINSTALL_DIR)
