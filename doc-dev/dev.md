### todo-list

- rename `lord-of-dock/lazydocker` to new github url
- go cli repo [https://github.com/jesseduffield/lazydocker](https://github.com/jesseduffield/lazydocker)
- rename go cli target version `GO_PKG_RELEASE_VERSION=0.25.2` (do not add prefix `v`)
- rename go cli target GO_SRC_PATH `github.com/jesseduffield/lazydocker`
- rename go cli target url `https://${GO_ENV_PACKAGE_NAME}.git`
- rename go cli target Build PATH `build/${GO_ENV_ROOT_BUILD_BIN_NAME}`
- rename go cli target exec build entrance path `main.go` to new
- rename go cli target `lazydocker` to new exec tools name
- rename go cli target build flag `-installsuffix cgo` to new
- rename go cli target ENTRYPOINT `/bin/lazydocker`
- rename local `INFO_TEST_BUILD_DOCKER_CONTAINER_ARGS` at Makefile
- rename docker hub user `sinlov` to new org or user
- rename docker hub `sinlov/lazydocker` to new docker image name

- rename docker repo name at `docker-bake.hcl`
    - `lazydocker` to new docker image name
    - `image-all` to change `platforms`

- use github action for this workflow push to docker hub, must add
    - variables `ENV_DOCKERHUB_OWNER` user of docker hub
    - variables `ENV_DOCKERHUB_REPO_NAME` repo name of docker hub
    - add [secrets](https://github.com/lord-of-dock/lazydocker/settings/secrets/actions) `New repository secret` name `DOCKERHUB_TOKEN` from [hub.docker](https://hub.docker.com/settings/security)

- change `DOCKER_IMAGE_PLATFORMS: linux/amd64,linux/arm64/v8` to your need [docker buildx](https://docs.docker.com/buildx/working-with-buildx/)
  - also change `jobs.docker-image-buildx.strategy.matrix.docker_image.[platform]` same as `DOCKER_IMAGE_PLATFORMS`
- change `push_remote_flag: ${{ github.event.pull_request.merged == true }}` to let latest tag push to docker hub


## source repo

[https://github.com/lord-of-dock/lazydocker](https://github.com/lord-of-dock/lazydocker)

### env

- parent image `alpine` version `3.23.4`
- minimum go image version: go 1.23
- change `go 1.23`, `^1.23`, `1.23.12`, `1.23.12` to new go version

### dev mode

```bash
# see help
$ make help
# see or check build env
$ make env

# fast build
$ make all
# clean build
$ make clean

# then test build as test/Dockerfile
$ make dockerTestRestartLatest
# clean test build
$ make dockerTestPruneLatest
```