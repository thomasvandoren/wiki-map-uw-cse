# Customer Meeting #2 #
#### Wednesday, January 19, 2011 ####

We went over the basic overview of our project, along with some of our planned and stretch features. The main feedback is given below.


## Comments ##
  * The scope of the project may be a little small, given the time and the number of people we have. We should make sure that we have stretch features that we can implement if we have extra time.
    * We already have some stretch features, so this should be ok.
  * Being able to save and share maps is important.
    * We already discussed doing this, and it is currently listed as a release feature
    * Having Google-esque links where all of the information is included in the link seems to be the best way to do this
  * Displaying two nodes and common connections sounds cool, but it may not be as useful as we think
    * This is already a stretch feature
    * Further communication with our customers should reveal how useful this feature would actually be

## Suggestions ##
  * We should make it clear what browsers we will support.
    * Discussion can be found at [BrowserSupport](BrowserSupport.md)
  * We should explore different graphing libraries
    * As mentioned before, a possible combination is [Graphviz](http://www.graphviz.org/) server-side and [Canviz](http://www.canviz.org/) on the client-side. We should still explore alternatives
  * We should abstract the communication between the server and the database, so that we could replace the Wikipedia database with something else and still use our application
  * Simplicity is key