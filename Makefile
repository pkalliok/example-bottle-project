EASY_TARGETS = stamps/docker-image-flask stamps/docker-image-test \
	       docker-image-test

all:
	@echo 'Use "make test", "make deploy" or "make clean".'
	@echo 'Also, you can set up your development environment with'
	@echo '"make development-setup".'

clean:
	-test -s stamps/test-server-setup && $(MAKE) test-server-unsetup
	rm -rf $(EASY_TARGETS)

include makefiles/*.mk

