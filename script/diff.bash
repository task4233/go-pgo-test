#!/bin/bash

BASE_BIN="nopgo"
PGO_FIRST_BIN="withpgo"
PGO_SECOND_BIN="withpgo2"
PGO_THIRD_BIN="withpgo3"

# 0. export functions
cat "log/${BASE_BIN}.top" | awk '{print $6$7}' | sort | tail -n +7 > "log/${BASE_BIN}.top.sorted"
cat "log/${PGO_FIRST_BIN}.top" | awk '{print $6$7}' | sort | tail -n +7 > "log/${PGO_FIRST_BIN}.top.sorted"
cat "log/${PGO_SECOND_BIN}.top" | awk '{print $6$7}' | sort | tail -n +7 > "log/${PGO_SECOND_BIN}.top.sorted"
cat "log/${PGO_THIRD_BIN}.top" | awk '{print $6$7}' | sort | tail -n +7 > "log/${PGO_THIRD_BIN}.top.sorted"

# 1. export diff
echo "------------------------------------------------"
echo "diff(nopgo vs withpgo(1st))"
echo "------------------------------------------------"
icdiff -U 1 "log/${BASE_BIN}.top.sorted" "log/${PGO_FIRST_BIN}.top.sorted" | grep "(inline)"
echo "------------------------------------------------"
echo "diff(withpgo(1st) vs withpgo(2nd))"
echo "------------------------------------------------"
icdiff -U 1 "log/${PGO_FIRST_BIN}.top.sorted" "log/${PGO_SECOND_BIN}.top.sorted" | grep "(inline)"
echo "------------------------------------------------"
echo "diff(withpgo(2nd) vs withpgo(3rd))"
echo "------------------------------------------------"
icdiff -U 1 "log/${PGO_SECOND_BIN}.top.sorted" "log/${PGO_THIRD_BIN}.top.sorted" | grep "(inline)"
