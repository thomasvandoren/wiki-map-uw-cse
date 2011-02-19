/*
WikiGraph
Copyright (c) 2011

Author: Thomas Van Doren <thomas.vandoren@gmail.com>

This page contains common functions in the WikiGraph
services.

Functions in this file:

  connect_db();
  error($error_number, $error_msg);
  query($query_str);

*/

require_once('config.php');

$mysql_link = null;

/**
 * Close the connection to the database if it is open.
 */
close_db()
{
    if ($mysql_link != null)
    {
	mysql_close($mysql_link);
    }
}

/**
 * Connect to database and use default.
 *
 * Depends on $host and $dbname.
 */
connect_db()
{
    $mysql_link = mysql_connect($host, $user, $pass);

    if (!$mysql_link || !mysql_select_db($dbname))
    {
	error(500, "could not connect to database");
    }
}

/**
 * Kills the current execution and writes the error message to
 * page.
 */
error($error_number, $error_msg)
{
    header("HTTP/1.1 $error_number");
    die("HTTP $error_number : $error_msg");
}

/**
 * Query the database if a connection exists.
 *
 * This assumes that query_str is a sanitized, escaped
 * query string.
 */
query($query_str)
{
    if ($mysql_link != null)
    {
	return mysql_query($query_str, $mysql_link);
    }
    else
    {
	return null;
    }
}