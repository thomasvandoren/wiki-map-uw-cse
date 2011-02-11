# Enter MySQL details here
USER = username
PASS = password
HOST = localhost
PORT = 3306
DB  = database

# Possible SRC's:
# enwikibooks
# enwiki
SRC = enwikibooks

LINK = http://dumps.wikimedia.org/$(SRC)/latest/$(SRC)-latest-

SQLFILES = page.sql pagelinks.sql

MYSQL = mysql --host=$(HOST) --port=$(PORT) --user=$(USER) --password=$(PASS) --database=$(DB)

all: config.php page pagelinks transform abstract

config.php :
	echo "<?php\n\
    \$$user = \"$(USER)\";\n\
    \$$pass = \"$(PASS)\";\n\
    \$$host = \"$(HOST)\";\n\
    \$$port = \"$(PORT)\";\n\
    \$$db = \"$(DB)\";\n\
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
	wget $(LINK)abstract.xml -O abstract.xml
	php parse_abstracts.php

clean:
	rm -f config.php page.sql pagelinks.sql abstract.xml abstract.sql

