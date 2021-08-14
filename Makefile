REPO ?= ghcr.io/williamlsh/srt-docker:latest

.PHONY: build
build:
	@docker build -t $(REPO) .

.PHONY: push
push:
	@docker push $(REPO)
