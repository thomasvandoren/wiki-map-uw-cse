package AllTestsSuite.tests 
{
	
	import org.flexunit.Assert;
	
	//
	// Import source classes.
	// 
	
	import Parse;
	
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
			
			validateResults(res, expectedGraphResult);
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
			var res : String = Parse.parseAbstract(testAbstractXML);
			
			Assert.assertEquals(res, expectedAbstractString);
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
		private function validateResults(actual:Array, expected:Array) : void
		{
			Assert.failNull("null array returned", actual);
			Assert.assertEquals(actual.length, expected.length);
			
			// Compare all of the value in the array to the expected array
			for (var i : int = 0; i < expected.length; i++)
			{
				Assert.failNull("null array returned", actual[i]);
				Assert.failNull("null array returned", actual[i]);
				
				Assert.assertEquals(actual[i].length, 2);
				Assert.assertEquals(actual[i].length, 2);
				
				Assert.assertEquals(actual[i][0], expected[i][0]);
				Assert.assertEquals(actual[i][1], expected[i][1]);
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
		
		private var expectedAbstractString : String;
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
			
			expectedAbstractString = "More text of importance";
			testAbstractXML = 
				<info id="42">
					<title>Some random title</title>
					<abstract>More text of importance</abstract>
					<link>http://fake/url/here</link>
				</info>;
				
			expectedGraphResult = new Array(
				new Array("42", "A title for all"),
				new Array("17", "Seventeen"),
				new Array("101", "Dalmations"));
			
			testGraphXML = 
				<graph center="42">
					<source id="42" title="A title for all" len="" is_disambiguation="false">
						<dest id="17" str="2"/>
						<dest id="101" str="1"/>
					</source>
					<source id="17" title="Seventeen"></source>
					<source id="101" title="Dalmations"></source>
				</graph>;
		}
		
	}
}