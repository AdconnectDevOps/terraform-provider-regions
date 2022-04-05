HOSTNAME=registry.terraform.io
NAMESPACE=mirelia-dev
NAME=regions
BINARY=terraform-provider-${NAME}
VERSION=1.0.3
OS_ARCH=linux_amd64

default: init

init:
	docker run -v `pwd`:/app -w /app -it golang:latest /bin/bash

get:
	go get 

dir:
	mkdir -p ./build

build-dev:
	go build -o ${BINARY}

build: get dir
	GOOS=darwin GOARCH=amd64 go build -o ./build/darwin_amd64/${BINARY}_v${VERSION}
	GOOS=darwin GOARCH=arm64 go build -o ./build/darwin_arm64/${BINARY}_v${VERSION}
	GOOS=linux GOARCH=amd64 go build -o ./build/linux_amd64/${BINARY}_v${VERSION}

clean-build:
	rm -rf build/

create-release:
	rm -rf build/release
	mkdir -p build/release
	zip -j build/release/$(BINARY)_$(VERSION)_linux_amd64.zip build/linux_amd64/$(BINARY)_v$(VERSION)
	zip -j build/release/$(BINARY)_$(VERSION)_darwin_amd64.zip build/darwin_amd64/$(BINARY)_v$(VERSION)
	zip -j build/release/$(BINARY)_$(VERSION)_darwin_arm64.zip build/darwin_arm64/$(BINARY)_v$(VERSION)
	cd build/release && shasum -a 256 *.zip > $(BINARY)_$(VERSION)_SHA256SUMS
	gpg --detach-sign --default-key "key for sign" build/release/$(BINARY)_$(VERSION)_SHA256SUMS

dev: get build-dev
	mkdir -p ~/.terraform.d/plugins/${HOSTNAME}/${NAMESPACE}/${NAME}/${VERSION}/${OS_ARCH}
	cp ${BINARY} ~/.terraform.d/plugins/${HOSTNAME}/${NAMESPACE}/${NAME}/${VERSION}/${OS_ARCH}
