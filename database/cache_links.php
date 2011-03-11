<?php
/*
WikiGraph
Copyright (c) 2011

Author: Rob McClure <mgracecubs@gmail.com>

Link Cacher
Takes the pagelinks table and caches the top 24
links for each page
*/
require_once("config.php");

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
  global $cur_id, $pages, $cur_links;

  // The page we are searching for
  // should always come first
  if ($a == $cur_id)
    return -1;
  elseif ($b == $cur_id)
    return 1;

  // Calculate strengths of links
  $str_a = 0;
  if (isset($cur_links[$cur_id][$a]))
    $str_a++;
  if (isset($cur_links[$a]) && isset($cur_links[$a][$cur_id]))
    $str_a++;

  $str_b = 0;
  if (isset($cur_links[$cur_id][$b]))
    $str_b++;
  if (isset($cur_links[$b]) && isset($cur_links[$b][$cur_id]))
    $str_b++;
  
  // Compare by link strength, then by page size
  if ($str_a == $str_b)
    return ((int)($pages[$a]['len']) > (int)($pages[$b]['len'])) ?
      -1 : 1;
  else
  
    return ($str_a > $str_b) ? -1 : 1;
}

$cur_id = 0;
$cur_links = null;
$pages = null;

$chunk_size = 10;

$sqlfile = "pagelinks_cache.sql";
$fh = fopen($sqlfile, 'w');

$q = "CREATE TABLE pagelinks_cache (\n"
  .  "  plc_from INT(8),\n"
  .  "  plc_to INT(8),\n"
  .  "  plc_out TINYINT(1),\n"
  .  "  plc_in TINYINT(1),\n"
  .  "  INDEX (plc_from)\n"
  .  ");\n";

fwrite($fh, $q);

$index = 0;
while(true) {
  $cached_links = array();
  mysql_connect($DB_HOST, $DB_USER, $DB_PASS);
  mysql_select_db($DB_NAME);
  $result = mysql_unbuffered_query("SELECT page_id FROM page LIMIT $index, $chunk_size");

  $rows = 0;

  $row = mysql_fetch_array($result);
  $chunk_ids = array();
  while ($row) {
    $id = (int)($row['page_id']);
    array_push($chunk_ids, $id);
    $row = mysql_fetch_array($result);
    $rows++;
  }

  if ($rows == 0)
    break;

  $chunk_links = array();
  $pages = array();
  $ids = array();
  foreach ($chunk_ids as $id) {
    $chunk_links[$id] = array();
    $ids[$id] = array();
    array_push($ids[$id], $id);
  }

  $chunk = implode(',', $chunk_ids);
  $time1 = microtime(true);
  $q = "SELECT pl_from, pl_to FROM pagelinks2 WHERE pl_from IN ($chunk) OR pl_to IN ($chunk)";
  $result_links = mysql_unbuffered_query($q);
  $row_link = mysql_fetch_array($result_links);
  while($row_link) {
    $src = (int)($row_link['pl_from']);
    $dst = (int)($row_link['pl_to']);

    // Process the links if we care about them
    if (isset($chunk_links[$src])) {
      if (!isset($chunk_links[$src][$src]))
	$chunk_links[$src][$src] = array();
      $chunk_links[$src][$src][$dst] = true;
      if (!in_array($dst, $ids[$src]))
	array_push($ids[$src], $dst);
    }
    if (isset($chunk_links[$dst])) {
      if (!isset($chunk_links[$dst][$src]))
	$chunk_links[$dst][$src] = array();
      $chunk_links[$dst][$src][$dst] = true;
      if (!in_array($src, $ids[$dst]))
	array_push($ids[$dst], $src);
    }
    $pages[$src] = null;
    $pages[$dst] = null;
    $row_link = mysql_fetch_array($result_links);
  }
  $time2 = microtime(true);
  print("New time L: " . ($time2 - $time1) . "\n");

  $all_ids = array();
  foreach ($pages as $id => $_) {
      array_push($all_ids, $id);
  }

  $q = "SELECT * FROM page WHERE page_id IN(" . implode(",", $all_ids) . ")";
  $result_pages = mysql_query($q);
  $time3 = microtime(true);
  print("New time P: " . ($time3 - $time2) . "\n");

  $row_pages = mysql_fetch_array($result_pages);
  while ($row_pages) {
    $id = (int)($row_pages["page_id"]);
    $pages[$id] = array("title" => $row_pages["page_title"],
			  "len" => $row_pages["page_len"],
			  "is_ambig" => ($row_pages["page_is_ambiguous"] == "1") ? "true" : "false");
    $row_pages = mysql_fetch_array($result_pages);
  }
  
  $inserts = array();
  foreach ($chunk_ids as $id) {
    $cur_id = $id;
    $cur_links = $chunk_links[$id];
    usort($ids[$id], 'cmp');
    $top_ids = array_splice($ids[$id], 1, 24);
    foreach ($top_ids as $link_id) {
      $to_push = array($link_id, 0, 0);
      if (isset($cur_links[$id][$link_id]))
	$to_push[1] = 1;
      if (isset($cur_links[$link_id]) && isset($cur_links[$link_id][$id]))
	$to_push[2] = 1;
      array_push($inserts, "($id," . implode(",", $to_push) . ")");
    }

    if (count($inserts) > 1000) {
      $q = "INSERT INTO pagelinks_cache VALUES" . implode(",", $inserts) . ";\n";
      fwrite($fh, $q);
      $inserts = array();
    }
  }
  $q = "INSERT INTO pagelinks_cache VALUES" . implode(",", $inserts) . ";\n";
  fwrite($fh, $q);
  
  $index += $rows;

  mysql_close();
}

fclose($fh);
?>