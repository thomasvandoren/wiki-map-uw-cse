<?php
/*
  WikiGraph
  Copyright (c) 2011

  Author: Jeremy Lenz <no.jeremy1212@gmail.com>

  Search Service
  Takes a search query
  Returns similar page id's with page titles

  TODO: assess link strength
*/

require_once 'config.php';
require_once 'util.php';

//Die if no query provided
if(!isset($_REQUEST["q"])) {
  error(400, "No query provided.\n");
}

$db = new GraphDB($DB_HOST, $DB_USER, $DB_PASS, $DB_NAME);

$searchQuery = $db->escape($_REQUEST["q"]);


//Die if bad query given
if($searchQuery == "") {
  error(400, "Invalid query ($searchQuery)\n");
}

//Fetch wikis search results
$results =  $db->get_search_results($searchQuery);

if (count($results) > 0) {
  $hasExactMatchOrAlone = FALSE;
  $matchID = 0;
  if (count($results) == 1) {
    $hasExactMatchOrAlone = TRUE;
    $matchID = $results[0]["page_id"];    
  }
  foreach ($results as $row) {
    if (strcasecmp($row["page_title"], $searchQuery) == 0) {
      $hasExactMatchOrAlone = TRUE;
      $matchID = $row["page_id"];
    }
  } 

  if ($hasExactMatchOrAlone) {
    header("Location: ../graph/" . $matchID . "/");  
  } else {
    header('Content-Type:text/xml');
    print("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");

  ?>
<search query="<?= htmlspecialchars($searchQuery, ENT_QUOTES) ?>"
 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
 xsi:noNamespaceSchemaLocation="search.xsd">
     <?php			

    foreach ($results as $row) {
    ?>	
  <item id="<?= $row["page_id"] ?>" title="<?= htmlspecialchars($row["page_title"], ENT_QUOTES) ?>"/>	
    <?php
    }
  }
  ?>
</search>

      <?php
//} else if (count($results) == 1) {
//  header("Location: ../graph/" . $results[0]["page_id"] . "/");
} else {
  error(404, "Query not found ($searchQuery).\n");
}
?>
