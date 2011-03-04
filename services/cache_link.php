<?php
require_once('config.php');
require_once('util.php');

if (count($argv) != 2)
  die("Usage: php cache_link.php (id)\n");

$db = new GraphDB($DB_HOST, $DB_USER, $DB_PASS, $DB_NAME);
$page_id = $argv[1];

$link_data = $db->get_page_links_full($page_id);
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
  $pages[$id_from] = null;
  $pages[$id_to] = null;
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

if ($pages[$page_id] === null) {
  return;
}

/**
 * Function to compare two nodes
 * in order to sort them by
 * strength
 *
 * Strength is determined by:
 * +1 if this node links to the center
 * +1 if the center links to this node
 *
 * Ties in strength are resolved based
 * on page length
 */
function cmp($a, $b) {
  global $page_id, $pages, $links;

  // The page we are searching for
  // should always come first
  if ($a == $page_id)
    return -1;
  elseif ($b == $page_id)
    return 1;

  // Calculate strengths of links
  $str_a = 0;
  if (isset($links[$page_id][$a]))
    $str_a++;
  if (isset($links[$a]) && isset($links[$a][$page_id]))
    $str_a++;

  $str_b = 0;
  if (isset($links[$page_id][$b]))
    $str_b++;
  if (isset($links[$b]) && isset($links[$b][$page_id]))
    $str_b++;

  // Compare by link strength, then by page size
  if ($str_a == $str_b)
    return ((int)($pages[$a]['len']) > (int)($pages[$b]['len'])) ?
      -1 : 1;
  else
    return ($str_a > $str_b) ? -1 : 1;
}

usort($ids, 'cmp');
// Get the top 24 (+ center) nodes to return
$ids = array_splice($ids, 1, 24);

$inserts = array();
foreach ($ids as $id) {
  $to_push = array($id, 0, 0);
  if (isset($links[$page_id][$id]))
    $to_push[1] = 1;
  if (isset($links[$id]) && isset($links[$id][$page_id]))
    $to_push[2] = 1;
  array_push($inserts, "($page_id," . implode(',', $to_push) . ")");
}

mysql_query("START TRANSACTION");
$result = mysql_query("SELECT * FROM pagelinks_cache WHERE plc_from = $page_id");
if (mysql_num_rows($result) == 0) {
  print("Committing\n");
  mysql_query("INSERT INTO pagelinks_cache VALUES" . implode(",", $inserts));
  mysql_query("COMMIT");
} else {
  print("Not committing\n");
  mysql_query("ROLLBACK");
}
?>
