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
  error(400, "No query provided.\n");
}

// Establish mysql connection and use database.

$db = new GraphDB($DB_HOST, $DB_USER, $DB_PASS, $DB_NAME);

$like = $db->escape($_REQUEST["q"]);

$results = $db->get_autocomplete($like);

header('Content-Type:text/xml');
print("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
?>
<list phrase="<?= htmlspecialchars($like, ENT_QUOTES) ?>"
 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
 xsi:noNamespaceSchemaLocation="autocomplete.xsd">
<?php
foreach ($results as $row) {
?>
	<item id="<?= $row["page_id"] ?>" title="<?= htmlspecialchars($row["page_title"], ENT_QUOTES) ?>"/>
<?php
}
?>
</list>
