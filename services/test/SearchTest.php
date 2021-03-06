<?php
/*
  WikiGraph
  Copyright (c) 2011

  Author: Rob McClure <mgracecubs@gmail.com>

  Unit tests related to the search service
*/
require_once('../util.php');
require_once('BaseTest.php');
require_once('test_data.php');

class SearchTest extends BaseTest {

  /**
   * Tests the functionality of exact search queries
   */
  public function testExactSearch() {
    global $pages;
    $titles = array();
    foreach ($pages as $page) {
      array_push($titles, str_replace('"', "", $page[1]));
    }

    // Test search with all partial titles
    // from the pages
    foreach ($titles as $title) {
      $search = $title;
	
      // Calculate the correct answers
      $ans = array();
      foreach ($titles as $title2) {
	$tmp1 = strtolower($search);
	$tmp2 = strtolower($title2);
	if (strcasecmp($tmp2, $tmp1) === 0) {
	  array_push($ans, $title2);
	}
      }

      $arr = $this->db->get_search_results_exact($search);
      $this->assertEquals(count($arr), count($ans));
      foreach ($arr as $row) {
	$this->assertArrayHasKey('page_title', $row);
	$this->assertContains($row['page_title'], $ans);
	$this->assertEquals(strtolower($search), strtolower($row['page_title']));
      }
      
    }


    // Test some bad search terms
    $badstrs = array("Cat'; SELECT COUNT(*) FROM page;", "adkjfalkdjflakdf", "012345678910");
    foreach ($badstrs as $str) {
      $str = $this->db->escape($str);
      $arr = $this->db->get_search_results_exact($str);
      $this->assertEquals(count($arr), 0);
    } 
  }

  /**
   * Tests the functionality of like search queries
   */
  public function testLikeSearch() {
    global $pages;
    $titles = array();
    foreach ($pages as $page) {
      array_push($titles, str_replace('"', "", $page[1]));
    }

    // Test search with all partial titles
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

	$arr = $this->db->get_search_results_like($search);
	$this->assertEquals(count($arr), count($ans));
	foreach ($arr as $row) {
	  $this->assertArrayHasKey('page_title', $row);
	  $this->assertContains($row['page_title'], $ans);
	  $this->assertStringStartsWith(strtolower($search), strtolower($row['page_title']));
	}
      }
    }


    // Test some bad search terms
    $badstrs = array("Cat'; SELECT COUNT(*) FROM page;", "adkjfalkdjflakdf", "012345678910");
    foreach ($badstrs as $str) {
      $str = $this->db->escape($str);
      $arr = $this->db->get_search_results_like($str);
      $this->assertEquals(count($arr), 0);
    } 
  }

  /**
   * Tests the functionality of soundex search queries
   */
  public function testSoundexSearch() {
    global $pages;
    $titles = array();
    foreach ($pages as $page) {
      array_push($titles, str_replace('"', "", $page[1]));
    }

    // check if soundex value of searched term 
    //is same for all terms found
    foreach ($titles as $search) {
      $arr = $this->db->get_search_results_soundex($search);
      $searchSoundexValue = soundex($search);
      foreach ($arr as $row) {
        $this->assertArrayHasKey('page_title', $row);
	$this->assertTrue(strcmp($searchSoundexValue,soundex($row['page_title'])) === 0);
      }
    }


    // Test some bad search terms
    $badstrs = array("Cat'; SELECT COUNT(*) FROM page;", "adkjfalkdjflakdf", "012345678910");
    foreach ($badstrs as $str) {
      $str = $this->db->escape($str);
      $arr = $this->db->get_search_results_soundex($str);
      $this->assertEquals(count($arr), 0);
    } 
  }

  /**
   * Test that the output from search.php
   * follows our schema
   */
  public function testXmlSearch() {
    global $pages;
    $titles = array();
    foreach ($pages as $page) {
      array_push($titles, str_replace('"', "", $page[1]));
    }

    foreach ($titles as $title) {
      $len = strlen($title);
      for ($i = 1; $i < $len; $i++) {
        $search = substr($title, 0, $i);

	$ans = array();
	$tmp1 = strtolower($search);
	foreach ($titles as $title2) {
	  $tmp2 = strtolower($title2);
	  if (strpos($tmp2, $tmp1) === 0) {
	    array_push($ans, $title2);
	  }
	  // Check for exact match, excluding whitespace
	  if (trim($tmp1) == trim($tmp2)) {
	    $ans = array();
	    break;
	  }
	}

        if (count($ans) > 1) {
	  system("php ../search.php \"$search\" | xmllint --noout --schema ../search.xsd - &> /dev/null", $result);
	  $this->assertEquals($result, 0, $search);
        }
        
      }
    }
  }
}
?>
