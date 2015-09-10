
test: stamps/test-server.pid stamps/test-dependencies-setup
	./scripts/run-tests localhost:5000
	@echo "====> all tests passed <===="

stamps/test-dependencies-setup: stamps/sudo-setup
	sudo apt-get install curl
	touch $@

# build testing images
docker-image-test: dockerfiles/test-example-flask.docker \
		source/example-flask.py stamps/docker-image-flask
	mkdir -p $@
	cp $^ $@
	sed "s/%USER%/`whoami`/g" $< > $@/Dockerfile
	touch $@

stamps/docker-image-test: docker-image-test
	docker build --rm -t `whoami`/debian-stable-test-example-flask $<
	touch $@

# run testing server in docker
PIDF=stamps/test-server.pid
$(PIDF): stamps/docker-image-test test-server-unsetup
	docker run -p 5000:5000 -d `whoami`/debian-stable-test-example-flask > $@
	sleep 2

test-server-unsetup:
	-test -s $(PIDF) && docker stop `cat $(PIDF)`
	-test -s $(PIDF) && docker rm `cat $(PIDF)` && rm $(PIDF)

.PHONY: test test-server-unsetup

