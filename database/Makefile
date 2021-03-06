# Enter MySQL details here
DBHOST = 
DBUSER = 
DBPASS = 
DBPORT = 
DBNAME  = 
LINKURL = 

DBHOSTSTR = $(DBHOST)
ifneq ($(strip $(DBPORT)),)
DBHOSTSTR = $(DBHOST):$(DBPORT)
endif

# Possible SRC's:
# enwikibooks
# enwiki
SRC = enwiki

# Comment out the next line if the dump only has one abstract.xml file
MULTIABSTRACT = true

BASE_LINK = http://dumps.wikimedia.org/$(SRC)/latest/
LINK = $(BASE_LINK)$(SRC)-latest-
SQLFILES = page.sql pagelinks.sql

# Generates a config file to be used later when adding values to the db.
ifeq ($(strip $(CONFIGLOC)),)
CONFIGLOC = config.php
endif

MYSQL = mysql --host=$(DBHOST) --port=$(DBPORT) --user=$(DBUSER) --password=$(DBPASS) --database=$(DBNAME)

# Some machines need echo -e
ECHO = echo

all: config.php page pagelinks transform pagelinks_cache abstract

config.php : testconfig
	$(ECHO) "<?php" > $(CONFIGLOC).tmp
	$(ECHO) "/*" >> $(CONFIGLOC).tmp
	$(ECHO) "    WikiGraph" >> $(CONFIGLOC).tmp
	$(ECHO) "    Copyright (c) 2011" >> $(CONFIGLOC).tmp
	$(ECHO) "    " >> $(CONFIGLOC).tmp
	$(ECHO) "    *** This file was generated by the WikiGraph build service. ***" >> $(CONFIGLOC).tmp
	$(ECHO) "    " >> $(CONFIGLOC).tmp
	$(ECHO) "    These values must represent the system that WikiGraph is run on." >> $(CONFIGLOC).tmp
	$(ECHO) "*/" >> $(CONFIGLOC).tmp
	$(ECHO) " " >> $(CONFIGLOC).tmp
	$(ECHO) $(subst !,"$(DBHOSTSTR)","\$$DB_HOST='!';") >> $(CONFIGLOC).tmp
	$(ECHO) $(subst !,$(DBUSER),"\$$DB_USER='!';") >> $(CONFIGLOC).tmp
	$(ECHO) $(subst !,$(DBPASS),"\$$DB_PASS='!';") >> $(CONFIGLOC).tmp
	$(ECHO) $(subst !,$(DBNAME),"\$$DB_NAME='!';") >> $(CONFIGLOC).tmp
	$(ECHO) "    " >> $(CONFIGLOC).tmp
	$(ECHO) $(subst !,$(LINKURL),"\$$LINK_URL='!';") >> $(CONFIGLOC).tmp
	$(ECHO) "?>" >> $(CONFIGLOC).tmp
	cp $(CONFIGLOC).tmp $(CONFIGLOC)
	rm $(CONFIGLOC).tmp

testconfig:
	test -f $(CONFIGLOC) || touch $(CONFIGLOC)

page: page.sql
	$(MYSQL) < page.sql

pagelinks: pagelinks.sql
	$(MYSQL) < pagelinks.sql

transform:
	$(MYSQL) < transform.sql

pagelinks_cache: pagelinks_cache.sql
	$(MYSQL) < pagelinks_cache.sql

abstract: abstract.sql
	$(MYSQL) < abstract.sql

$(SQLFILES):
	wget $(LINK)$@.gz -O $@.gz
	gzip -d $@.gz

pagelinks_cache.sql:
	php cache_links.php

abstract.sql: config.php 
ifdef MULTIABSTRACT
	wget -qO- http://dumps.wikimedia.org/enwiki/latest/ | grep -o "abstract[0-9]\{1,2\}\.xml" | uniq | xargs php parse_abstracts.php "$(BASE_LINK)"
else
	php parse_abstracts.php "$(BASE_LINK)" "$(SRC)-latest-abstract.xml"
endif

clean:
	rm -f config.php page.sql pagelinks.sql abstract.xml abstract*.sql
