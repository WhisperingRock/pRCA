#!/usr/bin/env bash

# ~~~~ libraries (absolute path) ~~~~
UVM_HOME="/opt/uvm/src"
VERILATOR_HOME="/usr/local/bin"

# ~~~~ local dir (relative path) ~~~~
SRC_DIR="00_rtl/00_src/"
TEST_DIR="01_tb"
TOP_TB_MODULE="tbench_top"
WAVEFILE=""
MERGED_COVERAGE="coverage.dat"

# ~~~~ tests performed ~~~~
TESTS=(
	"fa_smoke_test"
	"fa_coverage_test"
)
# ~~~~~~~~~~~~~~~~~~~~~~~~~

coverage_files=()

printf "\n\n| ~~~~~~~~ Verilator venv ~~~~~~~~~ |\n\n\n\n\n\n\n\n\n"
	python3 -m venv .venv
	source .venv/bin/activate

printf "\n\n| ~~~~~~~~~~~ Testing ~~~~~~~~~~~ |\n\n\n\n\n\n\n\n\n"

	make compile \
		UVM_HOME="$UVM_HOME" \
		TOP_TB_MODULE="$TOP_TB_MODULE" \
		SRC_DIR="$SRC_DIR" \
		TEST_DIR="$TEST_DIR" \

	for TEST in "${TESTS[@]}"; do

		coverage_file="${TEST}.dat"
		coverage_files+=("$coverage_file")

		printf "| ~~ Running %s ~~ |\n\n\n\n\n\n\n\n\n" "$TEST"

		make run \
			UVM_HOME="$UVM_HOME" \
			SEED=42 \
			TOP_TB_MODULE="$TOP_TB_MODULE" \
			SRC_DIR="$SRC_DIR" \
			TEST_DIR="$TEST_DIR" \
			TEST="$TEST" \
			SIM_ARGS="+verilator+coverage+file+$coverage_file"

		if [[ ! -f "$coverage_file" ]]; then
			echo "Error: coverage file was not generated: $coverage_file" >&2
			exit 1
		fi
	done

		
printf "\n\n| ~~~~~~~~~~~ Coverage~~~~~~~~~~~ |\n\n\n\n\n\n\n\n\n"
	# merge covreage reports
	verilator_coverage \
		--write "$MERGED_COVERAGE" \
		"${coverage_files[@]}"

	# print summary
	verilator_coverage \
		--report summary \
		"$MERGED_COVERAGE"

printf "\n\n| ~~~~~~~~~~~ linting ~~~~~~~~~~~ |\n\n\n\n\n\n\n\n\n"
	make lint UVM_HOME=$UVM_HOME \
		SEED=42 \
		TOP_TB_MODULE=$TOP_TB_MODULE \
		SRC_DIR=$SRC_DIR \
		TEST_DIR=$TEST_DIR

printf "\n\n| ~~~~~~~~~~~ clean up and exit~~~~~~~~~~~ |\n\n\n\n\n\n\n\n\n"
	make clean
