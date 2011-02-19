#
# WikiGraph
# Copyright (c) 2011
#
# Author: Thomas Van Doren <thomas.vandoren@gmail.com>
#
# Build the various WikiGraph targets.
#
# TODO: add revision or build number to output name

MXMLC = $FLEX_PATH/mxmlc
HG = hg
PHPUNIT = phpunit
Z = tar -czvf

OUTPUT = output
FLEXOUT = bin
REPO = .

APINAME = WikiGraph-Services
TESTAPINAME = WikiGraph-Test-Services

CLIENTNAME = WikiGraph-FlashClient
TESTCLIENTNAME = WikiGraph-Test-FlashClient

TESTBRANCH = dev
BRANCH = release

ALLTESTS = AllTests

all: graph api

build: testapi test

pull:
	$(HG) pull
	$(HG) update

check: pull
	$(HG) checkout $(BRANCH)
	cd $(REPO)/services/test ; \
	$(PHPUNIT) $(ALLTESTS) ; \
	cd ../.. ;

checktest: pull
	$(HG) checkout $(TESTBRANCH)
	cd $(REPO)/services/test ; \
	$(PHPUNIT) $(ALLTESTS) ; \
	cd ../.. ;

checkclient: pull
	$(HG) checkout $(BRANCH)

checkclienttest: pull
	$(HG) checkout $(TESTBRANCH)

graph: checkclient
	cd client ; \  # TODO: this need to actually compile the sources
	$(Z) ../$(OUTPUT)/$(CLIENTNAME).tar.gz *.swf *.html ; \
	cd .. ;

test: checkclienttest
	cd client ; \ # TODO: this needs to actually compile the sources
	$(Z) ../$(OUTPUT)/$(TESTCLIENTNAME).tar.gz *.swf *.html ; \
	cd .. ;

api: check
	cd services ; \
	$(Z) ../$(OUTPUT)/$(APINAME).tar.gz `find . -type f -regextype posix-egrep -regex ".*\.php" | grep -v test/* | grep -v config.php`; \
	cd .. ; 


testapi: checktest output
	cd services ; \
	$(Z) ../$(OUTPUT)/$(TESTAPINAME).tar.gz `find . -type f -regextype posix-egrep -regex ".*\.php" | grep -v test/* | grep -v config.php`; \
	cd .. ;

output:
	test -d $(OUTPUT) || mkdir $(OUTPUT)
	test -d $(OUTPUT)/$(FLEXOUT) || mkdir $(OUTPUT)/$(FLEXOUT)

clean:
	rm -rf $(OUTPUT)