SHELL := /usr/bin/env bash


# ~~~~ User Variables ~~~~
SRC_DIR 		?= 
TEST_DIR 		?= 
TOP_TB_MODULE 	?= 
TEST           	?= 
SEED           	?= 
SIM_ARGS		?=
# ~~~~~~~~~~~~~~~~~~~~~~~~

# ~~~~ tools ~~~~
VERILATOR 		?= verilator
UVM_HOME 		?= 
UVM_FILES 		:= $(UVM_HOME)/uvm_pkg.sv

# ~~~~ file searching ~~~~
SDIRS  			:= $(shell find ./$(SRC_DIR) -type d -not -empty)
TDIRS 			:= $(shell find ./$(TEST_DIR) -type d -not -empty)
RTL_INC_DIRS 	:= $(addprefix +incdir+,$(SDIRS))
TB_INC_DIRS 	:= $(addprefix +incdir+,$(TDIRS))
RTL_FILES 		:= $(shell find ./$(SRC_DIR) -type f  -name '*.sv')
TB_FILES  		:= $(shell find ./$(TEST_DIR) -type f -name '*.sv')

SOURCES 		:= \
					$(UVM_FILES) \
					$(RTL_FILES) \
					$(TB_FILES)

INC_DIRS		:= \
				   	$(addprefix +incdir+,\
						$(UVM_HOME) \
						$(SDIRS) \
						$(TDIRS) \
					)


# ~~~~ build vars ~~~~
BUILD_DIR 		?= obj_dir
JOBS      		?= $(shell nproc 2>/dev/null || sysctl -n hw.ncpu)


VERILATOR_FLAGS := \
	-Wno-fatal \
	--binary \
	--coverage \
	-j $(JOBS) \
	--top-module $(TOP_TB_MODULE) \
	--Mdir $(BUILD_DIR) \
	$(INC_DIRS) \
	+define+UVM_NO_DPI \
	+define+UVM_REGEX_NO_DPI \
	--trace-vcd


.PHONY: all compile test regression lint clean version

all: test

version:
	$(VERILATOR) --version

compile:
	$(VERILATOR) $(VERILATOR_FLAGS) $(SOURCES) 

run:
	@test -n "$(TEST)" || { \
		echo "TEST must be specified"; \
		exit 2; \
	}

	./$(BUILD_DIR)/V$(TOP_TB_MODULE) \
		+ntb_random_seed=$(SEED) \
		+UVM_TESTNAME=$(TEST) \
		$(SIM_ARGS)	

test: compile
	$(MAKE) run \
		TEST="$(TEST)" \
		SEED="$(SEED)" \
		SIM_ARGS="$(SIM_ARGS)"

lint:
	$(VERILATOR) \
		--lint-only \
		-Wall \
		-Wno-fatal \
		--top-module $(TOP_TB_MODULE) \
		$(INC_DIRS) \
		$(SOURCES)

clean:
	rm -rf $(BUILD_DIR)
