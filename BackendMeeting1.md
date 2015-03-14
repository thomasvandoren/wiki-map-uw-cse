# Backend Meeting 1 #
**2011-01-24**

## Server Notes ##

The server-side code will likely be broken into three pieces:
  * Web site code - serving our few HTML pages
    * Index page to serve Flash application
    * About page
  * Services - actions to be used by the application
    * Autocomplete - return list of possible completions
    * Search - return list of possible results (for searches without exact matches?)
    * Graph - return list of connections to graph
  * Database wrapper - used to abstract away the database schema
    * Likely to just be a wrapper for MediaWiki schemas in a MySQL database for now, but lets us be more flexible in the future

  * Services should broadly include all data held in our application. We could call it an API <sup>Thomas Van Doren</sup>
    * One way to serve this data is through url endpoints to HTTP requests (i.e. `GET /api/search/the+query HTTP/1.1` returns the result(s) of searching for 'the query'; you can imagine the possibilities...) thus separating the organization and relevance of the data -- this would be a ReSTful implementation...
      * this layout does not necessarily use directories to achieve the 'structure'
      * it can be achieved with one script and using the apache rewrite engine (/api/search/the+query could map to /api/index.php?type=search&q=the+query)
    * I think it is important that all requests return the same format of data (be it JSON, XML, or something else)
    * The services should be their own module (many clients can theoretically use HTTP requests to access this data)

### Server Questions ###
  * What format should our results be?
    * I would suggest JSON or XML to start with since they are widely accepted and easily interpreted by clients/servers <sup>Thomas Van Doren</sup>
  * Can Flash applications can make HTTP requests?
    * Yes, they can POST, GET, PUT, DELETE (although GET is the only semantically relevant one for our application) <sup>Thomas Van Doren</sup>

### Server Goals ###
  * Refresh PHP knowledge
    * Connect to a database
    * Use param string arguments
      * Awesome! -- this can later be mapped to a cleaner url scheme, once we have a clearer design <sup>Thomas Van Doren</sup>

### Server Resources ###
  * [CSE190M](http://www.cs.washington.edu/education/courses/cse190m/10su/lectures.shtml)
    * [PHP -> DB example](http://www.cs.washington.edu/education/courses/cse190m/10su/lectures/08-09/~programs/query.php)
    * [PHP output formats](http://www.cs.washington.edu/education/courses/cse190m/10su/lectures/slides/lectureXX-web-services.shtml)

## Database Notes ##
  * Went over the database dumps from Wikipedia
  * We will only need a subset of the tables from the dumps:
    * page - page id's with titles, other basic information
    * pagelinks - page -> page links
    * abstract - page abstracts, OR
    * text - full text of pages
  * Links table doesn't have any annotations (i.e. doesn't note which links are in the "See Also" section). Possible solutions:
    * Switch to just using mutual links to determine relevancy
    * Parse full page text to find "See Also" links
  * Speaking of mutual links:
    * Searching the pagelinks table by destination title is easy, but
    * Creating a reverse-link table is also easy, if we need the performance boost. -- w00t!
  * Redirect pages usually only have one link (the page that actually gets displayed), but a small few have many links
    * Should we silently display information for the linked-to page
    * What should we do for the ambiguous redirected pages
      * This problem is easier to solve if we have the full text of the page

### Database Questions ###
  * How much space do we have for the database? -- [Catalyst Post](http://goo.gl/Tx1rK) We probably shouldn't use more than 5gb
    * We should look into S3, or other alternatives if it is going to require much more than 5gb
  * How much processing time can we use on the server (for loading the database)?
    * If size becomes an issue, are we ok with using dumps from a smaller wiki (wikibooks, wikiquotes, wikiversity, ...)?
      * For me personally, the max response time (user takes an action on the ui, all the way to ui displaying result from server) is 15-20seconds (ideally 7-10sec) -- which means the data apis probably get half that, 7-10 seconds to actually "work" (take away ui operation/network transfer/etc) <sup>Thomas Van Doren</sup>
      * We will have to look into database [partitioning/sharding](http://dev.mysql.com/tech-resources/articles/performance-partitioning.html) if we hope to serve the big boy wikipedia db
      * Using good SQL development practices will also be important for performance

### Database Goals ###
  * Get group database set-up
  * Figure out exactly what tables we want from the dumps
  * Figure out if we will have issues with database size/loading time

We should look into database performance optimization (not necessarily this week), but in the future. Partitioning/sharding, SQL optimization are two that come to mind. <sup>Thomas Van Doren</sup>

### Database Resources ###
  * [Database schema, including diagram](http://www.mediawiki.org/wiki/Manual:Database_layout)