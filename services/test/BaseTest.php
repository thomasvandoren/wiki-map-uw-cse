<?php
/*
  WikiGraph
  Copyright (c) 2011

  Author: Rob McClure <mgracecubs@gmail.com>

  Base class for our test cases
  Takes care of setting up the connection to
  the database
*/
require_once('PHPUnit/Framework.php');
require_once('../util.php');
require_once('config.php');

class BaseTest extends PHPUnit_Framework_TestCase
{
  protected $db;

  protected function setUp() {
    global $DB_HOST, $DB_USER, $DB_PASS, $DB_NAME;
    $this->db = new GraphDB($DB_HOST, $DB_USER, $DB_PASS, $DB_NAME);
  }

  protected function tearDown() {
    $this->db->close();
  }
}