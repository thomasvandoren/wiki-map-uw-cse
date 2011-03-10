<?php
/*
  WikiGraph
  Copyright (c) 2011

  Author: Rob McClure <mgracecubs@gmail.com>

  Unit tests related to the graph service
*/
require_once('../util.php');
require_once('BaseTest.php');
require_once('test_data.php');

class GraphTest extends BaseTest {
  /**
   * Tests the functionality of link queries
   */
  public function testLinks() {
    global $pages, $links;
    $ids = array();
    foreach ($pages as $page) {
      array_push($ids, $page[0]);
    }

    // Test link requests for all pages
    foreach ($ids as $id) {
      $results = $this->db->get_page_links($id);
      foreach ($results as $row) {
	// Test that the rows have the correct fields
	$this->assertArrayHasKey('plc_from', $row);
	$this->assertArrayHasKey('plc_to', $row);
	$this->assertArrayHasKey('plc_out', $row);
	$this->assertArrayHasKey('plc_in', $row);

	// Test that results are valid numbers
	$src = (int)($row['plc_from']);
	$this->assertNotEquals($src, 0);
	$dst = (int)($row['plc_to']);
	$this->assertNotEquals($dst, 0);

	// Test that the initial ID is either
	// the source or destination
	$this->assertTrue($id === $src || $id === $dst);
	
	// Make sure this link actually exists
	if ($row['plc_out'] == '1')
	  $this->assertContains(array($src, $dst), $links);
	if ($row['plc_in'] == '1')
	  $this->assertContains(array($dst, $src), $links);
      }
    }
  }

  /**
   * Test that the output from graph.php
   * follows our schema
   */
  public function testXmlGraph() {
    global $pages;
    foreach ($pages as $page) {
      $id = $page[0];
      system("php ../graph.php $id | xmllint --noout --schema ../graph.xsd - &> /dev/null", $result);
      $this->assertEquals($result, 0);
    }
  }
}
?>
