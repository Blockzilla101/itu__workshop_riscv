source $::env(SCRIPTS_DIR)/openroad/common/pdn_cfg.tcl

### Macros

# Register File

# define_pdn_grid -macro -name reg_file -instances "\core.reg_file.reg_file" -starts_with POWER
# add_pdn_ring -grid reg_file -layers "met5 met4" -widths 1.6 -spacings 1.7 -core_offset 3.5
# add_pdn_stripe -grid reg_file -layer met5 -width 1.6 -pitch 75 -offset 30 -spacing 1.7 -nets "vccd1 vssd1" -starts_with POWER -extend_to_core_ring
# add_pdn_connect -grid reg_file -layers "met4 met5"

