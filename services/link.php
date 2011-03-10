<?php
/*
  WikiGraph
  Copyright (c) 2011

  Author: Rob McClure (mgracecubs@gmail.com)

  Link service
  Redirects to the correct site, based on the
  query and base url
*/

require_once('config.php');
require_once('util.php');

if (!isset($_REQUEST["q"]) || strlen($_REQUEST["q"]) == 0) {
      error(400, "No query provided\n");
}

$url = $LINK_URL . urlencode(str_replace(" ", "_", $_REQUEST['q']));
header("Location: $url");
?>
