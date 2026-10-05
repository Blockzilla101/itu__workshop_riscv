RUN_TAG = core-only
TOP = asic_top

PDK = sky130A
PDK_ROOT = $(HOME)/.ciel
PDK_COMMIT = 6d4d11780c40b20ee63cc98e645307a9bf2b2ab8
STD_CELL_LIBRARY = sky130_fd_sc_hd

RUN_DIR = librelane/runs/$(RUN_TAG)


LIBRELANE = librelane librelane/config.yaml --pdk ${PDK} --manual-pdk

.DEFAULT_GOAL := help

$(PDK_ROOT)/$(PDK):
	ciel enable $(PDK_COMMIT) --pdk-family $(PDK) --pdk-root $(PDK_ROOT) -l $(STD_CELL_LIBRARY)

dl-pdk: ## Download PDK
	ciel enable $(PDK_COMMIT) --pdk-family $(PDK) --pdk-root $(PDK_ROOT) -l $(STD_CELL_LIBRARY)
.PHONY: dl-pdk

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'$(shell ls librelane/runs/ | tail -n 1)
.PHONY: help

librelane-synth: $(PDK_ROOT)/$(PDK) ## Run LibreLane (to synthesize)
	$(LIBRELANE) --run-tag $(RUN_TAG).synth --overwrite --to Checker.NetlistAssignStatements 
.PHONY: librelane-synth

librelane-staprepnr: $(PDK_ROOT)/$(PDK) ## Run LibreLane (from synth to staprepnr)
	$(LIBRELANE) --run-tag $(RUN_TAG).staprepnr --overwrite -i $(RUN_DIR).synth/*-checker-netlist*/state_out.json --from Checker.NetlistAssignStatements --to OpenRoad.STAPrePnr
.PHONY: librelane-staprepnr

librelane-pdn: $(PDK_ROOT)/$(PDK) ## Run LibreLane (from staprepnr to pdn)
	$(LIBRELANE) --run-tag $(RUN_TAG).pdn --overwrite -i $(RUN_DIR).staprepnr/*-staprepnr*/state_out.json --from OpenRoad.FloorPlan --to OpenRoad.GeneratePDN
.PHONY: librelane-pdn

librelane-gds: $(PDK_ROOT)/$(PDK) ## Run LibreLane (from pdn to gds)
	$(LIBRELANE) --run-tag $(RUN_TAG).gds --overwrite -i $(RUN_DIR).pdn/*-generatepdn*/state_out.json --from Odb.RemovePDNObstructions --to Klayout.Render
.PHONY: librelane-gds

librelane: $(PDK_ROOT)/$(PDK) ## Run LibreLane (full)
	$(LIBRELANE) --run-tag $(RUN_TAG) --overwrite
.PHONY: librelane

librelane-klayout: $(PDK_ROOT)/$(PDK) ## Run LibreLane (open in klayout)
	$(LIBRELANE) --run-tag $(RUN_TAG) --flow openinklayout
.PHONY: librelane

librelane-openroad: $(PDK_ROOT)/$(PDK) ## Run LibreLane (open in openroad)
	$(LIBRELANE) --run-tag $(RUN_TAG) --flow openinopenroad
.PHONY: librelane

librelane-gds-klayout: $(PDK_ROOT)/$(PDK) ## Run LibreLane (open in klayout)
	$(LIBRELANE) --run-tag $(RUN_TAG).gds --flow openinklayout
.PHONY: librelane

librelane-gds-openroad: $(PDK_ROOT)/$(PDK) ## Run LibreLane (open in openroad)
	$(LIBRELANE) --run-tag $(RUN_TAG).gds --flow openinopenroad
.PHONY: librelane

clean:
	rm -rf librelane/runs/$(RUN_TAG)*
	rm -rf final
.PHONY: clean
