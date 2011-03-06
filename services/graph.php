<?php
/*
  WikiGraph
  Copyright (c) 2011

  Author: Rob McClure <mgracecubs@gmail.com>

  Graph service
  Currently only implements one level of link depth
*/
	
require_once('config.php');
require_once('util.php');

if (count($argv) == 2)
  $_REQUEST["id"] = $argv[1];

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
    $graph[$dst] = array($page_id => true);
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
      ?>
      <dest id="<?= $dst ?>"/>
      <?php
    }
  ?>
  </source>
  <?php
}
?>
</graph>
