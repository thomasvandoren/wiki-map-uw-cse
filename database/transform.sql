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

/* fix page table
Goes from 
page_id, page_namespace, page_title, page_is_redirect, page_len, page_restrictions, page_counter, page_is_new, page_random, page_touched, page_latest
to
page_id, page_title, page_is_redirect, page_len, page_is_ambiguous, page_title_soundex

If you are importing from a non-standard database, and have any extra columns, drop them, and if any of your column names are named slightly different, do a search and replace to fix that.
*/

# drop all columns besides page_id, page_namespace, page_title, page_is_redirect, page_len
ALTER TABLE page 
DROP COLUMN page_restrictions IF EXISTS,
DROP COLUMN page_counter IF EXISTS,
DROP COLUMN page_is_new IF EXISTS,
DROP COLUMN page_random IF EXISTS,
DROP COLUMN page_touched IF EXISTS,
DROP COLUMN page_latest IF EXISTS,
DROP COLUMN page_no_title_convert IF EXISTS,
DROP INDEX page_title,
DROP INDEX page_len;

# we only care about actual articles
DELETE FROM page 
WHERE page_namespace != 0;

# we no longer need namespace, and we are going to create soundexes to help correct typos
ALTER TABLE page
 CHARACTER SET latin1,
 MODIFY COLUMN page_title VARCHAR(255),
 DROP COLUMN page_namespace,
 ADD COLUMN page_is_ambiguous TINYINT(1) AFTER page_is_redirect,
 ADD COLUMN page_soundex VARCHAR(4) AFTER page_title;

# Populate the new columns
UPDATE page SET page_is_ambiguous=1 where page_title like '%(disam%';
UPDATE page SET page_title_soundex=LEFT(SOUNDEX(page_title),4);

# remove needless ambiguous obvious redirects
DELETE from page WHERE page_is_ambiguous=1 and page_is_redirect=1;

# create indexes
CREATE INDEX title_index on page(page_title);
CREATE INDEX soundex_index on page(page_soundex);

# fix pagelinks
/* Wikipedia stored the links as title names instead of page id's, and the pages were not enforced to be in the page table.
We convert this to 'from id', and 'to id'. Another database format would likely have this schema already, or be using the standard wikimedia schema for which we wrote this script.
*/

# this is optional because of the deletions later, but this should make things faster
DELETE FROM pagelinks
WHERE pl_namespace != 0;

# we need to end up with just a 'from' and a 'to' column
ALTER TABLE pagelinks 
DROP COLUMN pl_namespace,
DROP INDEX pl_namespace,
DROP INDEX pl_from,
ADD COLUMN pl_to INT(8) UNSIGNED;

UPDATE pagelinks SET pl_to=(SELECT page_id FROM page WHERE page_title = pl_title LIMIT 1);
DELETE FROM pagelinks WHERE pl_to IS NULL;
DELETE FROM pagelinks WHERE (SELECT page_id FROM page WHERE page_id = pl_from) is null;

ALTER TABLE pagelinks
DROP pl_title,
ADD FOREIGN KEY (pl_from) REFERENCES page (page_id) ON DELETE CASCADE ON UPDATE CASCADE,
ADD FOREIGN KEY (pl_to) REFERENCES page (page_id) ON DELETE CASCADE ON UPDATE CASCADE;