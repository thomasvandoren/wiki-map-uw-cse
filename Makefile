#
# WikiGraph
# Copyright (c) 2011
#
# Author: Thomas Van Doren <thomas.vandoren@gmail.com>
#
# Build the various WikiGraph targets.
#

DEF_OUT = $(CURDIR)/build

MXMLC = mxmlc
HG = hg
PHPUNIT = phpunit --log-junit
Z = tar -czvf

# This command produces all of the filenames that are a part of the services.
# It does not include the services/test directory or anything named config.php.

FINDPHPSERVICES = `find services/ -type f -regextype posix-egrep -regex ".+\.php" | sed sAservices\/AA | grep -v test/* | grep -v config.php`

# OUTPUT and BUILDTAG can be set from the command line.

OUTPUT =
BUILDTAG = 

ifeq ($(strip $(OUTPUT)),)
OUTPUT = $(DEF_OUT)/output
endif

ifeq ($(strip $(BUILDTAG)),)
BUILDTAG = unknown-WikiGraph-unknown
endif

PHPUNITPRE = $(DEF_OUT)/phpunit-log
ANT_OUT = $(DEF_OUT)
FLEXUNITPRE = $(DEF_OUT)/flexunit-log

REPO = $(CURDIR)

REPOURL = https://wiki-map-uw-cse.googlecode.com/hg/
CLONENAME = WikiGraph-Build-Clone

FLEXOUT = bin

APINAME = WikiGraph-Services
TESTAPINAME = WikiGraph-Test-Services

CLIENTNAME = WikiGraph-FlashClient
TESTCLIENTNAME = WikiGraph-Test-FlashClient

TESTBRANCH = dev
BRANCH = release

SWFDIR = $(OUTPUT)/$(FLEXOUT)
SWFNAME = WikiGraph.swf
SWFTMPDIR = $(CURDIR)/client/FlexClient/DrawGraph/template
SWFTMPNAME = index.html

MXMLCONFIG = $(CURDIR)/client/FlexClient/DrawGraph/config/DrawGraphConfig.xml
MXMLTESTCONFIG = $(CURDIR)/client/FlexClient/DrawGraph/config/TestDrawGraphConfig.xml

MXMLSRC = $(CURDIR)/client/FlexClient/DrawGraph/src/Main.mxml
MXMLCOPTS = -load-config+=$(MXMLCONFIG) -output $(SWFDIR)/$(SWFNAME) -- $(MXMLSRC)
MXMLCTESTOPTS = -load-config+=$(MXMLTESTCONFIG) -output $(SWFDIR)/$(SWFNAME) -- $(MXMLSRC)

ALLTESTS = AllTests

all: graph api

build: testapi test

#
# The following four targets are responsible for Mercurial (hg)
# operations.
#

clone:
	$(HG) clone $(REPOURL) $(CLONENAME)

pull:
	$(HG) pull
	$(HG) update

checkoutdev: pull
	$(HG) checkout $(TESTBRANCH)

checkoutrelease: pull
	$(HG) checkout $(BRANCH)

#
# check runs both the client and services unit tests.
#

check: checkapi checkclient

#
# checkapi runs the services unit tests
#

checkapi: output
	cd $(REPO)/services/test ; \
	$(PHPUNIT) $(PHPUNITPRE)/$(ALLTESTS).xml $(ALLTESTS) ; \
	cd ../.. ;

#
# checkclient runs the client unit tests
#

checkclient: output # TODO: add flex unit code here

#
# graph checks out a new repository on the release branch, runs the
# unit tests for the client, and then compiles and packages the client.
#

graph: checkoutrelease  hudsongraph

#
# hudsongraph runs the unit tests for the client, then compiles
# and packages the client.
#

hudsongraph: checkclient clientoutput
	$(MXMLC) $(MXMLCOPTS)
	$(Z) $(OUTPUT)/$(CLIENTNAME)/$(BUILDTAG).tar.gz -C $(SWFDIR) $(SWFNAME) -C $(SWFTMPDIR) $(SWFTMPNAME)

#
# test does the same thing as graph, but on the dev branch.
#

test: checkoutdev hudsontest

#
# hudsontest does the same thing as hudsongraph, with a different output
# directory for the package.
#

hudsontest: checkclient testclientoutput
	$(MXMLC) $(MXMLCTESTOPTS)
	$(Z) $(OUTPUT)/$(TESTCLIENTNAME)/$(BUILDTAG).tar.gz -C $(SWFDIR) $(SWFNAME) -C $(SWFTMPDIR) $(SWFTMPNAME)

#
# api checks out a new repository on the release branch, runs the
# unit tests for the services, and then compiles and packages the services.
#

api: checkoutrelease hudsonapi

#
# hudsongraph runs the unit tests for the services, then compiles
# and packages the services api.
#

hudsonapi: checkapi apioutput
	$(Z) $(OUTPUT)/$(APINAME)/$(BUILDTAG).tar.gz -C services $(FINDPHPSERVICES)

#
# testapi does the same thing as api, just on the dev branch.
#

testapi: checkoutdev hudsontestapi

#
# hudsontest does the same thing at hudsonapi, with a different output
# directory for the package.
#

hudsontestapi: checkapi testapioutput
	$(Z) $(OUTPUT)/$(TESTAPINAME)/$(BUILDTAG).tar.gz -C services $(FINDPHPSERVICES)

#
# These output targets create the necessary directories for
# the build output.
#

output:
	test -d $(DEF_OUT) || mkdir $(DEF_OUT)
	test -d $(FLEXUNITPRE) || mkdir $(FLEXUNITPRE)
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

flexoutput: output
	test -d $(OUTPUT)/$(FLEX) || mkdir $(OUTPUT)/$(FLEX)

#
# Removes all of the generated build output. On a local build machine
# this includes the packages (OUTPUT = DEF_OUT). On Hudson this would
# just remove the logs.
#

clean:
	rm -rf $(DEF_OUT)