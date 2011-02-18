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

// Die if no ID provided
if (!isset($_REQUEST["id"])) {
  header("HTTP/1.1 400 Bad Request");
  die("HTTP error 400 occurred: No id provided\n");
}

$db = mysql_connect($host, $user, $pass);
mysql_select_db($dbname);

$page_id = mysql_escape_string($_REQUEST["id"]);

// Die if invalid ID provided (cast returns 0)
if ($page_id == 0) {
  header("HTTP/1.1 400 Bad Request");
  die("HTTP error 400 occurred: Invalid id provided ($page_id)\n");
}

// Fetch title and abstract
$query = "SELECT page_title, abstract_text FROM page, abstract WHERE abstract_id = $page_id AND page_id = $page_id;";
$results = mysql_query($query);
$row = mysql_fetch_array($results);

if ($row) {

  //TODO: miscellaneous wiki styles need to be removed. The most common is [] that are supposed to indicate a link.

  header('Content-Type:text/xml');
  print("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
?>
<info id="<?= $page_id ?>">
  <title><?= $row["page_title"] ?></title>
  <abstract><?= $row["abstract_text"] ?></abstract>
  <link><?= $LINK_URL . $row["page_title"] ?></link>
</info>

<?php
} else {
  header("HTTP/1.1 404 File Not Found");
  die("HTTP error 404 occurred: Page not found ($page_id)\n");
}
?>

