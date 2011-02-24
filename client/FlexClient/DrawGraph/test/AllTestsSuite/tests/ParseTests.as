package AllTestsSuite.tests 
{
	
	import org.flexunit.Assert;
	
	//
	// Import source classes.
	// 
	
	import Parse;
	
	/**
	 * ...
	 * @author Thomas Van Doren
	 */
	public class ParseTests 
	{
		
		/**
		 * Makes a call to parseXML with autocomplete like results.
		 * Validates that parseXML returned the correct results.
		 */
		[Test(description = "Test that Parse.parseXML returns valid array for autocomplete xml")]
		public function testParseAutoXML() : void
		{
			var res : Array = Parse.parseXML(testAutocompleteXML);
			
			validateResults(res);
		}
		
		/**
		 * Makes a call to parseXML with search like results.
		 * Validates that parseXML returned the correct results.
		 */
		[Test(description = "Test that Parse.parseXML returns valid array for search xml")]
		public function testParseSearchXML() : void
		{
			var res : Array = Parse.parseXML(testSearchXML);
			
			validateResults(res);
		}
		
		/**
		 * Test that the results from parseXML match the expected values.
		 * 
		 * @param	res
		 */
		private function validateResults(res:Array):void
		{
			Assert.failNull("null array returned", res);
			Assert.assertEquals(res.length, expectedSearchAutocompleteArray.length);
			
			// Compare all of the value in the array to the expected array
			for (var i : int = 0; i < expectedSearchAutocompleteArray.length; i++)
			{
				Assert.failNull("null array returned", res[i]);
				Assert.failNull("null array returned", res[i]);
				
				Assert.assertEquals(res[i].length, 2);
				Assert.assertEquals(res[i].length, 2);
				
				Assert.assertEquals(res[i][0], expectedSearchAutocompleteArray[i][0]);
				Assert.assertEquals(res[i][1], expectedSearchAutocompleteArray[i][1]);
			}
			
		}
		
		/**
		 * Tests that parseXML throws an error when unrecognized XML is given to it.
		 */
		[Test(description="Test that Parse.parseXML throws error for malformed XML", expects="Error")]
		public function testParseXMLError() : void
		{
			Parse.parseXML(simpleXML);
		}
		
		/**
		 * Tests that parseXML throws and error if any or the items in the XML object
		 * do not have the correct attributes.
		 */
		[Test(description="Test that Parse.parseXML throws error for list item without id/title attributes", expects="Error")]
		public function testParseXMLAttributeError() : void
		{
			Parse.parseXML(simpleListXML);
		}
		
		[Test(description = "Test that Parse.parseAbs returns expected String.")]
		public function testParseAbs() : void
		{
			var res : String = Parse.parseAbs(testAbstractXML);
			
			Assert.assertEquals(res, expectedAbstractString);
		}
		
		[Test(description = "Test that Parse.parseAbs throws Error for invalid xml", expects = "Error")]
		public function testParseAbsError() : void
		{
			Parse.parseAbs(simpleXML);
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