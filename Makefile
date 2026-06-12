.PHONY: test check clean dist all

TOP_DIR := $(shell pwd)

# default latest
ENV_DIST_VERSION =latest
ROOT_NAME =lazydocker

# MakeImage.mk settings start
ROOT_OWNER =sinlov
ROOT_PARENT_SWITCH_TAG :=3.23.4
# for image local build
INFO_TEST_BUILD_DOCKER_PARENT_IMAGE =alpine
INFO_BUILD_DOCKER_FILE =Dockerfile
INFO_TEST_BUILD_DOCKER_FILE =build.dockerfile
INFO_TEST_BUILD_DOCKER_CONTAINER_ENTRYPOINT =/bin/sh
INFO_TEST_BUILD_DOCKER_CONTAINER_ARGS =
# INFO_TEST_BUILD_DOCKER_PARENT_USER =--user root:root
# MakeImage.mk settings end

include z-MakefileUtils/MakeImage.mk

.PHONY: env
env: dockerEnv

.PHONY: all
all: dockerTestRestartLatest

.PHONY: clean
clean: dockerTestPruneLatest

.PHONY: bakeCheckConfig
bakeCheckConfigImageBasic:
	$(info docker bake: image-basic-all)
	docker buildx bake --print image-basic-all

# .PHONY: bakeCheckConfig
# bakeCheckConfigImageAlpine:
# 	$(info docker bake: image-alpine-all)
# 	docker buildx bake --print image-alpine-all

.PHONY: bakeCheckConfig
bakeCheckConfigAll: bakeCheckConfigImageBasic

.PHONY: help
help: helpDocker
	@echo "Before run this project in docker must install docker"