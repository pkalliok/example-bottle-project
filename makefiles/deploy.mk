
DEPLOY_USER=atehwa
DEPLOY_SERVER=aulis.sange.fi
SSH_DEST=$(DEPLOY_USER)@$(DEPLOY_SERVER)

.PHONY: deploy undeploy test-deploy

deploy: stamps/deploy

stamps/deploy: source/example-flask.py source/restart-example-flask \
		stamps/install-depends
	rsync $^ $(SSH_DEST):example-flask/
	ssh $(SSH_DEST) example-flask/restart-example-flask start &
	touch $@

undeploy: stamps/deploy
	ssh $(SSH_DEST) example-flask/restart-example-flask clean
	rm $<

stamps/install-depends:
	ssh $(SSH_DEST) -t sudo apt-get install python python-flask
	touch $@

test-deploy: stamps/deploy
	./scripts/run-tests $(DEPLOY_SERVER):5000

