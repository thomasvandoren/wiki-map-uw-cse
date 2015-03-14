# Tools (with Documentation) #

These are the tools we are considering using for this project. Please include links to documentation and examples when available.

### Table of Contents ###

  * **WikiGraph Tools**
    * [Visio](ToolsAndDocs#Visio.md)
    * [PHP](ToolsAndDocs#PHP.md)
    * [PHPUnit](ToolsAndDocs#PHPUnit.md)
    * [AWS Relational Database](ToolsAndDocs#AWS_Relational_Database.md)
    * [MySQL](ToolsAndDocs#MySQL.md)
    * [MySQL Workbench](ToolsAndDocs#MySQL_Workbench.md)
    * [WampServer](ToolsAndDocs#WampServer.md)
    * [FlashDevelop](ToolsAndDocs#FlashDevelop.md)
    * [Flex](ToolsAndDocs#Flex.md)
    * [FlexUnit](ToolsAndDocs#FlexUnit.md)
    * [Mercurial](ToolsAndDocs#Mercurial.md)
    * [CSE Resources](ToolsAndDocs#CSE_Resources.md)
    * [Hudson CI](ToolsAndDocs#Hudson_CI.md)
    * [ReviewBoard](ToolsAndDocs#ReviewBoard.md)
  * **Deprecated Tools**
    * [Flex Libraries](ToolsAndDocs#Flex_Libraries.md)
    * [GraphViz](ToolsAndDocs#GraphViz.md)
    * [Canviz](ToolsAndDocs#Canviz.md)
    * [Prototype](ToolsAndDocs#Prototype.md)
    * [HTML5](ToolsAndDocs#HTML5.md)

### Visio ###

  * [Visio](http://office.microsoft.com/en-us/visio/)
    * [Free Visio](http://www.cs.washington.edu/lab/sw/MSDNAA/ms-sw.html) - for UW CSE Students

### PHP ###

  * [PHP](http://www.php.net/) - server side scripting application; cubist has v5.3.5 (zend 2.3.0)
    * [Documentation](http://www.php.net/manual/en/) - quite nice and fairly thorough
    * [Tutorial](http://www.php.net/manual/en/tutorial.php) - might help you get started if you have not used PHP before
    * [Lecture slides](http://www.cs.washington.edu/education/courses/cse190m/10su/lectures.shtml) - from Marty Stepp's web programming class; the php labs would be pretty good tutorials too

### PHPUnit ###

  * [PHPUnit](http://www.phpunit.de/)
    * [3.4 Documentation](http://www.phpunit.de/manual/3.4/en/index.html)
    * PHPUnit 3.4 is installed on cubist.

### AWS Relational Database ###

  * [Amazon Web Services Relation Database Service](http://aws.amazon.com/rds/)
    * [Documentation](http://aws.amazon.com/documentation/rds/)

### MySQL ###

  * [MySQL](http://www.mysql.com/) - for the massive db
    * [5.1 Documentation](http://dev.mysql.com/doc/refman/5.1/en/index.html) - 5.1.52 is on cubist
    * [5.5 Documentation](http://dev.mysql.com/doc/refman/5.5/en/index.html) - 5.5.8 is on AWS RDS

### MySQL Workbench ###

  * [MySQL Workbench 5.2](http://dev.mysql.com/downloads/workbench/5.2.html) - GUI for db design/model, SQL dev
    * [Documentation](http://dev.mysql.com/doc/workbench/en/index.html)
    * To gain access to a cubist database:
      1. Select Database -> Manage Connections...
      1. Select New and fill out the form:
        * Connection Name: Cubist (or whatever)
        * Connection Method: Standard TCP/IP over SSH
        * SSH Hostname: cubist.cs.washington.edu:22
        * SSH Username: your cs username (like vandot)
        * MySQL Hostname: cubist.cs.washington.edu
        * MySQL Server Port: 3306
        * Username: your mysql username (probably same as cs username)
        * (Optional) Default Schema: the database name that you want to _use_ by default
      1. Test Connection
        * You will be asked for your SSH password to cubist first (this is your normal cs Kerberos password)
        * Then you will have to enter your mysql password (it was assigned at the beginning of the quarter)
      1. Close
      1. Back in the workspace, you should see Cubist in the list of connections - double click to open it
      1. Now you can enter SQL queries and conduct administrative tasks in a clean gui (w00t!)
    * To gain access to AWS RDS instance:
      1. Login to [AWS Management Console](http://console.aws.amazon.com/rds/home)
      1. Select RDS tab
      1. Select DB Instances
      1. Select the instance that you would like to connect (notice that the description box at the box contains information about the particular instance)
      1. Open MySQL Workbench
      1. Select Database -> Manage Connections...
      1. Select New and fill out the form:
        * Connection Name: WikiGraph RDS (or whatever)
        * Connection Method: Standard TCP/IP over SSH
        * SSH Hostname: cubist.cs.washington.edu:22
        * SSH Username: your cs username (like vandot)
        * MySQL Hostname: (copy the 'Endpoint' from the AWS RDS console)
        * MySQL Server Port: 3306
        * Username: (was sent in an e-mail -- contact Thomas if you need the credentials)
        * Password: (was sent in an e-mail -- contact Thomas if you need the credentials)
        * (Optional) Default Schema: wikigraph
      1. Test Connection
        * You will be asked for your SSH password to cubist first (this is your normal cs Kerberos password)
        * Then you will have to enter your mysql password (it was assigned at the beginning of the quarter)
      1. Close
      1. Back in the workspace, you should see 'WikiGraph RDS' in the list of connections - double click to open it
      1. Now you can enter SQL queries and conduct administrative tasks in a clean gui (w00t!)

### WampServer ###

  * [WampServer](http://www.wampserver.com/en/) - Run Apache/MySQL/PHP on your Windows box
    1. Download the latest WampServer [Download](http://www.wampserver.com/en/download.php)
    1. Remove any other versions of apache/php from your computer, before installing Wamp.
    1. Install Wamp; use defaults.
    1. Download MySQL 5.1.41 if you are using the 32bit version (from [Wamp mysql addons](http://www.wampserver.com/en/addons_mysql.php)) - cubist has 5.1.52 installed, so 5.5.8 is not ideal to test with.
    1. Install addon(s) with defaults and run WampServer.
    1. Once open, click on the icon in the taskbar tray, and enable the versions of the addons by going to APP > Version > v
    1. click on taskbay tray icon, then start all services (if you run IIS, you will have to stop your IIS services before this will work)
    1. direct your browser to http://localhost/ to test that all are running correctly -- you should see the WampServer configuration page
    1. "there's no place like 127.0.0.1"

### FlashDevelop ###

  * [FlashDevelop](http://www.flashdevelop.org/wikidocs/index.php?title=Main_Page) - Michael found this awesome IDE which supports AS2, **AS3**, flex3, **flex4**, and some others
    * [Download FlashDevelop 3.3.2 RTM](http://www.flashdevelop.org/community/viewtopic.php?f=11&t=7607)
    * Install that worked for me:
      1. java 1.6.0\_23 installed - there was some mention of having the 32bit version of java installed in the FlashDevelop docs, but the 64bit hotspot server vm seems to work on my win7 box...
      1. Download and install ActiveX (for IE) Debug Flash Player Plugin
      1. Download and install FlashDevelop (it will download and install flex 4 automatically)
  * [Adobe Flash Player Debugger](http://www.adobe.com/support/flashplayer/downloads.html) - FlashDevelop requires the ActiveX (for IE) Debug Flash Player
  * [Adobe Flash Player Debugger](http://www.adobe.com/support/flashplayer/downloads.html) - You probably want the Flash Player Project Content Debugger, too.

### Flex ###

  * [Flex SDK](http://opensource.adobe.com/wiki/display/flexsdk/Flex+SDK) - Adobe's free open source flash compiler and framework
    * [Downloads](http://opensource.adobe.com/wiki/display/flexsdk/Downloads) - we are using Flex 4.1.0
    * [Intro to Flex](http://learn.adobe.com/wiki/display/Flex/Get+oriented+to+Flex) - useful docs regarding Flex development
    * [Flex and ActionScript Development Tips](http://flexdevtips.blogspot.com/)
    * [Comparison of Adobe Flex charts](http://en.wikipedia.org/wiki/Comparison_of_Adobe_Flex_charts) - this page is a gold mine, for us

### FlexUnit ###

  * [FlexUnit](http://flexunit.org/)
    * [Documentation](http://docs.flexunit.org/index.php?title=Main_Page)

### Mercurial ###

  * [Mercurial](http://mercurial.selenic.com/)
    * [Downloads](http://mercurial.selenic.com/downloads/) - TortoiseHG has a windows gui **and** the binaries for Mercurial
    * On windows, make sure you add c:\where\you\installed\TortoiseHG\ to your path if you want to use hg at the command line

### CSE Resources ###

  * [CSE Web Tools and Services](http://www.cs.washington.edu/lab/www/index.html) - A useful reference for things happening on `*`.cs.washington.edu
  * [Cubist Notes](http://cubist.cs.washington.edu/doc/cubist_instructor.html) - cubist specific instructions

### Hudson CI ###

  * [Hudson](http://hudson-ci.org/) - A continuous build integration service
    * [WikiGraph Build](http://wikigraph.cs.washington.edu/build)

### ReviewBoard ###

  * [ReviewBoard](http://reviewboard.org) - Code review tool
    * [WikiGraph ReviewBoard](http://wikigraph.cs.washington.edu/reviews/)

## Deprecated ##

### Flex Libraries ###

  * [Flare](http://flare.prefuse.org/) - ActionScript library for building graphs with Flex
    * [Demo](http://flare.prefuse.org/demo) - pick Layouts -> [Circle|Radial|Force]
    * [Tutorial](http://flare.prefuse.org/tutorial) - Very extensive tutorial of how to get Flare working with lots of examples
  * [Birdeye](http://code.google.com/p/birdeye/) - Another AS lib for building graphs (not as well documented)
    * [Demo](http://birdeye.googlecode.com/svn/branches/ng/examples/demo/BirdEyeExplorer.html) - Pick Graphs
    * [Discussion Group](http://groups.google.com/group/flexvizgraphlib/) - The closest thing I could find to documentation

### GraphViz ###

  * [GraphViz](http://graphviz.org/) -- this seems like the best way to format our maps
    * [Documentation](http://www.graphviz.org/Documentation.php)
    * [Resources](http://www.graphviz.org/Resources.php) - support for various language implementation (Python, PHP, Ruby, Javascript/HTML5)

### Canviz ###

  * [Canviz](http://code.google.com/p/canviz/) -- this seems like the best 'out of the box' option for rendering our graphs in a browser. The example below uses span elements (which we could easily manipulate via CSS.
    * [How To](http://code.google.com/p/canviz/wiki/HowToUse)
    * [Supported Browsers](http://code.google.com/p/canviz/wiki/Browsers)
    * **[Example](http://www.ryandesign.com/canviz/)** - this looks really clean (and clearly supports zooming w00t!
    * This would be a risky, albeit rewarding tool to use. It does not have much support or documentation. It is unclear how _easy_ it will be to style and extend the dom elements in the graph.

### Prototype ###

  * [Prototype](http://www.prototypejs.org/) - I believe this is a dependency for Canviz <a href='Hidden comment: Opinion of thomas.vandoren@gmail.com'></a>
    * [Documentation](http://api.prototypejs.org/)

### HTML5 ###

  * [HTML5 Specification](http://dev.w3.org/html5/spec/Overview.html)