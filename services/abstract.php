<?php
/*
WikiGraph
Copyright (c) 2011

Author: Rob McClure <mgracecubs@gmail.com>

Abstract service
Takes a page id (id)
Returns the title, abstract, and link

TODO: Link depends on which database is used
      but is currently hardcoded to en.wikibooks
TODO: Page might be valid, but it might not have an abstract?

*/

include 'config.php';
include 'util.php';

// Die if no ID provided
if (!isset($_REQUEST["id"])) {
  header("HTTP/1.1 400 Bad Request");
  die("HTTP error 400 occurred: No id provided\n");
}

$db = new GraphDB($DB_HOST, $DB_USER, $DB_PASS, $DB_NAME);

$page_id = (int)($_REQUEST["id"]);

// Die if invalid ID provided (cast returns 0)
if ($page_id == 0) {
  header("HTTP/1.1 400 Bad Request");
  die("HTTP error 400 occurred: Invalid id provided ($page_id)\n");
}

$abstract_results = $db->get_abstract($page_id);
$page_results = $db->get_page_info($page_id);

if (count($page_results) == 1) {

  //TODO: miscellaneous wiki styles need to be removed. The most common is [] 
  //      that are supposed to indicate a link.

  header('Content-Type:text/xml');
  print("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
?>
<info id="<?= $page_id ?>">
  <title><?= $page_results[0]["page_title"] ?></title>
<?php
   if (count($abstract_results) == 1) {
?>
  <abstract><?= $abstract_results[0]["abstract_text"] ?></abstract>
<?php
   } else {
?>
  <abstract>No abstract found.</abstract>
<?php
   }
?>
  <link><?= $LINK_URL . $page_results[0]["page_title"] ?></link>
</info>

<?php
} else {
  header("HTTP/1.1 404 File Not Found");
  die("HTTP error 404 occurred: Page not found ($page_id)\n");
}
?>

