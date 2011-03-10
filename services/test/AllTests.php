<?php
/*
  WikiGraph
  Copyright (c) 2011

  Author: Rob McClure <mgracecubs@gmail.com>

  Main suite for our unit tests
  Sets up the test database and runs
  all unit tests
*/

require_once('PHPUnit/Framework.php');
require_once('../util.php');
require_once('config.php');

require_once('UtilTest.php');
require_once('AbstractTest.php');
require_once('AutocompleteTest.php');
require_once('GraphTest.php');
require_once('SearchTest.php');

require_once('test_data.php');

$TESTING = true;

class AllTests extends PHPUnit_Framework_TestSuite 
{
  public static function suite() 
  {
    $suite =  new AllTests('UtilTest');
    $suite->addTestSuite('AbstractTest');
    $suite->addTestSuite('AutocompleteTest');
    $suite->addTestSuite('GraphTest');
    $suite->addTestSuite('SearchTest');
    return $suite;
  }
  
  /**
   * This initializes our test database
   * before any unit tests are run
   */
  protected function setUp() {
    global $DB_HOST, $DB_USER, $DB_PASS, $DB_NAME;
    global $pages, $links, $abstracts;
	
    $db = mysql_connect($DB_HOST, $DB_USER, $DB_PASS);
    mysql_select_db($DB_NAME);

    mysql_query("DROP TABLE IF EXISTS page, pagelinks, pagelinks_cache, abstract");
    // Init page table
    $q = "CREATE TABLE page ("
      .  "  page_id INT(8),"
      .  "  page_title VARCHAR(255),"
      .  "  page_is_redirect TINYINT(1),"
      .  "  page_is_ambiguous TINYINT(1),"
      .  "  page_len INT(8),"
      .  "  PRIMARY KEY (page_id),"
      .  "  UNIQUE KEY page_title (page_title))";
    mysql_query($q);

    foreach ($pages as $page) {
      $q = "INSERT INTO page VALUES(" . implode(",", $page) . ")";
      mysql_query($q);
    }
    mysql_query("ALTER TABLE page ADD page_title_soundex VARCHAR(4)");
    mysql_query("UPDATE page SET page_title_soundex=LEFT(SOUNDEX(page_title),4)");
    // Init pagelinks table
    $q = "CREATE TABLE pagelinks ("
      .  "  pl_from INT(8),"
      .  "  pl_to INT(8),"
      .  "  FOREIGN KEY (pl_from) REFERENCES page (page_id),"
      .  "  FOREIGN KEY (pl_to) REFERENCES page (page_id))";
    mysql_query($q);

    foreach ($links as $link) {
      $q = "INSERT INTO pagelinks VALUES(" . implode(",", $link) . ")";
      mysql_query($q);
    }

    // Init abstract table
    $q = "CREATE TABLE abstract ("
      .  "  abstract_id INT(8),"
      .  "  abstract_text TEXT,"
      .  "  FOREIGN KEY (abstract_id) REFERENCES page (page_id))";
    mysql_query($q);

    foreach ($abstracts as $abstract) {
      $q = "INSERT INTO abstract VALUES(" . implode(",", $abstract) . ")";
      mysql_query($q);
    }

    $q = "CREATE TABLE pagelinks_cache ("
      .  "  plc_from INT(8),"
      .  "  plc_to INT(8),"
      .  "  plc_out TINYINT(1),"
      .  "  plc_in TINYINT(1),"
      .  "  INDEX (plc_from)"
      .  ")";
    mysql_query($q);
    mysql_close($db);
  }
  
  /**
   * This tears down our test database
   * after all unit tests are run
   */
  protected function tearDown() {
    global $DB_HOST, $DB_USER, $DB_PASS, $DB_NAME;
    $db = mysql_connect($DB_HOST, $DB_USER, $DB_PASS);
    mysql_select_db($DB_NAME);

    mysql_query("DROP TABLE page, pagelinks, pagelinks_cache, abstract");
    mysql_close($db);
  }
}