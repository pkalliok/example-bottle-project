
test: stamps/test-server-setup stamps/test-dependencies-setup
	./scripts/run-tests localhost:5000
	@echo "====> all tests passed <===="
	$(MAKE) test-server-unsetup

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
stamps/test-server-setup: stamps/docker-image-test
	docker run -p 5000:5000 -d `whoami`/debian-stable-test-example-flask > $@
	sleep 2

test-server-unsetup: stamps/test-server-setup
	docker stop `cat $<`
	docker rm `cat $<`
	rm $<

