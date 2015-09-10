EASY_TARGETS = stamps/docker-image-flask stamps/docker-image-test \
	       docker-image-test

all:
	@echo 'Use "make test", "make deploy" or "make clean".'
	@echo 'Also, you can set up your development environment with'
	@echo '"make development-setup".'

clean: test-server-unsetup
	rm -rf $(EASY_TARGETS)

.PHONY: all clean

include makefiles/*.mk

