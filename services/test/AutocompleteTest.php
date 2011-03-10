<?php
/*
  WikiGraph
  Copyright (c) 2011

  Author: Rob McClure <mgracecubs@gmail.com>

  Unit tests related to the autocomplete service
*/
require_once('../util.php');
require_once('BaseTest.php');
require_once('test_data.php');

class AutocompleteTest extends BaseTest {
  /**
   * Tests the functionality of autocomplete
   * queries
   */
  public function testAutocomplete() {
    global $pages;
    $titles = array();
    foreach ($pages as $page) {
      array_push($titles, str_replace('"', "", $page[1]));
    }

    // Test autocomplete with all partial titles
    // from the pages
    foreach ($titles as $title) {
      $len = strlen($title);
      for ($i = 1; $i < $len; $i++) {
	$search = substr($title, 0, $i);
	
	// Calculate the correct answers
	$ans = array();
	foreach ($titles as $title2) {
	  $tmp1 = strtolower($search);
	  $tmp2 = strtolower($title2);
	  if (strpos($tmp2, $tmp1) === 0) {
	    array_push($ans, $title2);
	  }
	}

	$arr = $this->db->get_autocomplete($search);
	$this->assertEquals(count($arr), count($ans));
	foreach ($arr as $row) {
	  $this->assertArrayHasKey('page_title', $row);
	  $this->assertContains($row['page_title'], $ans);
	  $this->assertStringStartsWith(strtolower($search), strtolower($row['page_title']));
	}
      }
    }
    // Test some bad autocomplete terms
    $badstrs = array("Cat'; SELECT COUNT(*) FROM page;", "adkjfalkdjflakdf", "012345678910");
    foreach ($badstrs as $str) {
      $str = $this->db->escape($str);
      $arr = $this->db->get_autocomplete($str);
      $this->assertEquals(count($arr), 0);
    }
  }

  /**
   * Test that the output from autocomplete.php
   * follows our schema
   */
  public function testXmlAutocomplete() {
    global $pages;

    $titles = array();
    foreach ($pages as $page) {
      array_push($titles, str_replace('"', "", $page[1]));
    }

    foreach ($titles as $title) {
      $len = strlen($title);
      for ($i = 1; $i < $len; $i++) {
        $search = substr($title, 0, $i);
        system("php ../autocomplete.php \"$search\" | xmllint --noout --schema ../autocomplete.xsd - &> /dev/null", $result);
        $this->assertEquals($result, 0);
      }
    }
  }
}
?>
