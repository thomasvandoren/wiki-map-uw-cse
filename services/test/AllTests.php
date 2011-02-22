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
    
  public function testCreation() {
    global $DB_HOST, $DB_USER, $DB_PASS, $DB_NAME;

    try {
      $db = new GraphDB('badhost', $DB_USER, $DB_PASS, $DB_NAME);
    } catch (Exception $e) {
      $error = true;
    }
    $this->assertTrue($error, "Creation with invalid host expected to throw an error.");

    $error = false;
    try {
      $db = new GraphDB($DB_HOST, 'baduser', $DB_PASS, $DB_NAME);
    } catch (PHPUnit_Framework_Error $e) {
      $error = true;
    }
    $this->assertTrue($error, "Creation with invalid username expected to throw an error.");

    $error = false;
    try {
      $db = new GraphDB($DB_HOST, $DB_USER, 'badpass', $DB_NAME);
    } catch (PHPUnit_Framework_Error $e) {
      $error = true;
    }
    $this->assertTrue($error, "Creation with invalid password expected to throw an error.");

    $error = false;
    try {
      $db = new GraphDB($DB_HOST, $DB_USER, $DB_PASS, 'baddbname');
    } catch (Exception $e) {
      $error = true;
    }
    $this->assertTrue($error, "Creation with invalid database expected to throw an error.");

    $db = new GraphDB($DB_HOST, $DB_USER, $DB_PASS, $DB_NAME);
    $this->assertNotNull($db);
    return $db;
  }

  /**
   * @depends testCreation
   * Tests getting page info from the database
   * for certain ids
   * The tested pages are known to exist/not exist
   * for the current Wikipedia table dump
   */
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
    }
  }

  /**
   * @depends testCreation
   */
  public function testAutocomplete($db) {
    $strs = array("Cat", "Ruby", "Wiki");
    foreach ($strs as $str) {
      $arr = $db->get_autocomplete($str);
      $this->assertLessThanOrEqual(count($arr), 10);
      foreach ($arr as $row) {
	$this->assertArrayHasKey('page_title', $row);
	$this->assertRegExp("/^$str/", $row['page_title']);
      }
    }

    $badstrs = array("Cat'; SELECT COUNT(*) FROM page;", "adkjfalkdjflakdf", "012345678910");
    foreach ($badstrs as $str) {
      $str = $db->escape($str);
      $arr = $db->get_autocomplete($str);
      $this->assertEquals(count($arr), 0);
    } 
  }

  /**
   * @depends testCreation
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