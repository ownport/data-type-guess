PYTHON ?= /usr/bin/env python
PROJECT_NAME_BIN ?= dtguess
PROJECT_NAME_SRC ?= dtguess

clean:
	@ echo "[INFO] Cleaning directory:" $(shell pwd)/.local-ci
	@ rm -rf $(shell pwd)/.local-ci
	@ echo "[INFO] Cleaning directory:" $(shell pwd)/dtguess.egg-info
	@ rm -rf $(shell pwd)/dtguess.egg-info
	@ echo "[INFO] Cleaning directory:" $(shell pwd)/bin
	@ rm -rf $(shell pwd)/bin
	@ echo "[INFO] Cleaning files: *.pyc"
	@ find . -name "*.pyc" -delete
	@ echo "[INFO] Cleaning files: .coverage"
	@ rm -rf $(shell pwd)/.coverage

compile: clean
	@ echo "[INFO] Compiling to binary, $(PROJECT_NAME_BIN)"
	@ mkdir -p $(shell pwd)/bin
	@ cd $(shell pwd)/$(PROJECT_NAME_SRC)/; zip --quiet -r ../bin/$(PROJECT_NAME_BIN) *
	@ echo '#!$(PYTHON)' > bin/$(PROJECT_NAME_BIN) && \
		cat bin/$(PROJECT_NAME_BIN).zip >> bin/$(PROJECT_NAME_BIN) && \
		rm bin/$(PROJECT_NAME_BIN).zip && \
		chmod a+x bin/$(PROJECT_NAME_BIN)

build-dev-docker-image:
	@ docker build --tag ownport/dtguess-dev-env:py2.7 .


test-all: clean
	@ py.test

test-all-with-coverage: clean
		@ py.test --cov=dtguess --cov-report term-missing --cov-config=.coveragerc

run-local-ci: clean
	local-ci -r $(shell pwd) -s .local-ci.yml
