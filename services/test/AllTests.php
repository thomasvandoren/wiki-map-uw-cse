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
require_once("../config.php");
require_once("../util.php");

class AllTests extends PHPUnit_Framework_TestCase
{
    /**
     * Test that config.php is properly formatted and creates the expected
     * environment when used in require_once.
     */
    public function testRequireConfig()
    {
	$this->assertFileExists('../config.php', 'config file does not exist');
	
	require_once('../config.php');

	global $DB_HOST, $DB_USER, $DB_PASS, $DB_NAME, $LINK_URL;
	
	// Check that all of the expected variables exist and are not null

	$this->assertTrue(isset($DB_HOST), 'what what');
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