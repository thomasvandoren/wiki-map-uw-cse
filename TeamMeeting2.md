# Team Meeting 2 #

**2011-01-22** The second team meeting.

## Topics Discussed ##

  * Weekly status report - completed
  * Roles and Teams
  * Architecture
  * Goals for this week

## Status Report ##

It's in Google Docs http://goo.gl/GyKPU

## Roles and Teams ##

WikiGraph will be developed with two teams and a manager (possibly two).

  * Manager - Thomas
    * Responsible for scheduling/administrative task
    * Responsible for build system, scm, and general development tool setup
    * Available to develop on either team as needed
  * Frontend Team - Michael, Austin, Khanh
    * Responsible for UI
    * Specific environment and implementation under investigation (likely open source flash)
  * Backend/DB Team - Jeremy, Rob, Mark
    * Responsible for database administration and server application
    * MySQL used for db admin
    * PHP application to access/edit data

## Goals for Week of Jan-24 ##

  * Frontend Team - Get a small flash application working
    * this goal is mainly to prove (or disprove) that flash is a reasonable implementation of the ui
    * requires getting flash development environment setup
    * requires learning very basics of flash development
  * Backend/DB Team - Setup database
    * get a small database up and running
    * (re)introduction to php -- make sure everyone is up-to-speed on the php language
  * Manager - Support/Tools/Resources
    * Setup group owned database (currently each account has separate privileges) - should only require an email to support@cs
    * Setup consistent repository layout
    * Look into build service (Hudson with ant)
    * Look into ReviewBoard for doing code reviews (potentially easy/better than built in email system that Google Code uses)