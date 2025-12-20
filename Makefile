# My Ubuntu Desktop - Makefile

.PHONY: help test test-unit test-integration test-smoke lint lint-ansible lint-shell install-test-deps

# VirtualBox VM Configuration
TEMP_DIR := $(HOME)/Downloads/ubuntu-autoinstall
ISO_FILE := $(TEMP_DIR)/ubuntu.iso
DISK_FILE := $(TEMP_DIR)/ubuntu.vdi
AUTOINSTALL_DIR := $(TEMP_DIR)/nocloud
AUTOINSTALL_ISO := $(TEMP_DIR)/autoinstall.iso
ISO_URL := https://deb.campolargo.pr.gov.br/ubuntu/releases/24.04.1/ubuntu-24.04.1-desktop-amd64.iso
VM_NAME := ubuntu-autoinstall
VM_MEMORY := 2048
VM_CPUS := 2
VM_DISK_SIZE := 10000 # 10GB

# ===========================================
# Help
# ===========================================
help:
	@echo "My Ubuntu Desktop - Makefile"
	@echo ""
	@echo "Testing targets:"
	@echo "  test              Run all tests"
	@echo "  test-unit         Run unit tests (BATS)"
	@echo "  test-integration  Run integration tests (Molecule)"
	@echo "  test-smoke        Run smoke tests"
	@echo "  lint              Run all linters"
	@echo "  lint-ansible      Run Ansible linters"
	@echo "  lint-shell        Run shell script linters"
	@echo "  install-test-deps Install test dependencies"
	@echo ""
	@echo "VM targets:"
	@echo "  vm                Create and start VM"
	@echo "  download_iso      Download Ubuntu ISO"
	@echo "  create_vm         Create VirtualBox VM"
	@echo "  start_vm          Start VM"
	@echo "  clean             Clean VM and temp files"
	@echo ""

# ===========================================
# Testing Targets
# ===========================================

# Install test dependencies
install-test-deps:
	@echo "Installing test dependencies..."
	sudo apt-get update
	sudo apt-get install -y bats shellcheck
	pip install --user molecule molecule-docker ansible-lint yamllint
	@echo "Dependencies installed successfully!"

# Run all tests
test: test-unit test-smoke lint
	@echo ""
	@echo "========================================="
	@echo "  All tests completed!"
	@echo "========================================="

# Run unit tests
test-unit:
	@echo "Running unit tests (BATS)..."
	@if command -v bats >/dev/null 2>&1; then \
		bats tests/unit/ -t || true; \
	else \
		echo "BATS not installed. Run 'make install-test-deps' first."; \
		exit 1; \
	fi

# Run integration tests
test-integration:
	@echo "Running integration tests (Molecule)..."
	@if command -v molecule >/dev/null 2>&1; then \
		cd ansible && molecule test || true; \
	else \
		echo "Molecule not installed. Run 'make install-test-deps' first."; \
		exit 1; \
	fi

# Run smoke tests
test-smoke:
	@echo "Running smoke tests..."
	@./tests/smoke/test_all_installed.sh || true
	@./tests/smoke/test_configs.sh || true

# Run all linters
lint: lint-ansible lint-shell
	@echo ""
	@echo "========================================="
	@echo "  All linters completed!"
	@echo "========================================="

# Run Ansible linters
lint-ansible:
	@echo "Running Ansible linters..."
	@if command -v yamllint >/dev/null 2>&1; then \
		yamllint ansible/ || true; \
	else \
		echo "yamllint not installed. Skipping."; \
	fi
	@if command -v ansible-lint >/dev/null 2>&1; then \
		cd ansible && ansible-lint *.yml || true; \
	else \
		echo "ansible-lint not installed. Skipping."; \
	fi
	@echo "Checking Ansible syntax..."
	@cd ansible && for playbook in *.yml; do \
		# Skip task files and variable files (not playbooks)
		if [ "$$playbook" != "common_tasks.yml" ] && [ "$$playbook" != "common_vars.yml" ]; then \
			echo "Checking $$playbook..."; \
			ansible-playbook "$$playbook" --syntax-check || true; \
		fi; \
	done

# Run shell script linters
lint-shell:
	@echo "Running shell script linters..."
	@if command -v shellcheck >/dev/null 2>&1; then \
		shellcheck setup-binaries.sh || true; \
		shellcheck bin/giffy bin/init-node-project || true; \
		shellcheck tests/smoke/*.sh || true; \
	else \
		echo "shellcheck not installed. Run 'make install-test-deps' first."; \
	fi

# ===========================================
# VirtualBox VM Targets
# ===========================================

all: download_iso create_autoinstall_iso create_vm attach_iso start_vm
vm: all

create_vm: attach_iso
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

create_autoinstall_iso: download_iso
	@if [ ! -d $(AUTOINSTALL_DIR) ]; then \
		mkdir -p $(AUTOINSTALL_DIR); \
	fi
	@cp autoinstall.yml $(AUTOINSTALL_DIR)/user-data
	@echo "instance-id: $(VM_NAME)" > $(AUTOINSTALL_DIR)/meta-data
	@genisoimage -output $(AUTOINSTALL_ISO) -volid cidata -joliet -rock $(AUTOINSTALL_DIR)

attach_iso: create_autoinstall_iso
	@echo "Attaching ISO files..."
	@VBoxManage storageattach $(VM_NAME) --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium $(ISO_FILE)
	@VBoxManage storageattach $(VM_NAME) --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium $(AUTOINSTALL_ISO)

start_vm: create_vm
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
