IMAGE=wpengine/pyavatax

VERSION_MAJOR = 1
VERSION_MINOR = 3
VERSION_PATCH = 8
# BUILD_NUMBER: supplied to us by the environment.
SEMVER = $(VERSION_MAJOR).$(VERSION_MINOR).$(VERSION_PATCH).$(BUILD_NUMBER)


# We create this file as part of the build so that we can automatically
# increment the semver based on the BUILD_NUMBER.
VERSION_FILE = "pyavatax/VERSION"

# Build the project:
build: sdist

# Build the docker image used by other steps:
docker_image:
	docker build . -t ${IMAGE}

test: docker_image
	docker run --rm -i -v ${PWD}:/app ${IMAGE} python setup.py test

sdist: version #docker_image version
	docker run --rm -t -v ${PWD}:/app ${IMAGE} python setup.py sdist
	docker run --rm -v ${PWD}:/app \
		-e SEMVER=$(SEMVER) \
		${IMAGE} \
		./test_semver.sh

shell: docker_image
	docker run --rm -it -v ${PWD}:/app ${IMAGE} /bin/sh

clean:
	rm -rf dist PyAvaTax.egg-info
	-rm $(BUILD_NUMBER_FILE)

# Save the current version to a file used to construct the full semver.
version:
	@if [ -z "$(BUILD_NUMBER)" ]; then \
	    echo "The BUILD_NUMBER environment variable must be set."; \
		exit 1; \
	fi
	echo "$(SEMVER)" > $(VERSION_FILE)

.PHONY: build docker_image test sdist shell clean version
