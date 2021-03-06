files := $(shell find . -name "*.go" | grep -v vendor)

bootstrap:
	go get github.com/golang/dep/cmd/dep
	go get github.com/golang/lint/golint
	go get honnef.co/go/tools/cmd/megacheck

clean:
	goimports -w $(files)

test: clean
	go test

lint:
	golint -set_exit_status
	golint -set_exit_status example
	megacheck -ignore 'github.com/sdcoffey/techan/vendor/*.go:' github.com/sdcoffey/techan
	megacheck -ignore 'github.com/sdcoffey/techan/vendor/*.go:' github.com/sdcoffey/techan/example

bench: clean
	go test -bench .

commit: test
	git commit

release: clean test lint
	./scripts/release.sh

coverage: clean
	go test -race -cover -covermode=atomic -coverprofile=bin/coverage.txt
	go tool cover -html bin/coverage.txt
