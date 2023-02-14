#!/bin/sh

./bin/markdown.nopgo &
go test github.com/task4233/pgo-test/load -bench=. -count=20 -source ../README.md > ./log/nopgo.txt
pkill markdown.nopgo

./bin/markdown.withpgo &
go test github.com/task4233/pgo-test/load -bench=. -count=20 -source ../README.md > ./log/withpgo.txt
pkill markdown.withpgo
