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

DEF_OUT = $(CURDIR)/build

MXMLC = $FLEX_PATH/mxmlc
MXMLCONFIG = config/DrawGraphConfig.xml
MXMLCOPTS = -load-config+=$(MXMLCONFIG) -debug=true -incremental=true -benchmark=false -static-link-runtime-shared-libraries=true -o obj\DrawGraph634326822282731919
HG = hg
PHPUNITPRE = $(DEF_OUT)/phpunit-log
PHPUNIT = phpunit --log-junit
Z = tar -czvf

OUTPUT =

ifeq ($(strip $(OUTPUT)),)
OUTPUT = $(DEF_OUT)/output
endif

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

check: output
	$(HG) checkout $(BRANCH)
	cd $(REPO)/services/test ; \
	$(PHPUNIT) $(PHPUNITPRE)/$(ALLTESTS).xml $(ALLTESTS) ; \
	cd ../.. ;

checktest: output
	$(HG) checkout $(TESTBRANCH)
	cd $(REPO)/services/test ; \
	$(PHPUNIT) $(PHPUNITPRE)/$(ALLTESTS).xml $(ALLTESTS) ; \
	cd ../.. ;

checkclient:
	$(HG) checkout $(BRANCH) # TODO: add flex unit code here

checkclienttest:
	$(HG) checkout $(TESTBRANCH) # TODO: add flex unit code here

graph: pull  hudsongraph

hudsongraph: checkclient clientoutput
	cd client ; \  # TODO: this need to actually compile the sources
	$(Z) $(OUTPUT)/$(CLIENTNAME)/$(BUILDTAG).tar.gz *.swf *.html ; \
	cd .. ;

test: pull hudsontest

hudsontest: checkclienttest testclientoutput
	cd client ; \ # TODO: this needs to actually compile the sources
	$(Z) $(OUTPUT)/$(TESTCLIENTNAME)/$(BUILDTAG).tar.gz *.swf *.html ; \
	cd .. ;

api: pull hudsonapi

hudsonapi: check apioutput
	cd services ; \
	$(Z) $(OUTPUT)/$(APINAME)/$(BUILDTAG).tar.gz `find . -type f -regextype posix-egrep -regex ".*\.php" | grep -v test/* | grep -v config.php`; \
	cd .. ; 

testapi: pull hudsontestapi

hudsontestapi: checktest testapioutput
	cd services ; \
	$(Z) $(OUTPUT)/$(TESTAPINAME)/$(BUILDTAG).tar.gz `find . -type f -regextype posix-egrep -regex ".*\.php" | grep -v test/* | grep -v config.php`; \
	cd .. ;

output:
	test -d $(DEF_OUT) || mkdir $(DEF_OUT)
	test -d $(PHPUNITPRE) || mkdir $(PHPUNITPRE)
	test -d $(OUTPUT) || mkdir $(OUTPUT)

clientoutput: output
	test -d $(OUTPUT)/$(CLIENTNAME) || mkdir $(OUTPUT)/$(CLIENTNAME)

testclientoutput: output
	test -d $(OUTPUT)/$(TESTCLIENTNAME) || mkdir $(OUTPUT)/$(TESTCLIENTNAME)

apioutput: output
	test -d $(OUTPUT)/$(APINAME) || mkdir $(OUTPUT)/$(APINAME)

testapioutput: output
	test -d $(OUTPUT)/$(TESTAPINAME) || mkdir $(OUTPUT)/$(TESTAPINAME)

clean:
	rm -rf $(DEF_OUT)