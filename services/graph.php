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
include 'util.php';

if (!isset($_REQUEST["id"]) || strlen($_REQUEST["id"]) == 0) {
  error(400, "No query provided.\n");
}

// Establish connection to MySQL server and use database.

$db = new GraphDB($DB_HOST, $DB_USER, $DB_PASS, $DB_NAME);

$page_id = (int)($_REQUEST["id"]);

if ($page_id === 0)
{
  error(400, "Invalid ID ($page_id).\n");
}

// Fetch all links with our target page as a source or destination
// including page info (title, length)
$link_data = $db->get_page_links($page_id);
$links = array();
$pages = array();
$pages[$page_id] = null;
foreach ($link_data as $link) {
  $id_from = (int)($link["pl_from"]);
  $id_to = (int)($link["pl_to"]);

  // Set link data
  if (!isset($links[$id_from]))
    $links[$id_from] = array();
  $links[$id_from][$id_to] = true;

  // Update pages to get info for
  $pages[$id_from] = true;
  $pages[$id_to] = true;
}

// Collect all ids to find info for
$ids = array();
foreach ($pages as $id => $_) {
  array_push($ids, $id);
}

// Put page data in array
$page_data =  $db->get_page_info($ids);
foreach ($page_data as $page) {
  $id = (int)($page["page_id"]);
  $pages[$id] = array("title" => $page["page_title"],
		      "len" => $page["page_len"],
		      "is_ambig" => ($page["page_is_ambiguous"] == "1") ? "true" : "false");
}

// If page info for center node isn't set
// then it doesn't exist
if ($pages[$page_id] === null) {
  error(404, "ID not found ($page_id).\n");
}

// Now generate XML
header('Content-Type:text/xml');
print("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
?>
<graph center="<?= $page_id ?>">
<?php
  foreach ($pages as $id => $i) {
?>
  <source id="<?= $id ?>" title="<?= htmlspecialchars($i["title"], ENT_QUOTES) ?>" len="<?= $i["len"] ?>" is_disambiguation="<?= $i["is_ambig"] ?>">
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
