package AllTestsSuite.tests 
{
	
	import org.flexunit.Assert;
	
	//
	// Import source classes.
	// 
	
	import Parse;
	import Abstract;
	
	/**
	 * This class tests all of the function in the Parse class.
	 * 
	 * @author Thomas Van Doren
	 */
	public class ParseTests 
	{
		
		/**
		 * Tests that Parse.parseGraph returns the expected result for
		 * a graph like xml document.
		 */
		[Test(description = "Test that Parse.parseGraph returns the expected array")]
		public function testParseGraph() : void
		{
			var res : Array = Parse.parseGraph(testGraphXML);
			
			validateResults(res, expectedGraphResult, true);
		}
		
		/**
		 * Test that Parse.parseGraph throws an error when receiving an invalid
		 * graph xml document.
		 */
		[Test(description = "Test that Parse.parseGraph throw error with invalid xml", expects = "Error")]
		public function testParseGraphError() : void
		{
			Parse.parseGraph(simpleXML);
		}
		
		/**
		 * Tests that parseAbstract returns the correct values.
		 */
		[Test(description = "Test that Parse.parseAbstract returns expected String.")]
		public function testParseAbstract() : void
		{
			var res : Abstract = Parse.parseAbstract(testAbstractXML);
			
			Assert.assertNotNull(res);
			
			Assert.assertEquals(expectedAbstractObj.title, res.title);
			Assert.assertEquals(expectedAbstractObj.abstract, res.abstract);
			Assert.assertEquals(expectedAbstractObj.link, res.link);
		}
		
		/**
		 * Test that parseAbstract throws an error on invalid xml entries.
		 */
		[Test(description = "Test that Parse.parseAbsract throws Error for invalid xml", expects = "Error")]
		public function testParseAbstractError() : void
		{
			Parse.parseAbstract(simpleXML);
		}
		
		/**
		 * Test that an error is thrown for missing title in abstract xml.
		 */
		[Test(description = "Test that Parse.parseAbstract throws Error for bad abstract xml", expects = "Error")]
		public function testParseAbstractTitleError() : void
		{
			Parse.parseAbstract(
				<info>
					<abstract></abstract>
					<link></link>
				</info>);
		}
		
		/**
		 * Test that an error is thrown for missing abstract in abstract xml.
		 */
		[Test(description = "Test that Parse.parseAbstract throws Error for bad abstract xml", expects = "Error")]
		public function testParseAbstractAbstractError() : void
		{
			Parse.parseAbstract(
				<info>
					<title></title>
					<link></link>
				</info>);
		}
		
		/**
		 * Test that an error is thrown for missing link in abstract xml.
		 */
		[Test(description = "Test that Parse.parseAbstract throws Error for bad abstract xml", expects = "Error")]
		public function testParseAbstractLinkError() : void
		{
			Parse.parseAbstract(
				<info>
					<title></title>
					<abstract></abstract>
				</info>);
		}
		
		/**
		 * Makes a call to parseXML with autocomplete like results.
		 * Validates that parseXML returned the correct results.
		 */
		[Test(description = "Test that Parse.parseAutocompleteXML returns valid array for autocomplete xml")]
		public function testParseAutocompleteXML() : void
		{
			var res : Array = Parse.parseAutoComplete(testAutocompleteXML);
			
			Assert.failNull("null result returned", res);
			Assert.assertTrue(res is Array);
		}
		
		/**
		 * Makes an invalid call to parseAutocompleteXML.
		 */
		[Test(description = "Test that Parse.parseAutocompleteXML throws Error on invalid xml", expects = "Error")]
		public function testParseAutocompleteErrorXML() : void
		{
			Parse.parseAutoComplete(simpleXML);
		}
		
		/**
		 * Makes a call to parseSearch with search like results.
		 * Validates that parseSearch returned the correct results.
		 */
		[Test(description = "Test that Parse.parseXML returns valid array for search xml")]
		public function testParseSearchXML() : void
		{
			var res : Array = Parse.parseSearch(testSearchXML);
			
			Assert.failNull("null result returned", res);
			Assert.assertTrue(res is Array);
		}
		
		/**
		 * Makes an invalid call to parseAutocompleteXML.
		 */
		[Test(description = "Test that Parse.parseAutocompleteXML throws Error on invalid xml", expects = "Error")]
		public function testParseSearchErrorXML() : void
		{
			Parse.parseSearch(simpleXML);
		}
		
		/**
		 * Test that results from Parse.parseAutoComplete and parseSearch are correct.
		 */
		[Test(description = "Test that results returned from autocomplete and search are valid arrays")]
		public function testParseAutocompleteSearchResults() : void
		{
			var aResults : Array = Parse.parseAutoComplete(testAutocompleteXML);
			validateResults(aResults, expectedSearchAutocompleteArray);
			
			var bResults : Array = Parse.parseSearch(testSearchXML);
			validateResults(bResults, expectedSearchAutocompleteArray);
		}
		
		/**
		 * Test that the results from parseSearch, parseAutoComplete, and parseGraph
		 * match the expected values.
		 * 
		 * @param	expected
		 * @param	actual
		 */
		private function validateResults(actual : Array, expected : Array, isGraph : Boolean = false) : void
		{
			Assert.failNull("null array returned", actual);
			Assert.assertEquals(actual.length, expected.length);
			
			// Compare all of the value in the array to the expected array
			for (var i : int = 0; i < expected.length; i++)
			{
				Assert.failNull("null array returned", actual[i]);
				Assert.failNull("null array returned", actual[i]);
				
				Assert.assertEquals(actual[i].length, expected[i].length);
				Assert.assertEquals(actual[i].length, expected[i].length);
				
				Assert.assertEquals(actual[i][0], expected[i][0]);
				Assert.assertEquals(actual[i][1], expected[i][1]);
				
				//extended check for graph parser
				if (isGraph) {
					Assert.assertEquals(actual[i][2], expected[i][2]);
					Assert.assertEquals(actual[i][3].length, expected[i][3].length);
					
					// Check that destination ids are equivalent
					for (var j : int = 0; j < expected[i][3].length; j++) 
					{
						Assert.assertEquals((actual[i][3])[j], (expected[i][3])[j]);
					}
				}
			}
			
		}
		
		//
		// Define the test values and the expected values.
		//
		
		private var simpleXML : XML;
		private var simpleListXML : XML;
		private var testSearchXML : XML;
		private var testAutocompleteXML : XML;
		private var testAbstractXML : XML;
		private var testGraphXML : XML;
		
		private var expectedAbstractObj : Abstract;
		private var expectedSearchResult : Array;
		private var expectedAutocompleteResult : Array;
		private var expectedGraphResult : Array;
		
		private var expectedSearchAutocompleteArray : Array = new Array(
				new Array("42", "now"),
				new Array("17", "cow"));
		
		/**
		 * Creates the necessary XML objects to test on.
		 */
		[Before]
		public function setupXML() : void
		{
			simpleXML = 
				<b></b>;
				
			simpleListXML =
				<list>
					<item />
					<item />
				</list>;
			
			expectedSearchResult = expectedSearchAutocompleteArray;
			testSearchXML = 
				<search query="what">
					<item id="42" title="now" />
					<item id="17" title="cow" />
				</search>;
				
			expectedAutocompleteResult = expectedAutocompleteResult;
			testAutocompleteXML =
				<list phrase="what">
					<item id="42" title="now" />
					<item id="17" title="cow" />
				</list>;
			
			expectedAbstractObj = new Abstract(
				"Some random title", 
				"More text of importance", 
				"http://fake/url/here");
			
			testAbstractXML = 
				<info id="42">
					<title>Some random title</title>
					<abstract>More text of importance</abstract>
					<link>http://fake/url/here</link>
				</info>;
				
			expectedGraphResult = new Array(
				new Array("42", "A title for all", 0, new Array("17", "101")),
				new Array("17", "Seventeen", 0, new Array()),
				new Array("101", "Dalmations", 0, new Array()));
			
			testGraphXML = 
				<graph center="42">
					<source id="42" title="A title for all" len="5" is_disambiguation="0">
						<dest id="17" str="2"/>
						<dest id="101" str="1"/>
					</source>
					<source id="17" title="Seventeen" len="4" is_disambiguation="0"></source>
					<source id="101" title="Dalmations" len="2" is_disambiguation="0"></source>
				</graph>;
		}
		
	}
}