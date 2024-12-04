TEMP_DIR := /tmp/ubuntu-autoinstall
ISO_URL := https://deb.campolargo.pr.gov.br/ubuntu/releases/24.04.1/ubuntu-24.04.1-desktop-amd64.iso
ISO_FILE := $(TEMP_DIR)/ubuntu.iso
VM_NAME := ubuntu-autoinstall
DISK_FILE := ubuntu.vdi
AUTOINSTALL_DIR := nocloud
AUTOINSTALL_ISO := autoinstall.iso
VM_MEMORY := 2048
VM_CPUS := 2
VM_DISK_SIZE := 10000 # 20GB

all: download_iso create_vm attach_iso start_vm

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
	@if [ ! -d $(AUTOINSTALL_DIR) ]; then \
		mkdir -p $(AUTOINSTALL_DIR); \
	fi
	@cp autoinstall.yaml $(AUTOINSTALL_DIR)/user-data
	@echo "instance-id: $(VM_NAME)" > $(AUTOINSTALL_DIR)/meta-data
	@genisoimage -output $(AUTOINSTALL_ISO) -volid cidata -joliet -rock $(AUTOINSTALL_DIR)

attach_iso: create_autoinstall_iso
	@echo "Attaching ISO files..."
	@VBoxManage storageattach $(VM_NAME) --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium $(ISO_FILE)
	@VBoxManage storageattach $(VM_NAME) --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium $(AUTOINSTALL_ISO)

start_vm:
	@echo "Starting VM: $(VM_NAME)..."
	@VBoxManage startvm $(VM_NAME) --type headless

download_iso:
	@echo "Checking if ISO is already downloaded..."
	@if [ ! -f $(ISO_FILE) ]; then \
		echo "ISO not found. Downloading from $(ISO_URL)..."; \
		mkdir -p $(TEMP_DIR); \
		curl -L -o $(ISO_FILE) $(ISO_URL); \
		echo "ISO downloaded to $(ISO_FILE)"; \
	else \
		echo "ISO already exists at $(ISO_FILE)."; \
	fi

clean:
	@if VBoxManage list vms | grep -q '"$(VM_NAME)"'; then \
		echo "Removing VM: $(VM_NAME)"; \
		VBoxManage unregistervm $(VM_NAME) --delete; \
	fi
	@if [ -f $(AUTOINSTALL_ISO) ]; then \
		rm -f $(AUTOINSTALL_ISO); \
	fi
	@if [ -f $(DISK_FILE) ]; then \
		rm -f $(DISK_FILE); \
	fi
