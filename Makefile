#
# WikiGraph
# Copyright (c) 2011
#
# Author: Thomas Van Doren <thomas.vandoren@gmail.com>
#
# Build the various WikiGraph targets.
#

#
# CONFIG is an optional config file to copy into the tarball 
#

CONFIG = 

#
# If a config is not available, the individual parameter may be provided
# for the database connection.
#

DBHOST = 
DBUSER = 
DBPASS = 
DBNAME = 
LINKURL = 

#
# if there is neither a CONFIG or a DBHOST, set fake values
#

ifeq ($(strip $(DBHOST)),)
DBHOST = localhost
DBUSER = root
DBPASS = 
DBNAME = wikigraph
LINKURL = http://en.wikipedia.org/wiki/
endif

#
# The root (default) build directory. All generated files will end up in here. The package will 
# be in OUTPUT, however.
#

DEF_OUT = $(CURDIR)/build

#
# The executables needed to make things
#

ECHO = echo
HG = hg
MXMLC = mxmlc
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

#
# These define where the output for logs and SWFs go.
#

PHPUNITPRE = $(DEF_OUT)/phpunit-log
ANT_OUT = $(DEF_OUT)
FLEXUNITPRE = $(DEF_OUT)/flexunit-log

#
# The name of the PHPUnit tests for execute.
#

ALLTESTS = AllTests

#
# It is assumed that this script is being executed the root of the repository.
#

REPO = $(CURDIR)

#
# hg clone settings
#

REPOURL = https://wiki-map-uw-cse.googlecode.com/hg/
CLONENAME = WikiGraph-Build-Clone

# 
# Available hg options. The test targets use dev while the normal targets use release.
#

TESTBRANCH = dev
BRANCH = release

#
# Where the config.php is generated (or copied) to.
#

CONFIGLOC = $(OUTPUT)/config.php

#
# The SWF output dir, $OUTPUT/$FLEXOUT
#

FLEXOUT = bin

#
# The names of the package output directories.
#

APINAME = WikiGraph-Services
TESTAPINAME = WikiGraph-Test-Services

CLIENTNAME = WikiGraph-FlashClient
TESTCLIENTNAME = WikiGraph-Test-FlashClient

#
# The configuration for outputting the SWF and HTML template
#

SWFDIR = $(OUTPUT)/$(FLEXOUT)
SWFNAME = WikiGraph.swf
SWFTMPDIR = $(CURDIR)/client/FlexClient/DrawGraph/template
SWFTMPNAME = index.html

#
# Configuration files for the Flex compiler.
#

MXMLCONFIG = $(CURDIR)/client/FlexClient/DrawGraph/config/DrawGraphConfig.xml
MXMLTESTCONFIG = $(CURDIR)/client/FlexClient/DrawGraph/config/TestDrawGraphConfig.xml

# 
# Flex compiler settings and options.
#

MXMLSRC = $(CURDIR)/client/FlexClient/DrawGraph/src/Main.mxml
MXMLCOPTS = -load-config+=$(MXMLCONFIG) -output $(SWFDIR)/$(SWFNAME) -- $(MXMLSRC)
MXMLCTESTOPTS = -load-config+=$(MXMLTESTCONFIG) -output $(SWFDIR)/$(SWFNAME) -- $(MXMLSRC)

#
# The default is to build everything on the release branch.
#

all: graph api

#
# build will build everything on the dev branch.
#

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

checkapi: output config
	cd $(REPO)/services/test ; \
	$(PHPUNIT) $(PHPUNITPRE)/$(ALLTESTS).xml $(ALLTESTS) ; \
	cd ../.. ;

#
# checkclient runs the client unit tests
# The config dependancy does not do anything for the flash client at this time.
#

checkclient: output config
	ant -DANT_OUT=$(ANT_OUT) test

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
# hudsontestapi does the same thing at hudsonapi, with a different output
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
# config puts a config.php in the services/test directory for running unit test
# and then places it in the tar ball during packaging. If a config file was 
# provided, it will be ocpied. Otherwise the mysql connection parameters are
# used to generate a config.php.
#

config: createconfig
	cp $(CONFIGLOC) services/config.php
	cp $(CONFIGLOC) services/test/config.php

createconfig: output
ifeq ($(strip $(CONFIG)),)
	$(ECHO) "<?php" > $(CONFIGLOC).tmp
	$(ECHO) "/*" >> $(CONFIGLOC).tmp
	$(ECHO) "    WikiGraph" >> $(CONFIGLOC).tmp
	$(ECHO) "    Copyright (c) 2011" >> $(CONFIGLOC).tmp
	$(ECHO) "    " >> $(CONFIGLOC).tmp
	$(ECHO) "    *** This file was generated by the WikiGraph Services API build." >> $(CONFIGLOC).tmp
	$(ECHO) "    " >> $(CONFIGLOC).tmp
	$(ECHO) "    These values must represent the system that WikiGraph is run on." >> $(CONFIGLOC).tmp
	$(ECHO) "    */" >> $(CONFIGLOC).tmp
	$(ECHO) "    " >> $(CONFIGLOC).tmp
	$(ECHO) $(subst !,$(DBHOST),"\$$DB_HOST='!';") >> $(CONFIGLOC).tmp
	$(ECHO) $(subst !,$(DBUSER),"\$$DB_USER='!';") >> $(CONFIGLOC).tmp
	$(ECHO) $(subst !,$(DBPASS),"\$$DB_PASS='!';") >> $(CONFIGLOC).tmp
	$(ECHO) $(subst !,$(DBNAME),"\$$DB_NAME='!';") >> $(CONFIGLOC).tmp
	$(ECHO) "    " >> $(CONFIGLOC).tmp
	$(ECHO) $(subst !,$(LINKURL),"\$$LINK_URL='!';") >> $(CONFIGLOC).tmp
	$(ECHO) "?>" >> $(CONFIGLOC).tmp
	cp $(CONFIGLOC).tmp $(CONFIGLOC)
	rm $(CONFIGLOC).tmp
else
	cp $(CONFIG) $(CONFIGLOC)
endif

#
# Removes all of the generated build output. On a local build machine
# this includes the packages (OUTPUT = DEF_OUT). On Hudson this would
# just remove the logs.
#

clean:
	rm -rf $(DEF_OUT)