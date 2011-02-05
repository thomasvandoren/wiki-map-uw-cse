<?php
include "config.php";

$reader = new XMLReader();
$reader->open("enwikibooks-20110127-abstract.xml");

$db = mysql_connect("localhost", $username, $password);
mysql_select_db($database);

while ($reader->read()) {
  if ($reader->name == "doc" && $reader->nodeType == XMLReader::ELEMENT) {
    // Found a page
    $title = null;
    $abstract = null;
    while ($reader->read()) {
      if ($reader->name == "doc" && $reader->nodeType == XMLReader::END_ELEMENT) {
	// Page is done, get information and insert into database

	// Find page id for this title
	$query = "SELECT page_id FROM page WHERE page_title = '" . mysql_real_escape_string($title) . "' AND page_namespace = 0";
	$results = mysql_query($query);
	$row = mysql_fetch_array($results);
	if ($row) {
	  // Insert into database if this is a valid entry
	  $page_id = $row["page_id"];
	  mysql_query("INSERT INTO abstract (`abstract_id`, `abstract_text`) VALUES (" . $page_id . ", '" . mysql_real_escape_string($abstract) . "')");
	}
	break;
      } else if ($reader->name == "title" && $reader->nodeType == XMLReader::ELEMENT) {
	// Get the article title

	$reader->read();
	// All titles begin with Wikibooks: , which we need to get rid of
	$title = substr($reader->value, 11);
	// and replace spaces with _
	$title = str_replace(" ", "_", $title);
      } else if ($reader->name == "abstract" && $reader->nodeType == XMLReader::ELEMENT) {
	// Get the article abstract
	$reader->read();
	$abstract = $reader->value;
      }
    }
  }
}

$reader->close();

?>