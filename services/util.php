<?php
/*
WikiGraph
Copyright (c) 2011

Author: Thomas Van Doren <thomas.vandoren@gmail.com>
        Rob McClure <mgracecubs@gmail.com>

This page contains common functions and classes
in the WikiGraph services.

Functions in this file:
  error($error_number, $error_msg);

Classes in this file:
  GraphDB
    __construct($host, $user, $pass, $dbname)
    close()
    get_page_info($ids)
    get_page_links($id)

*/

/**
 * Kills the current execution and writes the error message to
 * page.
 * If testing, throws an exception instead of quitting
 */
function error($error_number, $error_msg) {
  global $TESTING;
  header("HTTP/1.1 $error_number");
  if ($TESTING)
    throw new Exception($error_msg);
  else
    die("HTTP $error_number : $error_msg");
}


class GraphDB {
  // Link to the database
  private $db;

  /**
   * Creates a connection to the given MySQL host
   * and selects the given database
   */
  public function __construct($host, $user, $pass, $dbname) {
    $this->db = mysql_connect($host, $user, $pass);
    if (!$this->db) {
      error(500, "Could not connect to database: " . mysql_error($this->db));
    }

    if (!mysql_select_db($dbname, $this->db)) {
      error(500, "Could not select database: " . mysql_error($this->db));
    }
  }

  /**
   * Closes the connection to the MySQL host
   */
  public function close() {
    if (!mysql_close($this->db)) {
      error(500, "Could not close connection: " . mysql_error($this->db));
    }
  }

  /**
   * Executes an arbitrary query
   * Returns the rows from the database as an array
   */
  private function query($q) {
    $result = mysql_query($q, $this->db);
    if (!$result) {
      error(500, "Could not execute query: " . mysql_error($this->db));
    }
    $rows = array();
    $i = 0;
    while ($row = mysql_fetch_array($result, MYSQL_ASSOC)) {
      $rows[$i++] = $row;
    }
    return $rows;
  }

  /**
   * Returns the page info for certain pages
   * Takes either an id or an array of ids
   */
  public function get_page_info($ids) {
    if(is_int($ids)) {
      $ids = array($ids);
    }

    $ids = implode(',', $ids);
    $q = "SELECT * FROM page WHERE page_id IN ($ids)";
    return $this->query($q);
  }

  /**
   * Returns the page links that include a certain page
   * Takes the id of the page
   *
   * TODO: Find a better way to limit the amount of info that gets passed
   *       back
   */
  public function get_page_links($id) {
    $q = "SELECT pl_from, pl_to FROM pagelinks WHERE pl_from = $id OR pl_to = $id LIMIT 50";
    return $this->query($q);
  }

  /**
   * Returns possible matches from a search
   * Takes the string to search for
   */
  public function get_search_results($like) {
    $q =  "SELECT page_id, page_title FROM page WHERE page_title LIKE '$like%' LIMIT 24";
    return $this->query($q);
  }

  /**
   * Returns possible matches for autocomplete
   * Takes the partial input string
   */
  public function get_autocomplete($like) {
    $q = "SELECT page_id, page_title FROM page WHERE page_title LIKE '$like%' LIMIT 10";
    return $this->query($q);
  }

  /**
   * Returns the abstract for the given page
   * Takes the page id
   */
  public function get_abstract($id) {
    $q = "SELECT abstract_text FROM abstract WHERE abstract_id = $id";
    return $this->query($q);
  }

  /**
   * Escapes the string given the
   * current database connection
   */
  public function escape($s) {
    return mysql_real_escape_string($s, $this->db);
  }
}

?>
