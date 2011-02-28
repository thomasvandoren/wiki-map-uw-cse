<?php
  /**
   * WikiGraph
   * Copyright (c) 2011
   *
   * Author: Thomas Van Doren <thomas.vandoren@gmail.com>
   *
   * This class contains all of the services unit tests at this time.
   * In the future they will likely be factored into other files and
   * classes.
   * 
   */

require_once('PHPUnit/Framework.php');
require_once("config.php");
require_once("../util.php");

$TESTING = true;

class AllTests extends PHPUnit_Framework_TestCase
{
  
  /**
   * @expectedException Exception
   *
   * Tests the error function
   * which should throw an exception
   */
  public function testError() {
    error(123, "456\n");
  }

  /**
   * Helper function for testing improper
   * creation of GraphDB objects
   */
  private function helper_testCreation($host, $user, $pass, $dbname) {
    try {
      $db = new GraphDB($host, $user, $pass, $dbname);
    } catch (Exception $e) {
      $error = true;
    }
    $this->assertTrue($error);
  }

  /**
   * Test for the creation of
   * GraphDB objects.
   *
   * Produces a valid GraphDB object
   * for use in other unit tests
   */
  public function testCreation() {
    global $DB_HOST, $DB_USER, $DB_PASS, $DB_NAME;

    $this->helper_testCreation('badhost', $DB_USER, $DB_PASS, $DB_NAME);
    $this->helper_testCreation($DB_HOST, 'baduser', $DB_PASS, $DB_NAME);
    $this->helper_testCreation($DB_HOST, $DB_USER, 'badpass', $DB_NAME);
    $this->helper_testCreation($DB_HOST, $DB_USER, $DB_PASS, 'baddbname');

    $db = new GraphDB($DB_HOST, $DB_USER, $DB_PASS, $DB_NAME);
    $this->assertNotNull($db);
    return $db;
  }

  /**
   * @depends testCreation
   *
   * Tests getting page info from the database
   * for certain ids
   * The tested pages are known to exist/not exist
   * for the current Wikipedia table dump
   */
/*
Temporarily commented out to unbreak build
while test db is set up
  public function testPageInfo($db) {
    // Get page info for invalid id
    $arr = $db->get_page_info(0);
    $this->assertEquals(count($arr), 0);

    // Get page info for valid id
    $arr = $db->get_page_info(10);
    $this->assertEquals(count($arr), 1);
    $row = $arr[0];
    // Check presence of fields
    $this->assertArrayHasKey('page_id', $row);
    $this->assertEquals($row['page_id'], "10");
    $this->assertArrayHasKey('page_title', $row);
    $this->assertArrayHasKey('page_len', $row);
    $this->assertArrayHasKey('page_is_redirect', $row);
    $this->assertArrayHasKey('page_is_ambiguous', $row);

    // Should be equivalent to above
    $arr2 = $db->get_page_info(array(10));
    $this->assertEquals(count($arr2), 1);
    $this->assertEquals($arr, $arr2);

    // Check page info for multiple ids
    $ids = array(10, 12, 13, 14, 15);
    $arr = $db->get_page_info($ids);
    $this->assertEquals(count($arr), 5);

    // Check presence of fields
    foreach ($arr as $row) {
      $this->assertArrayHasKey('page_id', $row);
      $this->assertContains($row['page_id'], $ids);
      $this->assertArrayHasKey('page_title', $row);
      $this->assertArrayHasKey('page_len', $row);
      $this->assertArrayHasKey('page_is_redirect', $row);
      $this->assertArrayHasKey('page_is_ambiguous', $row);
    }
  }
*/
  /**
   * @depends testCreation
   *
   * Tests the functionality of link queries
   */
  public function testLinks($db) {

    // Test query for a couple of different IDs
    $ids = array(0, 10, 12, 150);
    foreach ($ids as $id) {
      $results = $db->get_page_links($id);
      foreach ($results as $row) {
	// Test that the rows have the correct fields
	$this->assertArrayHasKey('pl_from', $row);
	$this->assertArrayHasKey('pl_to', $row);

	// Test that results are valid numbers
	$src = (int)($row['pl_from']);
	$this->assertNotEquals($src, 0);
	$dst = (int)($row['pl_to']);
	$this->assertNotEquals($dst, 0);

	// Test that the initial ID is either
	// the source or destination
	$this->assertTrue($id === $src || $id === $dst);
      }
    }
  }

  /**
   * @depends testCreation
   *
   * Tests the functionality of autocomplete
   * queries
   *
   * The searches used are known to exist/not exist
   * for the current Wikipedia table dump
   */
  public function testAutocomplete($db) {

    // Test some good autocomplete terms
    $strs = array("Cat", "Ruby", "Wiki");
    foreach ($strs as $str) {
      $arr = $db->get_autocomplete($str);
      $this->assertLessThanOrEqual(count($arr), 10);
      foreach ($arr as $row) {
	$this->assertArrayHasKey('page_title', $row);
	$this->assertRegExp("/^$str/", $row['page_title']);
      }
    }

    // Test some bad autocomplete terms
    $badstrs = array("Cat'; SELECT COUNT(*) FROM page;", "adkjfalkdjflakdf", "012345678910");
    foreach ($badstrs as $str) {
      $str = $db->escape($str);
      $arr = $db->get_autocomplete($str);
      $this->assertEquals(count($arr), 0);
    } 
  }

  /**
   * @depends testCreation
   *
   * Tests the functionality of search queries
   *
   * Currently, this is exactly the same as autocorrect
   */
  public function testSearch($db) {
    // Test some good autocomplete terms
    $strs = array("Cat", "Ruby", "Wiki");
    foreach ($strs as $str) {
      $arr = $db->get_search_results($str);
      $this->assertLessThanOrEqual(count($arr), 10);
      foreach ($arr as $row) {
	$this->assertArrayHasKey('page_title', $row);
	$this->assertRegExp("/^$str/", $row['page_title']);
      }
    }

    // Test some bad autocomplete terms
    $badstrs = array("Cat'; SELECT COUNT(*) FROM page;", "adkjfalkdjflakdf", "012345678910");
    foreach ($badstrs as $str) {
      $str = $db->escape($str);
      $arr = $db->get_search_results($str);
      $this->assertEquals(count($arr), 0);
    } 
  }

  /**
   * @depends testCreation
   *
   * Tests the functionality of abstract queries
   *
   * The searches used are known to exist/not exist
   * for the current Wikipedia table dump
   */
/*
Temporarily commented out to unbreak build
while test db is set up
  public function testAbstract($db) {
    // Test query for pages with abstracts
    $ids = array(12, 25, 2411, 2428, 20023, 20024);
    foreach ($ids as $id) {
      $results = $db->get_abstract($id);
      
      // Make sure we only get one result
      $this->assertEquals(count($results), 1);
      $row = $results[0];

      // Check that the fields are correct
      $this->assertArrayHasKey('abstract_id', $row);
      $this->assertArrayHasKey('abstract_text', $row);

      // Check that the page is correct
      $src = (int)($row['abstract_id']);
      $this->assertEquals($id, $src);
    }

    // Test query for pages without abstracts
    $badids = array(0, 11, 2426, 20026);
    foreach ($badids as $id) {
      $results = $db->get_abstract($id);
      
      // Make sure we get zero results
      $this->assertEquals(count($results), 0);
    }
  }
*/
  /**
   * @depends testCreation
   *
   * Tests the functionality of escaping queries
   */
  public function testEscape($db) {
    $goodstrs = array('Cat', 'aksdjlf912j1lj31l2k3', 'test');
    foreach ($goodstrs as $str) {
      $escaped = $db->escape($str);
      $this->assertEquals($str, $escaped);
    }

    $badstrs = array("Cat'; DROP TABLE page;", "'''''''");
    foreach ($badstrs as $str) {
      $escaped = $db->escape($str);
      $this->assertNotEquals($str, $escaped);
    }
  }

  /**
   * @depends testCreation
   *
   * Tests closing the database, which shouldn't
   * throw an exception
   */
  public function testClose($db) {
    $db->close();
  }

    /**
     * Test that config.php is properly formatted and creates the expected
     * environment when used in require_once.
     */
    public function testRequireConfig()
    {
	$this->assertFileExists('config.php');
	
	global $DB_HOST, $DB_USER, $DB_PASS, $DB_NAME, $LINK_URL;
	
	// Check that all of the expected variables exist and are not null

	$this->assertTrue(isset($DB_HOST));
	$this->assertTrue(isset($DB_USER));
	$this->assertTrue(isset($DB_PASS));
	$this->assertTrue(isset($DB_NAME));
	$this->assertTrue(isset($LINK_URL));
	
	$this->assertNotNull($DB_HOST);
	$this->assertNotNull($DB_USER);
	$this->assertNotNull($DB_PASS);
	$this->assertNotNull($DB_NAME);
	$this->assertNotNull($LINK_URL);
    }
}
?>