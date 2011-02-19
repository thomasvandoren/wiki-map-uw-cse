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

require_once("PHPUnit/Framework.php");

class AllTests extends PHPUnit_Framework_TestCase
{
    protected function setUp()
    {
	require_once('../config.php');
	require_once('../util.php');

	/*
	 $this->sharedMysqlLink = new PDO('mysql:host=wopr;dbname=test',
					 'user',
					 'pass');
	*/

    }

    protected function tearDown()
    {
	/*
	 $this->sharedMysqlLink = NULL;
	*/
    }
    
    /**
     * Test that config.php is properly formatted and creates the expected
     * environment when used in require_once.
     */
    public function testRequireConfig()
    {
	$this->assertFileExists('../config.php', 'config file does not exist');

	require_once('../config.php');
	
	// Check that all of the expected variables exist and are not null

	$this->assertTrue(isset($host));
	$this->assertTrue(isset($user));
	$this->assertTrue(isset($pass));
	$this->assertTrue(isset($dbname));
	$this->assertTrue(isset($LINK_URL));
	
	$this->assertNotNull($host);
	$this->assertNotNull($user);
	$this->assertNotNull($pass);
	$this->assertNotNull($dbname);
	$this->assertNotNull($LINK_URL);
    }
}
?>