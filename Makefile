################################################################################
#
# Makefile
#
# Date:	October 2011
#
# Copyright (C) 2011 Texas Instruments Incorporated - http://www.ti.com/
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# 	http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and  
# limitations under the License.
#
################################################################################

MAKEFLAGS += --no-print-directory
SHELL=/bin/bash

ARCH:=arm
CROSS_COMPILE:=arm-none-gnu-eabi-

WL12xx_DIR:=$(PWD)
COMPAT_DIR:=
COMAPT_WIRELESS_DIR:=
KERNEL_DIR:=

# additional packages
FIRMWARE_DIR:=
NVS_DIR:=
ADDITIONAL_BIN_DIR:=
SUPPLICANT_DIR:=$(ADDITIONAL_BIN_DIR)
HOSTAPD_DIR:=$(ADDITIONAL_BIN_DIR)
CALIBRATOR_DIR:=$(ADDITIONAL_BIN_DIR)
IW_DIR:=$(ADDITIONAL_BIN_DIR)
SCRIPTS_DIR:=$(PWD)/scripts

TRASH_DIR:=.trash

export ARCH
export CROSS_COMPILE

.PHONY: all install

install: all
	@echo CREATING wl12xx PACKAGE
	@if [ -d $(TRASH_DIR) ] ; then rm -rf $(TRASH_DIR) ; fi
	@mkdir $(TRASH_DIR)
	@find $(COMAPT_WIRELESS_DIR) -name *.ko -exec cp {} $(TRASH_DIR) \;
	@cp $(FIRMWARE_DIR)/* $(TRASH_DIR)
	@cp $(NVS)/* $(TRASH_DIR)
	@cp $(SUPPLICANT_DIR)/wpa_supplicant $(TRASH_DIR)
	@cp $(SUPPLICANT_DIR)/wpa_cli $(TRASH_DIR)
	@cp $(HOSTAPD_DIR)/hostapd_bin $(TRASH_DIR)
	@cp $(HOSTAPD_DIR)/hostapd_cli $(TRASH_DIR)
	@cp $(CALIBRATOR_DIR)/calibrator $(TRASH_DIR)
	@cp $(IW_DIR)/iw $(TRASH_DIR)
	@cp -r $(SCRIPTS_DIR)/* $(TRASH_DIR)
	@echo packing...
	@tar cvjf $(PWD)/wl12xx_binaries.tar.bz2 $(TRASH_DIR)/*
	@rm -rf $(TRASH_DIR)
	@echo wl12xx PACKAGE IS READY 

all:
	# test cross-tools
	$(CROSS_COMPILE)gcc --version
	# prepare compat-wireless
	@export GIT_TREE=$(WL12xx_DIR)
	@export GIT_COMAPT_TREE=$(COMAPT_DIR)
	@cd $(COMAPT_WIRELESS_DIR) ; \
	sh scripts/admin-refresh ; \
	scripts/driver-select wl12xx
	# make compat-wireless
	@$(MAKE) -C $(COMAPT_WIRELESS_DIR) KLIB=$(KERNEL_DIR) KLIB_BUILD=$(KERNEL_DIR)
	@echo DRIVER BUILD DONE.
	

