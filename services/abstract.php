<?php
/*
WikiGraph
Copyright (c) 2011

Author: Rob McClure <mgracecubs@gmail.com>

Abstract service
Takes a page id (id)
Returns the title, abstract, and link

*/

include 'config.php';
include 'util.php';

// Die if no ID provided
if (!isset($_REQUEST["id"])) {
  error(400, "No id provided\n");
}

$db = new GraphDB($DB_HOST, $DB_USER, $DB_PASS, $DB_NAME);

$page_id = (int)($_REQUEST["id"]);

// Die if invalid ID provided (cast returns 0)
if ($page_id == 0) {
  error(400, "Invalid id provided ($page_id)\n");
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
   <title><?= htmlspecialchars($page_results[0]["page_title"]) ?></title>
<?php
   if (count($abstract_results) == 1) {
?>
<abstract><?= htmlspecialchars($abstract_results[0]["abstract_text"]) ?></abstract>
<?php
   } else {
?>
  <abstract>No abstract found.</abstract>
<?php
   }
?>
  <link><?= $LINK_URL . urlencode(str_replace(" ", "_", $page_results[0]["page_title"])) ?></link>
</info>

<?php
} else {
  error(404, "Page not found ($page_id)\n");
}
?>

