<?php
/*
WikiGraph
Copyright (c) 2011

Author: Rob McClure <mgracecubs@gmail.com>

Graph service
Currently only implements one level of link depth
Currently takes the title of the node
*/
	
include 'config.php';

if (!isset($_REQUEST["id"]) || strlen($_REQUEST["id"]) == 0) {
  header("HTTP/1.1 400 Bad Request");
  die("HTTP error 400 occurred: No query provided\n");
}

// Establish connection to MySQL server and use database.

$db = mysql_connect($host, $user, $pass);
mysql_select_db($dbname);

$page_id = (int)($_REQUEST["id"]);

if ($page_id === 0)
{
  header("HTTP/1.1 400 Bad Request");
  die("HTTP 400 Bad Request: invalid id \"$page_id\"");
}

$query = "SELECT page_id, page_title FROM page WHERE page_id = $page_id;";
$results = mysql_query($query);
$row = mysql_fetch_array($results);

/* its jeremy, guess more checks here to denote whether string has 
multiple occurrences (via while looping through db results) or a variation 
of the query of db above, afterwards conditional on what to do with found 
information. one result is normal, more than one is ambiguity, none is... 
impossible with autocomplete? hope that question mark doesnt screw ne 
thing up */

if (!$row) {
    header("HTTP/1.1 404 File Not Found");
    die("HTTP error 404 occurred: Page not found (\"$page_id\")\n");
}

header('Content-Type:text/xml');
print("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");

// Fetch all links with our target page as a source or destination
// including page info (title, length)
$query = "SELECT src.page_id src_id, src.page_title src_title, src.page_len src_len, dst.page_id dst_id, dst.page_title dst_title, dst.page_len dst_len "
	   . "FROM page src, page dst, pagelinks pl "
       .  "WHERE src.page_id = pl.pl_from AND dst.page_id = pl.pl_to AND (src.page_id = $page_id OR dst.page_id = $page_id);";

$results = mysql_query($query);
$row = mysql_fetch_array($results);

$info = array();
$links = array();

// Loop through the results to populate our arrays
while($row) {
  $src_id = (int)$row["src_id"];
  $dst_id = (int)$row["dst_id"];

  // Store title and length for pages
  if (!isset($info[$src_id]))
    $info[$src_id] = array("title" => $row["src_title"], "len" => (int)$row["src_len"]);
  if (!isset($info[$dst_id]))
    $info[$dst_id] = array("title" => $row["dst_title"], "len" => (int)$row["dst_len"]);

  // Store links from src -> dst
  if (!isset($links[$src_id]))
    $links[$src_id] = array();
  $links[$src_id][$dst_id] = true;


  $row = mysql_fetch_array($results);
}

// Now generate XML
?>
<graph center="<?= $page_id ?>">
<?php
  foreach ($info as $id => $i) {
?>
  <source id="<?= $id ?>" title="<?= $i["title"] ?>" len="<?= $i["len"] ?>">
<?php
  if (isset($links[$id]))
      foreach ($links[$id] as $dst => $_) {
	// Strength of a link is 1 if unidirectional
	// 2 if bidirectional
        $str = 1;
	if (isset($links[$dst]) && isset($links[$dst][$id]))
	  $str = 2;
?>
    <dest id="<?= $dst ?>" str="<?= $str  ?>"/>
<?php
    }
?>
  </source>
<?php
}
?>
</graph>
