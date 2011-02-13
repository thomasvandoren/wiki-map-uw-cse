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

$db = mysql_connect($host, $user, $pass);
mysql_select_db($dbname);

$page_id = isset($_REQUEST["id"]) ? $_REQUEST["id"] : "";
$page_id = mysql_real_escape_string($page_id);

$query = "SELECT page_title, abstract_text FROM page, abstract WHERE abstract_id = $page_id AND page_id = $page_id;";
$results = mysql_query($query);
$row = mysql_fetch_array($results);

if ($row) {
  header('Content-Type:text/xml');
  print("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
?>
<info id="<?= $page_id ?>">
  <title><?= $row["page_title"] ?></title>
  <abstract><?= $row["abstract_text"] ?></abstract>
  <link>http://en.wikibooks.com/wiki/<?= $row["page_title"] ?></link>
</info>

<?php
} else {
  header("HTTP/1.1 404 File Not Found");
  die("HTTP error 404 occurred: Page not found ($page_id)\n");
}
?>

