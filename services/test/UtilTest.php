<?php
/*
  WikiGraph
  Copyright (c) 2011

  Author: Rob McClure <mgracecubs@gmail.com>

  Unit tests for functions in util.php
  that are not specific to any service
*/
require_once('config.php');
require_once('../util.php');
require_once('BaseTest.php');
require_once('test_data.php');


class UtilTest extends BaseTest {
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
   */
  public function testCreation() {
    global $DB_HOST, $DB_USER, $DB_PASS, $DB_NAME;

    $this->helper_testCreation('badhost', $DB_USER, $DB_PASS, $DB_NAME);
    $this->helper_testCreation($DB_HOST, 'baduser', $DB_PASS, $DB_NAME);
    $this->helper_testCreation($DB_HOST, $DB_USER, 'badpass', $DB_NAME);
    $this->helper_testCreation($DB_HOST, $DB_USER, $DB_PASS, 'baddbname');
  }

  /**
   * Tests getting page info from the database
   * for certain ids
   */
  public function testPageInfo() {
    global $pages;

    $ids = array();
    // Check page info for individual pages
    foreach ($pages as $page) {
      $id = $page[0];
      array_push($ids, $id);
      $title = str_replace('"', "", $page[1]);
      $redirect = $page[2];
      $ambig = $page[3];
      $len = $page[4];

      $arr = $this->db->get_page_info($id);
      $this->assertEquals(count($arr), 1);
      
      $row = $arr[0];
      $this->assertArrayHasKey('page_id', $row);
      $this->assertArrayHasKey('page_title', $row);
      $this->assertArrayHasKey('page_len', $row);
      $this->assertArrayHasKey('page_is_redirect', $row);
      $this->assertArrayHasKey('page_is_ambiguous', $row);

      $this->assertEquals((int)($row['page_id']), $id);
      $this->assertEquals($row['page_title'], $title);
      $this->assertEquals((int)($row['page_is_redirect']), $redirect);
      $this->assertEquals((int)($row['page_is_ambiguous']), $ambig);
      $this->assertEquals((int)($row['page_len']), $len);
    }

    // Check page info for all pages
    $arr = $this->db->get_page_info($ids);
    $this->assertEquals(count($arr), count($ids));

    // Check presence of fields
    foreach ($arr as $row) {
      $this->assertArrayHasKey('page_id', $row);
      $this->assertContains((int)($row['page_id']), $ids);
      $this->assertArrayHasKey('page_title', $row);
      $this->assertArrayHasKey('page_len', $row);
      $this->assertArrayHasKey('page_is_redirect', $row);
      $this->assertArrayHasKey('page_is_ambiguous', $row);
    }

    // Check page info for bad pages
    $ids = array(-1, 0, 999);
    foreach ($ids as $id) {
      $arr = $this->db->get_page_info($id);
      $this->assertEquals(count($arr), 0);
    }

    $arr = $this->db->get_page_info($id);
    $this->assertEquals(count($arr), 0);
  }

  /**
   * Tests the functionality of escaping queries
   */
  public function testEscape() {
    $goodstrs = array('Cat', 'aksdjlf912j1lj31l2k3', 'test');
    foreach ($goodstrs as $str) {
      $escaped = $this->db->escape($str);
      $this->assertEquals($str, $escaped);
    }

    $badstrs = array("Cat'; DROP TABLE page;", "'''''''");
    foreach ($badstrs as $str) {
      $escaped = $this->db->escape($str);
      $this->assertNotEquals($str, $escaped);
    }
  }
}
?>