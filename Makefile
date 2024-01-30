PARTS	= alu ram
CP	= ghdl
FLAGS	= --std=08
ALUSRC	= src/alu.vhd tb/tb_alu.vhd
RAMSRC	= src/ram_block.vhd src/ram.vhd tb/rb_ram.vhd
STOP 	= 6000ns

all: $(PARTS)

alu: $(ALUSRC)
	$(CP) -a $(FLAGS) $(ALUSRC)
	$(CP) -e $(FLAGS) tb_$@
	$(CP) -r $(FLAGS) tb_$@ --wave=$@.ghw --stop-time=$(STOP)

ram: $(RAMSRC)
	$(CP) -a $(FLAGS) $(RAMSRC)
	$(CP) -e $(FLAGS) tb_$@
	$(CP) -r $(FLAGS) tb_$@ --wave=$@.ghw --stop-time=$(STOP)

clean:
	find . -name '*.o' -exec rm -r {} \;
	find . -name '*.cf' -exec rm -r {} \;
	find . -name '*.ghw' -exec rm -r {} \;
	find . -name '*_tb' -exec rm -r {} \;

.PHONY: all alu clean
