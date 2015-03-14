# ReviewBoard #

A tool for reviewing code. http://reviewboard.org/

Our installation may be accessed at: http://wikigraph.cs.washington.edu/reviews/

## Logging In ##

Your username is your first name (all lowercase). Your password was e-mailed to you. Please change it.

## Using ReviewBoard ##

### Opening and Completing a Review ###

You will receive an e-mail about a change in the source code. For front end dev, changes in the `/client/*` directory are automatically assigned to you. For backend devs, changes in the `/services/*` and `/database/*` directories are assigned to you.

You may open a review by:

  1. Going to: http://wikigraph.cs.washington.edu/reviews/
  1. Your reviews will be listed as 'Incoming Reviews'
  1. Select a review to open it

Or, you can open a review by clicking on the link in the e-mail that was sent to you.

Once you have the review open,

  * Select 'View Diff' (in the upper right corner) to see what has changed.
  * Once you have gotten a good look at it, select 'Review'
    * Write some constructive comments in the box
    * Select 'Ship It' if there are no problems
    * Make sure to select 'Publish Review' button (not 'Save') to finish the review process
  * It's that easy!

### Attaching a Bug to a Review ###

You might find a certain bug while reviewing someone's code, or be inspired to attach this change to a certain issue (e.g. it fixes a bug). To create the relationship,

  1. Find the bug id in Google Code. If you open the bug (or issue), the number towards the end of the url is the bug.
  1. Open the review in [ReviewBoard](http://wikigraph.cs.washington.edu/reviews/) that you would like to attach the bug to.
  1. Click the pencil next to bug
  1. Enter the number from the Google Code issue
  1. Click 'Ok' -- this opens the green draft box
  1. Click 'Publish Changes'

## Configuration ##

These are notes on how reviewboard is configured on cubist. **Developers need not pay attention to this section.**

ReviewBoard 1.0.9 comes packaged with Fedora 13, and is installed for everyone on cubist. It is in `/usr/lib/python2.6/site-packages/`. A local version of [mercurial-reviewboard](http://code.google.com/p/mercurial-reviewboard/), which is a mercurial extension that allows a user to submit postreviews to a reviewboard server using `hg postreview`, is installed at:
```
/projects/instr/cubist/11wi/cse403/WikiMap-M/sandbox/site-packages/mercurial-reviewboard
```

In order for ReviewBoard to create diffs, a clone just for ReviewBoard has been created at:
```
/projects/instr/cubist/11wi/cse403/WikiMap-M/proj/review/wiki-map-uw-cse
```

The `.hg/hgrc` in ReviewBoard's clone contains:
```
[paths]
default = https://wiki-map-uw-cse.googlecode.com/hg/

[ui]
username = ReviewBoard <wikigraph.services@cs.washington.edu>

[reviewboard]
repoid = 1

[hooks]
incoming = hg postreview -i 1 --apiver 1.0 -p $HG_NODE
```

A special `~/.hgrc` is setup for Thomas's (vandot) account, for the cronjob that is setup:
```
[extensions]
reviewboard = /projects/instr/cubist/11wi/cse403/WikiMap-M/sandbox/site-packages/mercurial-reviewboard

[reviewboard]
server = http://wikigraph.cs.washington.edu/reviews
```

Thomas has also installed a cron job to pull to the ReviewBoard clone every 5 minutes. If a change has occured, a review is submitted automatically by the hook in the ReviewBoard clone config. The cron job declaration:
```
*/5 * * * * cd /projects/instr/cubist/11wi/cse403/WikiMap-M/proj/review/wiki-map-uw-cse ; hg pull 1> /dev/null 2>> /projects/instr/cubist/11wi/cse403/WikiMap-M/logs/cron-error_log
```

Notes:

  1. stderr is piped into `~/WikiMap-M/logs/cron-error_log`
  1. A persistent 'certificate not verified warning' gets logged for every pull. It is harmless.