<?php
/*
WikiGraph
Copyright (c) 2011

Author: Rob McClure <mgracecubs@gmail.com>

Autocomplete service
*/

include 'config.php';
include 'util.php';

// Die if no query provided
if (!isset($_REQUEST["q"])) {
  header("HTTP/1.1 400 Bad Request");
  die("HTTP error 400 occurred: No query provided\n");
}

header('Content-Type:text/xml');
print("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");

// Establish mysql connection and use database.

$db = new GraphDB($DB_HOST, $DB_USER, $DB_PASS, $DB_NAME);

$like = $db->escape($_REQUEST["q"]);

$results = $db->get_autocomplete($like);

?>
<list phrase="<?= $likestring ?>">
<?php
foreach ($results as $row) {
?>
	<item id="<?= $row["page_id"] ?>" title="<?= $row["page_title"] ?>"/>
<?php
}
?>
</list>
