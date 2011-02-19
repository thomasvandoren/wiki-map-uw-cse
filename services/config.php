<?php
/*
WikiGraph
Copyright (c) 2011

Author: Rob McClure <mgracecubs@gmail.com>

Database configuration file
Change these values when you deploy the application
*/
$host = "fakehost";
$user = "username";
$pass = "passphrase";
$dbname = "somename";

$LINK_URL = "http://en.wikibooks.com/wiki/";

if (stripos($dbname, "test") === FALSE)
{
  $LINK_URL = "http://en.wikipedia.org/wiki/";
}

?>