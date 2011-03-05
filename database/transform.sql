/*
WikiGraph
Copyright (c) 2011

Author: Mark Jordan <jjoshua2@gmail.com>

Transform Script
Takes the page and pagelinks tables from a MediaWiki database
and removes unneeded columns.
Also, changes pagelinks from id -> namespace:title
to id -> id
*/

# fix page table
ALTER TABLE page 
DROP COLUMN page_restrictions,
DROP COLUMN page_counter,
DROP COLUMN page_is_new,
DROP COLUMN page_random,
DROP COLUMN page_touched,
DROP COLUMN page_latest,
DROP COLUMN page_no_title_convert,
DROP INDEX page_len;
 
DELETE FROM page 
WHERE page_namespace != 0;
 
ALTER TABLE page DROP COLUMN page_namespace;
# could change ints to mediumint for space saving

# fix pagelinks
DELETE FROM pagelinks
WHERE pl_namespace != 0;

ALTER TABLe pagelinks 
DROP COLUMN pl_namespace,
DROP INDEX pl_namespace,
DROP INDEX pl_from,
ADD COLUMN pl_to INT(8) DEFAULT NULL;

UPDATE pagelinks SET pl_to=(SELECT page_id FROM page WHERE page_title = pl_title LIMIT 1);
DELETE FROM pagelinks WHERE pl_to IS NULL;
DELETE FROM pagelinks WHERe (SELECT page_id FROM page WHERE page_id = pl_from) is null;

ALTER TABLE pagelinks
DROP pl_title,
ADD FOREIGN KEY (pl_from) REFERENCES page (page_id) ON DELETE CASCADE ON UPDATE CASCADE,
CHANGE pl_to pl_to INT( 8 ) UNSIGNED NOT NULL,
ADD FOREIGN KEY (pl_to) REFERENCES page (page_id) ON DELETE CASCADE ON UPDATE CASCADE;