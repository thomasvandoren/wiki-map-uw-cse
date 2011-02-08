<?php
/*
WikiGraph
Copyright (c) 2011

Author: Rob McClure <mgracecubs@gmail.com>

Graph service
Currently only implements one level of link depth, and only outgoing links from the center node
Currently takes the title of the node
*/
	
include 'config.php';

$db = mysql_connect("localhost", $user, $pass);
mysql_select_db($dbname);

$page_title = mysql_real_escape_string($_REQUEST["q"]);

$query = "SELECT page_id, page_title FROM page WHERE page_title = '$page_title';";
$results = mysql_query($query);
$row = mysql_fetch_array($results);

/* its jeremy, guess more checks here to denote whether string has 
multiple occurrences (via while looping through db results) or a variation 
of the query of db above, afterwards conditional on what to do with found 
information. one result is normal, more than one is ambiguity, none is... 
impossible with autocomplete? hope that question mark doesnt screw ne 
thing up */

if ($row) {
	$page_id = $row["page_id"];
} else {
	header("HTTP/1.1 404 File Not Found");
	die("HTTP error 404 occurred: Page not found ($page_title)");
}

header('Content-Type:text/xml');
print("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");

$query = "SELECT src.page_id src_id, src.page_title src_title, dst.page_id dst_id, dst.page_title dst_title "
	   . "FROM page src, page dst, pagelinks pl "
       .  "WHERE src.page_id = pl.pl_from AND dst.page_id = pl.pl_to AND src.page_id = $page_id;";

$results = mysql_query($query);

$row = mysql_fetch_array($results);
$nodes = array();
?>

<graph center="<?= $page_id ?>">
	<source id="<?= $page_id ?>" title="<?= $page_title ?>">
<?php
while ($row) {
	$nodes[$row["dst_id"]] = $row["dst_title"];
?>
		<dest id="<?= $row["dst_id"] ?>"/>
<?php
$row = mysql_fetch_array($results);
}
?>
	</source>
<?php
foreach ($nodes as $id => $title) {
?>
	<source id="<?= $id ?>" title="<?= $title ?>">
	</source>
<?php
}
?>
</graph>
