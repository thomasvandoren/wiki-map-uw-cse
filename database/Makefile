# Enter MySQL details here
USER = username
PASS = password
HOST = localhost
PORT = 3306
DB  = database

# Possible SRC's:
# enwikibooks
# enwiki
SRC = enwiki

# Comment out the next line if the dump only has one abstract.xml file
MULTIABSTRACT = true

LINK = http://dumps.wikimedia.org/$(SRC)/latest/$(SRC)-latest-
LINKESC = http:\/\/dumps.wikimedia.org\/$(SRC)\/latest\/$(SRC)-latest-
SQLFILES = page.sql pagelinks.sql

MYSQL = mysql --host=$(HOST) --port=$(PORT) --user=$(USER) --password=$(PASS) --database=$(DB)

# Some machines need echo -e
ECHO = echo

all: config.php page pagelinks transform abstract

config.php :
	$(ECHO) "<?php\n\
    \$$user = \"$(USER)\";\n\
    \$$pass = \"$(PASS)\";\n\
    \$$host = \"$(HOST)\";\n\
    \$$port = \"$(PORT)\";\n\
    \$$dbname = \"$(DB)\";\n\
?>" > config.php

page: page.sql
	$(MYSQL) < page.sql

pagelinks: pagelinks.sql
	$(MYSQL) < pagelinks.sql

transform:
	$(MYSQL) < transform.sql

abstract: abstract.sql
	$(MYSQL) < abstract.sql

$(SQLFILES):
	wget $(LINK)$@.gz -O $@.gz
	gzip -d $@.gz

abstract.sql: config.php 
ifdef MULTIABSTRACT
	wget -qO- http://dumps.wikimedia.org/enwiki/latest/ | grep -o "abstract[0-9]\{1,2\}\.xml" | uniq | sed 's/^\(.*\)$$/$(LINKESC)\1/g' > abstract_tmp
else
	echo $(LINK)abstract.xml > abstract_tmp
endif
	php parse_abstracts.php
	rm abstract_tmp

clean:
	rm -f config.php page.sql pagelinks.sql abstract.xml abstract.sql

