#!/bin/bash

RUN_COUNT=300000
BASE_BIN="nopgo"
PGO_FIRST_BIN="withpgo"
PGO_SECOND_BIN="withpgo2"
PGO_THIRD_BIN="withpgo3"

# 0. preparation
mkdir -p bin log profile

# 1. build without pgo
echo "build without PGO"
go build -o "bin/${BASE_BIN}" -pgo=off
PGO=$(go version -m "bin/${BASE_BIN}" | grep "pgo=")
if [ -n "$PGO" ]; then
    echo "bin/${BASE_BIN} is applied PGO."
    exit 1
fi

# 2. profile ./nopgo
echo "profiling..."
./bin/$BASE_BIN &
go run ./load -count=$RUN_COUNT -quit
mv profile/cpu.pprof "profile/${BASE_BIN}.cpu.pprof"
mv profile/heap.pprof "profile/${BASE_BIN}.heap.pprof"
go tool pprof -top "profile/${BASE_BIN}.cpu.pprof" > "log/${BASE_BIN}.top"

# 3. build with pgo(1st)
echo "build with PGO(1st)"
go build -o "bin/${PGO_FIRST_BIN}" -pgo="profile/${BASE_BIN}.cpu.pprof"
PGO=$(go version -m "bin/${PGO_FIRST_BIN}" | grep "pgo=")
if [ -z "$PGO" ]; then
    echo "bin/${PGO_FIRST_BIN} is not applied PGO."
    exit 1
fi

# 4. profile ./withpgo
echo "profiling..."
./bin/$PGO_FIRST_BIN &
go run ./load -count=$RUN_COUNT -quit
mv profile/cpu.pprof "profile/${PGO_FIRST_BIN}.cpu.pprof"
mv profile/heap.pprof "profile/${PGO_FIRST_BIN}.heap.pprof"
go tool pprof -top "profile/${PGO_FIRST_BIN}.cpu.pprof" > "log/${PGO_FIRST_BIN}.top"

# 5. build with pgo(2nd)
echo "build with PGO(2nd)"
go build -o "bin/${PGO_SECOND_BIN}" -pgo="profile/${PGO_FIRST_BIN}.cpu.pprof"
PGO=$(go version -m "bin/${PGO_SECOND_BIN}" | grep "pgo=")
if [ -z "$PGO" ]; then
    echo "bin/${PGO_SECOND_BIN} is not applied PGO."
    exit 1
fi

# 6. profile ./withpgo2
echo "profiling..."
./bin/$PGO_SECOND_BIN &
go run ./load -count=$RUN_COUNT -quit
mv profile/cpu.pprof "profile/${PGO_SECOND_BIN}.cpu.pprof"
mv profile/heap.pprof "profile/${PGO_SECOND_BIN}.heap.pprof"
go tool pprof -top "profile/${PGO_SECOND_BIN}.cpu.pprof" > "log/${PGO_SECOND_BIN}.top"

# 5. build with pgo(3rd)
echo "build with PGO(3rd)"
go build -o "bin/${PGO_THIRD_BIN}" -pgo="profile/${PGO_SECOND_BIN}.cpu.pprof"
PGO=$(go version -m "bin/${PGO_THIRD_BIN}" | grep "pgo=")
if [ -z "$PGO" ]; then
    echo "bin/${PGO_THIRD_BIN} is not applied PGO."
    exit 1
fi

# 6. profile ./withpgo3
echo "profiling..."
./bin/$PGO_THIRD_BIN &
go run ./load -count=$RUN_COUNT -quit
mv profile/cpu.pprof "profile/${PGO_THIRD_BIN}.cpu.pprof"
mv profile/heap.pprof "profile/${PGO_THIRD_BIN}.heap.pprof"
go tool pprof -top "profile/${PGO_THIRD_BIN}.cpu.pprof" > "log/${PGO_THIRD_BIN}.top"