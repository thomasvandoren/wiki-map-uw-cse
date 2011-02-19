#
# WikiGraph
# Copyright (c) 2011
#
# Author: Thomas Van Doren <thomas.vandoren@gmail.com>
#
# Build the various WikiGraph targets.
#
# TODO: add revision or build number to output name
# TODO: make a DrawGraphConfig.xml (or use one that already exists)

MXMLC = $FLEX_PATH/mxmlc
MXMLCONFIG = config/DrawGraphConfig.xml
MXMLCOPTS = -load-config+=$(MXMLCONFIG) -debug=true -incremental=true -benchmark=false -static-link-runtime-shared-libraries=true -o obj\DrawGraph634326822282731919
HG = hg
PHPUNIT = phpunit
Z = tar -czvf

OUTPUT = output
FLEXOUT = bin
REPO = .

REPOURL = https://wiki-map-uw-cse.googlecode.com/hg/

APINAME = WikiGraph-Services
TESTAPINAME = WikiGraph-Test-Services

CLIENTNAME = WikiGraph-FlashClient
TESTCLIENTNAME = WikiGraph-Test-FlashClient

TESTBRANCH = dev
BRANCH = release

BUILDTAG = 

ALLTESTS = AllTests

all: graph api

build: testapi test

clone:
	$(HG) clone $(REPOURL) 

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

graph: checkclient hudsongraph

hudsongraph: clientoutput
	cd client ; \  # TODO: this need to actually compile the sources
	$(Z) ../$(OUTPUT)/$(CLIENTNAME)/$(BUILDTAG).tar.gz *.swf *.html ; \
	cd .. ;

test: checkclienttest hudsontest

hudsontest: testclientoutput
	cd client ; \ # TODO: this needs to actually compile the sources
	$(Z) ../$(OUTPUT)/$(TESTCLIENTNAME)/$(BUILDTAG).tar.gz *.swf *.html ; \
	cd .. ;

api: check hudsonapi

hudsonapi: apioutput
	cd services ; \
	$(Z) ../$(OUTPUT)/$(APINAME)/$(BUILDTAG).tar.gz `find . -type f -regextype posix-egrep -regex ".*\.php" | grep -v test/* | grep -v config.php`; \
	cd .. ; 

testapi: checktest hudsontestapi

hudsontestapi: testapioutput
	cd services ; \
	$(Z) ../$(OUTPUT)/$(TESTAPINAME)/$(BUILDTAG).tar.gz `find . -type f -regextype posix-egrep -regex ".*\.php" | grep -v test/* | grep -v config.php`; \
	cd .. ;

clientoutput: output
	test -d $(OUTPUT)/$(CLIENTNAME) || mkdir $(OUTPUT)/$(CLIENTNAME)

testclientoutput: output
	test -d $(OUTPUT)/$(TESTCLIENTNAME) || mkdir $(OUTPUT)/$(TESTCLIENTNAME)

apioutput: output
	test -d $(OUTPUT)/$(APINAME) || mkdir $(OUTPUT)/$(APINAME)

testapioutput: output
	test -d $(OUTPUT)/$(TESTAPINAME) || mkdir $(OUTPUT)/$(TESTAPINAME)

output:
	test -d $(OUTPUT) || mkdir $(OUTPUT)

clean:
	rm -rf $(OUTPUT)