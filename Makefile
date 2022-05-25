# Variables
APP_NAME=sc2-battle-experiments
ROOT=$(shell pwd)

## Lint
DOCKER_IMAGE_LINTER=alvarofpp/python:linter
LINT_COMMIT_TARGET_BRANCH=origin/main

# Variables for build
USER_ID=$(shell id -u)
GROUP_ID=$(shell id -g)
BUILD_ARGS+=--build-arg USER_ID=${USER_ID} --build-arg GROUP_ID=${GROUP_ID}

# Commands
.PHONY: install-hooks
install-hooks:
	git config core.hooksPath .githooks

.PHONY: build
build: install-hooks
	@docker-compose build --pull ${BUILD_ARGS}

.PHONY: build-no-cache
build-no-cache: install-hooks
	@docker-compose build --no-cache --pull ${BUILD_ARGS}

.PHONY: lint
lint:
	@docker pull ${DOCKER_IMAGE_LINTER}
	@docker run --rm -v ${ROOT}:/app ${DOCKER_IMAGE_LINTER} " \
		lint-commit ${LINT_COMMIT_TARGET_BRANCH} \
		&& lint-markdown \
		&& lint-python"

.PHONY: run
run:
	@docker-compose run --rm \
		${APP_NAME} python3 app/main.py

.PHONY: shell
shell:
	@docker-compose run --rm \
		${APP_NAME} bash
