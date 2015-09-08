TESTCASES = testresults/frontpage testresults/greeting testresults/unknown-url

test: $(TESTCASES)
	$(MAKE) test-server-unsetup

clean-tests: 
	rm $(TESTCASES)

stamps/test-dependencies-setup: stamps/sudo-setup
	sudo apt-get install curl
	touch $@

test-environment: stamps/test-server-setup stamps/test-dependencies-setup

testresults/frontpage: test-environment
	curl -sI http://localhost:5000/ | grep 'Location: .*/greet/World'
	echo PASS > $@

testresults/greeting: test-environment
	curl -s http://localhost:5000/greet/Hemmo | grep 'Hello, Hemmo'
	echo PASS > $@

testresults/unknown-url: test-environment
	curl -sI http://localhost:5000/tweet | grep '404 NOT FOUND'
	echo PASS > $@

