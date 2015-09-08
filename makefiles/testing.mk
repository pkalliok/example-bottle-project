TESTCASES = testresults/frontpage testresults/greeting testresults/unknown-url

test: $(TESTCASES)
	@echo "====> all tests passed <===="

clean-tests: 
	rm -f $(TESTCASES)

stamps/test-dependencies-setup: stamps/sudo-setup
	sudo apt-get install curl
	touch $@

test-environment: stamps/test-server-setup stamps/test-dependencies-setup

# build testing images
docker-image-test: test-example-flask.docker example-flask.py \
		stamps/docker-image-flask
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

# test cases
testresults/frontpage: test-environment
	curl -sI http://localhost:5000/ | grep -q 'Location: .*/greet/World'
	echo PASS > $@

testresults/greeting: test-environment
	curl -s http://localhost:5000/greet/Hemmo | grep -q 'Hello, Hemmo'
	echo PASS > $@

testresults/unknown-url: test-environment
	curl -sI http://localhost:5000/tweet | grep -q '404 NOT FOUND'
	echo PASS > $@

