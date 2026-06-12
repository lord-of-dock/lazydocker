# This dockerfile uses extends image https://hub.docker.com/lord-of-dock/lazydocker
# VERSION 1
# Author: sinlov
# dockerfile offical document https://docs.docker.com/engine/reference/builder/
# https://hub.docker.com/_/golang
FROM golang:1.23.12 AS golang-builder

ARG GO_PKG_RELEASE_VERSION=0.25.2
ARG GO_ENV_PACKAGE_NAME=github.com/jesseduffield/lazydocker
ARG GO_ENV_ROOT_BUILD_BIN_NAME=lazydocker
ARG GO_ENV_ROOT_BUILD_BIN_PATH=build/${GO_ENV_ROOT_BUILD_BIN_NAME}
ARG GO_ENV_ROOT_BUILD_ENTRANCE=main.go

ARG GO_PATH_SOURCE_DIR=/go/src
RUN mkdir -p ${GO_PATH_SOURCE_DIR}
WORKDIR ${GO_PATH_SOURCE_DIR}
# COPY $PWD ${GO_PATH_SOURCE_DIR}/${GO_ENV_PACKAGE_NAME}

RUN git clone https://${GO_ENV_PACKAGE_NAME}.git -b v${GO_PKG_RELEASE_VERSION} --depth=1 ${GO_ENV_PACKAGE_NAME}
WORKDIR ${GO_PATH_SOURCE_DIR}/${GO_ENV_PACKAGE_NAME}

# proxy golang
RUN go env -w "GOPROXY=https://goproxy.cn,direct"
RUN go env -w "GOPRIVATE='*.gitlab.com,*.gitee.com"

RUN export GOARCH=$(go env GOHOSTARCH)
RUN export GOOS=$(go env GOHOSTOS)

RUN go mod download -x

RUN CGO_ENABLED=0 \
  go build \
  -a \
  -mod=vendor \
  -ldflags '-w -s' \
  -tags netgo \
  -X main.version=${GO_PKG_RELEASE_VERSION} \
  -X main.buildSource=Docker \
  -o ${GO_ENV_ROOT_BUILD_BIN_PATH} \
  ${GO_ENV_ROOT_BUILD_ENTRANCE}

# https://hub.docker.com/_/alpine
FROM alpine:3.23.4

# ARG DOCKER_CLI_VERSION=${DOCKER_CLI_VERSION}
ARG GO_ENV_PACKAGE_NAME=github.com/jesseduffield/lazydocker
ARG GO_ENV_ROOT_BUILD_BIN_NAME=lazydocker
ARG GO_ENV_ROOT_BUILD_BIN_PATH=build/${GO_ENV_ROOT_BUILD_BIN_NAME}

ARG GO_PATH_SOURCE_DIR=/go/src

#RUN apk --no-cache add \
#  ca-certificates mailcap curl \
#  && rm -rf /var/cache/apk/* /tmp/*

RUN mkdir /app
WORKDIR /app

COPY --from=golang-builder ${GO_PATH_SOURCE_DIR}/${GO_ENV_PACKAGE_NAME}/${GO_ENV_ROOT_BUILD_BIN_PATH} /bin/
ENTRYPOINT [ "lazydocker" ]
# CMD ["lazydocker", "--help"]