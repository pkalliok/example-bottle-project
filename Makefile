EASY_TARGETS = stamps/docker-image-flask stamps/docker-image-test \
	       docker-image-test

include testing.mk
include develop.mk

all:
	@echo 'use "make test", "make deploy" or "make clean"'

clean: clean-tests
	-test -s stamps/test-server-setup && $(MAKE) test-server-unsetup
	rm -rf $(EASY_TARGETS)

