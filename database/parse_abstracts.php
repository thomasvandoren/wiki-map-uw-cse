<?php
/*
WikiGraph
Copyright (c) 2011

Author: Rob McClure <mgracecubs@gmail.com>

Abstract Parser
Takes the abstract XML dump from a MediaWiki database (abstract.xml),
parses it to find the titles and abstracts,
and then creates a SQL script to create and fill the
abstract table.
Script relies on the page table that results from
transform.sql
Script relies on the paths to the XML files in abstract_tmp
These paths can be URLs
*/

include 'config.php';

mysql_connect($host, $user, $pass);
mysql_select_db($dbname);


$sqlfile = "abstract.sql";
$fh = fopen($sqlfile, 'w');

$sql = <<<STRING
DROP TABLE IF EXISTS `abstract`;

CREATE TABLE `abstract` (
       `abstract_id` int(8),
       `abstract_title` varbinary(255),
       `abstract_text` text
) ENGINE=InnoDB DEFAULT CHARSET=binary;

STRING;

fwrite($fh, $sql);


$files = explode("\n", chop(file_get_contents("abstract_tmp")));

foreach ($files as $i => $file) {
  print("Parsing $file\n");
  fwrite($fh, "SOURCE abstract$i.sql;\n");
  $fhp = fopen("abstract$i.sql", 'w');

  $reader = new XMLReader();
  $reader->open($file);

  $count = 0;
  $pairs = array();
  while ($reader->read()) {
    if ($reader->name == "doc" && $reader->nodeType == XMLReader::ELEMENT) {
      // Found a page
      $title = null;
      $abstract = null;
      while ($reader->read()) {
	if ($reader->name == "doc" && $reader->nodeType == XMLReader::END_ELEMENT) {
	  // Page is done, get information and insert into database
	  $pairs[$count] = "(NULL, '" . $title . "','" . $abstract . "')";
	  $count++;
	  if ($count == 1000) {
	    $str = "INSERT INTO `abstract` VALUES" . implode(",", $pairs) . ";\n";
	    fwrite($fhp, $str);
	    $count = 0;
	    $pairs = array();
	  }
	  break;
	} else if ($reader->name == "title" && $reader->nodeType == XMLReader::ELEMENT) {
	  // Get the article title

	  $reader->read();
	  // All titles begin with Wikibooks: , which we need to get rid of
	  $title = substr($reader->value, 11);
	  // and replace spaces with _
	  $title = str_replace(" ", "_", $title);
	  $title = mysql_real_escape_string($title);
	} else if ($reader->name == "abstract" && $reader->nodeType == XMLReader::ELEMENT) {
	  // Get the article abstract
	  $reader->read();
	  $abstract = $reader->value;
	  $abstract = mysql_real_escape_string($abstract);
	}
      }
    }
  }

  $str = "INSERT INTO `abstract` VALUES" . implode(",", $pairs) . ";\n";
  fwrite($fhp, $str);

  $reader->close();
  fclose($fhp);
}

fwrite($fh, "UPDATE abstract SET abstract_id=(SELECT page_id FROM page WHERE page_title = abstract_title LIMIT 1);\n");
fwrite($fh, "DELETE FROM abstract WHERE abstract_id IS NULL;");
fwrite($fh, "ALTER TABLE abstract DROP COLUMN abstract_title, CHANGE `abstract_id` `abstract_id` INT(8) UNSIGNED NOT NULL PRIMARY KEY\n");
fclose($fh);

?>
