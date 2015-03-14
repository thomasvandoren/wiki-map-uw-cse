Download dumps here:
http://download.wikimedia.org/enwiki/latest/

Information about the [database schema](http://www.mediawiki.org/wiki/Manual:Database_layout), including a [diagram](http://upload.wikimedia.org/wikipedia/commons/4/41/Mediawiki-database-schema.png).

Some info on each database:
http://www.google.com/url?sa=t&source=web&cd=17&ved=0CD0QFjAGOAo&url=http%3A%2F%2Fwww.comp.dit.ie%2Fdgordon%2FCourses%2FResearchMethods%2FKM-thesis2.pdf&rct=j&q=enwiki-latest-pagelinks.sql.gz%20format&ei=BgwyTeuCAY7SsAOBkry6BQ&usg=AFQjCNHKOOcGkhouyGBY94ycvf8b-BH6KA&cad=rja

Summarized:
  * pages-meta-current everything we might need ~12GB
  * abstract.xml abstractof each article ~3GB
  * page.sql.gz base per page data ~600MB
  * pagelinks.sql.gz page to page records ~3GB

Page table has many extra columns and indexes to drop. Just need first 3 columns, plus is\_redirect. Primary Index on number, unique on name.

Pagelinks we can convert title to foreign int key from page.

For both we only need pages in namespace 0 maybe?