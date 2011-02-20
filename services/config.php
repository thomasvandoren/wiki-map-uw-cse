<?php
/*
WikiGraph
Copyright (c) 2011

Author: Rob McClure <mgracecubs@gmail.com>

Database configuration file
Change these values when you deploy the application
*/
$DB_HOST = "fakehost";
$DB_USER = "username";
$DB_PASS = "passphrase";
$DB_NAME = "somename";

$LINK_URL = "http://en.wikibooks.com/wiki/";

if (stripos($dbname, "test") === FALSE)
{
  $LINK_URL = "http://en.wikipedia.org/wiki/";
}

?>