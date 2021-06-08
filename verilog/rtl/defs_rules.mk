FWSPI_MEMIO_RTLDIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

ifneq (1,$(RULES))

ifeq (,$(findstring $(FWSPI_MEMIO_RTLDIR),$(MKDV_INCLUDED_DEFS)))
MKDV_INCLUDED_DEFS += $(FWSPI_MEMIO_RTLDIR)
include $(PACKAGES_DIR)/fwprotocol-defs/verilog/rtl/defs_rules.mk
MKDV_VL_SRCS += $(wildcard $(FWSPI_MEMIO_RTLDIR)/*.v)
endif

else # Rules

endif

