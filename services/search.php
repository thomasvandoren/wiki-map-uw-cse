<?php
/*
WikiGraph
Copyright (c) 2011

Author: Jeremy Lenz <no.jeremy1212@gmail.com>

Search Service
Takes a search query
Returns similar page id's with page titles

TODO: assess link strength


*/

require_once 'config.php';
require_once 'util.php';

//Die if no query provided
if(!isset($_REQUEST["q"])) {
	header("HTTP/1.1 400 Bad Request");
	die("HTTP error 400 occurred: No query provided\n");
}


connect_db();

$searchQuery = mysql_real_escape_string($_REQUEST["q"]);


//Die if bad query given
if($searchQuery == "") {
	header("HTTP/1.1 400 Bad Request");
	die("HTTP error 400 occurred: Invalid query ".$searchQuery."\n");
}

//Fetch wikis search results

$mysqlQuery = "SELECT page_id, page_title FROM page WHERE page_title 
	LIKE '%$searchQuery%' LIMIT 24";
$results = mysql_query($mysqlQuery);
$row = mysql_fetch_array($results);

if($row && (mysql_num_rows($results) > 1)) {
	header('Content-Type:text/xml');
	print("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");

?>
<search query="<?= $searchQuery ?>">
<?php			

	while($row) {
?>	
	<item id="<?= $row["page_id"] ?>" title="<?= $row["page_title"] ?>"/>	
<?php
		$row = mysql_fetch_array($results);
	}

?>
</search>

<?php
} else if($row) {
	//call graph.php with current page id
	print("this is incomplete!");
} else {
	header("HTTP/1.1 400 File Not Found");
	die("HTTP error 400 occurred: Query not found ".$searchQuery."\n");
}
?>
