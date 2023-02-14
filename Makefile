.PHONY: bench
bench: setup
	./bench.sh
	benchstat ./log/nopgo.txt ./log/withpgo.txt

.PHONY: build
build:
	go build -o ./bin/markdown.nopgo
	go build -pgo=auto -o ./bin/markdown.withpgo

.PHONY: load
load:
	./bin/markdown.nopgo &
	timeout 40 go run ./load/main.go
	sleep 5
	curl -o default.pgo "http://localhost:8080/debug/pprof/profile?seconds=30"
	pkill markdown.nopgo

.PHONY: setup
setup:
	go install golang.org/x/perf/cmd/benchstat@latest
