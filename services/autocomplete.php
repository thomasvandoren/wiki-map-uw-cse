<?php
/*
WikiGraph
Copyright (c) 2011

Author: Rob McClure <mgracecubs@gmail.com>

Autocomplete service
*/

include 'config.php';

// Die if no query provided
if (!isset($_REQUEST["q"])) {
  header("HTTP/1.1 400 Bad Request");
  die("HTTP error 400 occurred: No query provided\n");
}

header('Content-Type:text/xml');
print("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");

// Establish mysql connection and use database.

$db = mysql_connect($host, $user, $pass);
mysql_select_db($dbname);

$likestring = mysql_real_escape_string($_REQUEST["q"]);
$query = "SELECT page_id, page_title FROM page WHERE page_title LIKE \"$likestring%\" LIMIT 10;";

$results = mysql_query($query);

$row = mysql_fetch_array($results);
?>
<list phrase="<?= $likestring ?>">
<?php
while ($row) {
?>
	<item id="<?= $row["page_id"] ?>" title="<?= $row["page_title"] ?>"/>
<?php
$row = mysql_fetch_array($results);
}
?>
</list>
