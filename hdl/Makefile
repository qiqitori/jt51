# Makefile to build UPduino v3.0 jt51.v  with icestorm toolchain
# Original Makefile is taken from: 
# https://github.com/tomverbeure/upduino/tree/master/blink
# On Linux, copy the included upduinov3.rules to /etc/udev/rules.d/ so that we don't have
# to use sudo to flash the bit file.
# Thanks to thanhtranhd for making changes to thsi makefile.

jt51.bin: jt51.asc
	icepack jt51.asc jt51.bin

jt51.asc: jt51.json ../common/upduino.pcf
	# run place and route
	nextpnr-ice40 --up5k --package sg48 --json jt51.json --pcf ../common/upduino.pcf --asc jt51.asc --freq 4.00 --placer-budgets --placed-svg=jt51_placement.svg --routed-svg=jt51_routing.svg # --pcf-allow-unconstrained 

jt51.json: jt51_acc.v jt51_csr_ch.v jt51_csr_op.v jt51_eg.v jt51_exprom.v jt51_kon.v jt51_lfo.v jt51_mmr.v jt51_mod.v jt51_noise.v jt51_op.v jt51_pg.v jt51_phinc_rom.v jt51_phrom.v jt51_pm.v jt51_reg.v jt51_sh.v jt51_timers.v jt51.v jt51_sh8.v
	yosys -q -p "synth_ice40 -dsp -abc2 -blif jt51.blif -json jt51.json" jt51_acc.v jt51_csr_ch.v jt51_csr_op.v jt51_eg.v jt51_exprom.v jt51_kon.v jt51_lfo.v jt51_mmr.v jt51_mod.v jt51_noise.v jt51_op.v jt51_pg.v jt51_phinc_rom.v jt51_phrom.v jt51_pm.v jt51_reg.v jt51_sh.v jt51_timers.v jt51.v

visualize: jt51_acc.v jt51_csr_ch.v jt51_csr_op.v jt51_eg.v jt51_exp2lin.v jt51_exprom.v jt51_kon.v jt51_lfo.v jt51_lin2exp.v jt51_mmr.v jt51_mod.v jt51_noise.v jt51_op.v jt51_pg.v jt51_phinc_rom.v jt51_phrom.v jt51_pm.v jt51_reg.v jt51_sh.v jt51_timers.v jt51.v
	yosys -q -p "prep; show -stretch -prefix count -format dot" jt51_acc.v jt51_csr_ch.v jt51_csr_op.v jt51_eg.v jt51_exp2lin.v jt51_exprom.v jt51_kon.v jt51_lfo.v jt51_lin2exp.v jt51_mmr.v jt51_mod.v jt51_noise.v jt51_op.v jt51_pg.v jt51_phinc_rom.v jt51_phrom.v jt51_pm.v jt51_reg.v jt51_sh.v jt51_timers.v jt51.v

.PHONY: flash
flash:
	iceprog -d i:0x0403:0x6014 jt51.bin

.PHONY: clean
clean:
	$(RM) -f jt51.json jt51.asc jt51.bin
