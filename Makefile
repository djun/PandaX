.PHONY: all build-linux build-windows build-darwin docker-build clean

PROJECT_NAME := pandax
PKG := github.com/yourusername/$(PROJECT_NAME)
VERSION := $(shell git describe --always --long --dirty)
BUILD_TIME := $(shell date +%FT%T%z)
LDFLAGS := -X main.version=$(VERSION) -X main.buildTime=$(BUILD_TIME)

GOARCH ?= $(shell go env GOARCH)
GOBUILD := go build -v -ldflags '$(LDFLAGS)'
GOINSTALL := go install -v -ldflags '$(LDFLAGS)'

DOCKER_IMAGE := yourdockerhubusername/$(PROJECT_NAME)
DOCKER_TAG := latest

all: build

build: build-$(shell go env GOOS)

build-linux:
	GOOS=linux GOARCH=$(GOARCH) $(GOBUILD) -o build/$(PROJECT_NAME)-linux-$(GOARCH)

build-windows:
	GOOS=windows GOARCH=$(GOARCH) $(GOBUILD) -o build/$(PROJECT_NAME)-windows-$(GOARCH).exe

build-darwin:
	GOOS=darwin GOARCH=$(GOARCH) $(GOBUILD) -o build/$(PROJECT_NAME)-darwin-$(GOARCH)

docker-build:
	docker build -t $(DOCKER_IMAGE):$(DOCKER_TAG) .

clean:
	rm -rf build/*

