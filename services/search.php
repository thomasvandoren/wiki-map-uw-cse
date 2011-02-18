<?php
/*
WikiGraph
Copyright (c) 2011

Author: Jeremy Lenz <no.jeremy1212@gmail.com>

Search Service
Takes a search query
Returns similar page id's with page titles

TODO: query wikipedia for searches, add to XML


*/

include 'config.php';

//Die if no query provided
if(!isset($REQUEST["q"])) {
	header("HTTP/1.1 400 Bad Request");
	die("HTTP error 400 occurred: No query provided\n");
}

$wikiUrl = "";
$searchQuery = $_REQUEST["q"];

//Die if bad query given
if($searchQuery == "") {
	header("HTTP/1.1 400 Bad Request");
	die("HTTP error 400 occurred: Invalid query ".$searchQuery."\n");
}

//Fetch wikis search results

$row = "";

if($row) {
	header('Content-Type:text/xml');
	print("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");

?>
<search query="<?= $searchQuery ?>">

//loop here over searched results somehow
//	<item id="BLAH" title="BLAH"/>

</search>

<?php
} else {
	header("HTTP/1.1 400 File Not Found");
	die("HTTP error 400 occurred: Query not found ".$searchQuery."\n");
}
?>
