RUN_TAG = core-only
TOP = asic_top

PDK = sky130A
PDK_ROOT = $(HOME)/.ciel

RUN_DIR = librelane/runs/$(RUN_TAG)

.DEFAULT_GOAL := help

$(PDK_ROOT)/$(PDK):
	ciel enable $(PDK_COMMIT) --pdk-family $(PDK) --pdk-root $(PDK_ROOT)

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'$(shell ls librelane/runs/ | tail -n 1)
.PHONY: help

librelane-synth: $(PDK_ROOT)/$(PDK) ## Run LibreLane
	librelane librelane/config.yaml --pdk ${PDK} --run-tag $(RUN_TAG).synth --overwrite --to Checker.NetlistAssignStatements 
.PHONY: librelane-synth

librelane-staprepnr: $(PDK_ROOT)/$(PDK) ## Run LibreLane
	librelane librelane/config.yaml --pdk ${PDK} --run-tag $(RUN_TAG).staprepnr --overwrite -i $(RUN_DIR).synth/*-checker-netlist*/state_out.json --from Checker.NetlistAssignStatements --to OpenRoad.STAPrePnr
.PHONY: librelane-staprepnr

clean:
	rm -rf librelane/runs
	rm -rf final
.PHONY: clean
