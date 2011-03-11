<?php
/*
  WikiGraph
  Copyright (c) 2011

  Author: Rob McClure <mgracecubs@gmail.com>

  Unit tests related to the abstract service
*/
require_once('../util.php');
require_once('BaseTest.php');
require_once('test_data.php');

class AbstractTest extends BaseTest {

  /**
   * Tests the functionality of abstract queries
   */
  public function testAbstract() {
    global $abstracts;
    // Test query for pages with abstracts
    foreach ($abstracts as $abstract) {
      $id = $abstract[0];
      $abstract = str_replace('"', "", $abstract[1]);

      $arr = $this->db->get_abstract($id);

      // Make sure we only get one result
      $this->assertEquals(count($arr), 1);
      $row = $arr[0];

      // Check that the fields are correct
      $this->assertArrayHasKey('abstract_id', $row);
      $this->assertArrayHasKey('abstract_text', $row);

      $src = (int)($row['abstract_id']);
      $this->assertEquals($id, $src);
      $this->assertEquals($abstract, $row['abstract_text']);
    }

    // Test query for pages without abstracts
    $badids = array(-1, 0, 999);
    foreach ($badids as $id) {
      $arr = $this->db->get_abstract($id);
      
      // Make sure we get zero results
      $this->assertEquals(count($arr), 0);
    }
  }

  /**
   * Test that the output from abstract.php
   * follows our schema
   */
  public function testXmlAbstract() {
    global $pages;
    foreach ($pages as $page) {
      $id = $page[0];
      system("php ../abstract.php $id | xmllint --noout --schema ../abstract.xsd - &> /dev/null", $result);
      $this->assertEquals($result, 0);
    }
  }
}
?>
