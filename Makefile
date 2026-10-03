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

librelane-synth: $(PDK_ROOT)/$(PDK) ## Run LibreLane (to synthesize)
	librelane librelane/config.yaml --pdk ${PDK} --run-tag $(RUN_TAG).synth --overwrite --to Checker.NetlistAssignStatements 
.PHONY: librelane-synth

librelane-staprepnr: $(PDK_ROOT)/$(PDK) ## Run LibreLane (from synth to staprepnr)
	librelane librelane/config.yaml --pdk ${PDK} --run-tag $(RUN_TAG).staprepnr --overwrite -i $(RUN_DIR).synth/*-checker-netlist*/state_out.json --from Checker.NetlistAssignStatements --to OpenRoad.STAPrePnr
.PHONY: librelane-staprepnr

librelane-pdn: $(PDK_ROOT)/$(PDK) ## Run LibreLane (from staprepnr to pdn)
	librelane librelane/config.yaml --pdk ${PDK} --run-tag $(RUN_TAG).pdn --overwrite -i $(RUN_DIR).staprepnr/*-staprepnr*/state_out.json --from OpenRoad.FloorPlan --to OpenRoad.GeneratePDN
.PHONY: librelane-pdn

librelane-gds: $(PDK_ROOT)/$(PDK) ## Run LibreLane (from pdn to gds)
	librelane librelane/config.yaml --pdk ${PDK} --run-tag $(RUN_TAG).gds --overwrite -i $(RUN_DIR).pdn/*-generatepdn*/state_out.json --from Odb.RemovePDNObstructions --to Klayout.Render
.PHONY: librelane-gds

librelane: $(PDK_ROOT)/$(PDK) ## Run LibreLane (full)
	librelane librelane/config.yaml --pdk ${PDK} --run-tag $(RUN_TAG) --overwrite
.PHONY: librelane

clean:
	rm -rf librelane/runs
	rm -rf final
.PHONY: clean
