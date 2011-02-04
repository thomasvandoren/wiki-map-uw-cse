# user = rmcclur
# pass = d5RbiX3z
# dbname = rmcclur_test

# create backup tables
CREATE TABLE page_old LIKE rmcclur_test.page;
INSERT page_old SELECT * FROM rmcclur_test.page;

CREATE TABLE pagelinks_old LIKE rmcclur_test.pagelinks;
INSERT pagelinks_old SELECT * FROM rmcclur_test.pagelinks;

# fix page table
alter table page drop column page_restrictions,
 drop column page_counter,
 drop column page_is_new,
 drop column page_random,
 drop column page_touched,
 drop column page_latest,
 drop column page_no_title_convert,
 drop index page_len; # could drop column page_len as well
 
delete FROM page 
 where page_namespace != 0;
 
alter table page drop column page_namespace;
# could change ints to mediumint for space saving

# fix pagelinks
delete from pagelinks
 where pl_namespace != 0;

alter table pagelinks drop column pl_namespace,
 DROP INDEX pl_namespace,
 DROP INDEX pl_from,
 add column pl_to int(8) default null;

update pagelinks set pl_to=(select page_id from page where page_title = pl_title limit 1);
delete from pagelinks where pl_to is null;
delete from pagelinks where (select page_id from page where page_id = pl_from) is null;

ALTER TABLE `pagelinks` DROP `pl_title`
add foreign key (pl_from) references page(page_id) on delete cascade on update cascade,
CHANGE `pl_to` `pl_to` INT( 8 ) UNSIGNED NOT NULL,
add foreign key (pl_to) references page(page_id) on delete cascade on update cascade; #we may not really need to encorce pl_to as foreign key, since it makes table bigger and we aren't ever going to use update statements.