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
  // Pages to insert into the test database
  private static $pages = array(
				array(1, '"Title"', 0, 0, 100),
				array(2, '"Another title"', 0, 0, 200),
				array(3, '"Redirect to title"', 1, 0, 10),
				array(5, '"WikiGraph"', 0, 0, 300),
				array(6, '"WikiGraph Developers"', 0, 0, 100),
				array(8, '"WikiGraph (disambiguation)"', 0, 1, 10),
				array(9, '"Title 2"', 0, 0, 100)
				);
  // Links to insert into the test database
  private static $links = array(
				array(1, 2),
				array(1, 5),
				array(2, 1),
				array(3, 1),
				array(5, 6),
				array(6, 5),
				array(8, 5)
				);
  // Abstracts to insert into the test database
  private static $abstracts = array(
				    array(1, '"A page about something"'),
				    array(5, '"The coolest project ever"'),
				    array(6, '"People working on the coolest project ever"')
				    );

  /**
   * Called before tests are run
   *
   * Initializes the database that is used
   * during testing
   */
  public static function setUpBeforeClass() {
    global $DB_HOST, $DB_USER, $DB_PASS, $DB_NAME;
    $db = mysql_connect($DB_HOST, $DB_USER, $DB_PASS);
    mysql_select_db($DB_NAME);

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

    foreach (AllTests::$pages as $page) {
      $q = "INSERT INTO page VALUES(" . implode(",", $page) . ")";
      mysql_query($q);
    }

    // Init pagelinks table
    $q = "CREATE TABLE pagelinks ("
      .  "  pl_from INT(8),"
      .  "  pl_to INT(8),"
      .  "  FOREIGN KEY (pl_from) REFERENCES page (page_id),"
      .  "  FOREIGN KEY (pl_to) REFERENCES page (page_id))";
    mysql_query($q);

    foreach (AllTests::$links as $link) {
      $q = "INSERT INTO pagelinks VALUES(" . implode(",", $link) . ")";
      mysql_query($q);
    }

    // Init abstract table
    $q = "CREATE TABLE abstract ("
      .  "  abstract_id INT(8),"
      .  "  abstract_text TEXT,"
      .  "  FOREIGN KEY (abstract_id) REFERENCES page (page_id))";
    mysql_query($q);

    foreach (AllTests::$abstracts as $abstract) {
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
   * Called after tests are run
   *
   * Tears down the database used for testing
   */
  public static function tearDownAfterClass() {
    global $DB_HOST, $DB_USER, $DB_PASS, $DB_NAME;
    $db = mysql_connect($DB_HOST, $DB_USER, $DB_PASS);
    mysql_select_db($DB_NAME);

    mysql_query("DROP TABLE page, pagelinks, pagelinks_cache, abstract");
    mysql_close($db);
  }

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
   */
  public function testPageInfo($db) {

    $ids = array();
    // Check page info for individual pages
    foreach (AllTests::$pages as $page) {
      $id = $page[0];
      array_push($ids, $id);
      $title = str_replace('"', "", $page[1]);
      $redirect = $page[2];
      $ambig = $page[3];
      $len = $page[4];

      $arr = $db->get_page_info($id);
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
    $arr = $db->get_page_info($ids);
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
      $arr = $db->get_page_info($id);
      $this->assertEquals(count($arr), 0);
    }

    $arr = $db->get_page_info($id);
    $this->assertEquals(count($arr), 0);
  }

  /**
   * @depends testCreation
   *
   * Tests the functionality of link queries
   */
  public function testLinks($db) {
    $ids = array();
    foreach (AllTests::$pages as $page) {
      array_push($ids, $page[0]);
    }

    // Test link requests for all pages
    foreach ($ids as $id) {
      $results = $db->get_page_links($id);
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
	  $this->assertContains(array($src, $dst), AllTests::$links);
	if ($row['plc_in'] == '1')
	  $this->assertContains(array($dst, $src), AllTests::$links);
      }
    }
  }

  /**
   * @depends testCreation
   *
   * Tests the functionality of autocomplete
   * queries
   *
   */
  public function testAutocomplete($db) {

    $titles = array();
    foreach (AllTests::$pages as $page) {
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

	$arr = $db->get_autocomplete($search);
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
      $str = $db->escape($str);
      $arr = $db->get_autocomplete($str);
      $this->assertEquals(count($arr), 0);
    }
  }

  /**
   * @depends testCreation
   *
   * Tests the functionality of like search queries
   *
   * Currently, this is exactly the same as autocorrect
   */
  public function testLikeSearch($db) {
    $titles = array();
    foreach (AllTests::$pages as $page) {
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

	$arr = $db->get_search_results_like($search);
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
      $str = $db->escape($str);
      $arr = $db->get_search_results_like($str);
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
  public function testAbstract($db) {
    // Test query for pages with abstracts
    foreach (AllTests::$abstracts as $abstract) {
      $id = $abstract[0];
      $abstract = str_replace('"', "", $abstract[1]);

      $arr = $db->get_abstract($id);

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
      $arr = $db->get_abstract($id);
      
      // Make sure we get zero results
      $this->assertEquals(count($arr), 0);
    }
  }

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
   * Test that the output from graph.php
   * follows our schema
   */
  public function testXmlGraph() {
    foreach (AllTests::$pages as $page) {
      $id = $page[0];
      system("php ../graph.php $id | xmllint --noout --schema ../graph.xsd - &> /dev/null", $result);
      $this->assertEquals($result, 0);
    }
  }

  /**
   * Test that the output from autocomplete.php
   * follows our schema
   */
  public function testXmlAutocomplete() {
    $titles = array();
    foreach (AllTests::$pages as $page) {
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
  
  /**
   * Test that the output from search.php
   * follows our schema
   */
  public function testXmlSearch() {
    $titles = array();
    foreach (AllTests::$pages as $page) {
      array_push($titles, str_replace('"', "", $page[1]));
    }

    foreach ($titles as $title) {
      $len = strlen($title);
      for ($i = 1; $i < $len; $i++) {
        $search = substr($title, 0, $i);

	$ans = array();
	foreach ($titles as $title2) {
	  $tmp1 = strtolower($search);
	  $tmp2 = strtolower($title2);
	  if (strpos($tmp2, $tmp1) === 0) {
	    array_push($ans, $title2);
	  }
	  if ($tmp1 === $tmp2) {
	    $ans = array();
	    break;
	  }
	}

        if (count($ans) > 1) {
	  system("php ../search.php \"$search\" | xmllint --noout --schema ../search.xsd - &> /dev/null", $result);
	  $this->assertEquals($result, 0);
        }
        
      }
    }
  }
  
  /**
   * Test that the output from abstract.php
   * follows our schema
   */
  public function testXmlAbstract() {
    foreach (AllTests::$pages as $page) {
      $id = $page[0];
      system("php ../abstract.php $id | xmllint --noout --schema ../abstract.xsd - &> /dev/null", $result);
      $this->assertEquals($result, 0);
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
