<?php
/*
WikiGraph
Copyright (c) 2011

Author: Rob McClure <mgracecubs@gmail.com>

Graph service
Currently only implements one level of link depth

TODO: This could probably be cleaned up a bit
      since the format of returned links is much nicer
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
$ids = array($page_id);
$graph = array();
$graph[$page_id] = array();
foreach ($link_data as $link) {
  $dst = (int)($link['plc_to']);
  array_push($ids, $dst);
  if ((int)($link['plc_out']) == 1) {
    $graph[$page_id][$dst] = true;
  }

  if ((int)($link['plc_in']) == 1) {
    if (!isset($graph[$dst]))
      $graph[$dst] = array();
    $graph[$dst][$page_id] = true;
  }
}

$pages = array();
$page_data = $db->get_page_info($ids);
foreach ($page_data as $page) {
  $id = (int)($page['page_id']);
  $pages[$id] = array("title" => $page['page_title'],
		      "len" => $page['page_len'],
		      "is_ambig" => $page['page_is_ambiguous']
		      );
}

// Now generate XML
header('Content-Type:text/xml');
print("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
?>
<graph center="<?= $page_id ?>"
 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
 xsi:noNamespaceSchemaLocation="graph.xsd">
<?php
  foreach ($ids as $id) {
  $page = $pages[$id];
?>
  <source id="<?= $id ?>" title="<?= htmlspecialchars($page["title"], ENT_QUOTES) ?>" len="<?= $page["len"] ?>" is_disambiguation="<?= $page["is_ambig"] ?>">
<?php
  if (isset($graph[$id]))
      foreach ($graph[$id] as $dst => $_) {
	if (in_array($dst, $ids)) {
	  // Strength of a link is 1 if unidirectional
	  // 2 if bidirectional
	  $str = 1;
	  if (isset($graph[$dst]) && isset($graph[$dst][$id]))
	    $str = 2;
?>
    <dest id="<?= $dst ?>" str="<?= $str  ?>"/>
<?php
	}
      }
?>
  </source>
<?php
}
?>
</graph>
