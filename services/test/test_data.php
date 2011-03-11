<?php
// Pages to insert into the test database
$pages = array(
				array(1, '"Title"', 0, 0, 100),
				array(2, '"Another title"', 0, 0, 200),
				array(3, '"Redirect to title"', 1, 0, 10),
				array(5, '"WikiGraph"', 0, 0, 300),
				array(6, '"WikiGraph Developers"', 0, 0, 100),
				array(8, '"WikiGraph (disambiguation)"', 0, 1, 10),
				array(9, '"Title 2"', 0, 0, 100)
				);
  // Links to insert into the test database
$links = array(
				array(1, 2),
				array(1, 5),
				array(2, 1),
				array(3, 1),
				array(5, 6),
				array(6, 5),
				array(8, 5)
				);
  // Abstracts to insert into the test database
$abstracts = array(
				    array(1, '"A page about something"'),
				    array(5, '"The coolest project ever"'),
				    array(6, '"People working on the coolest project ever"')
				    );
?>