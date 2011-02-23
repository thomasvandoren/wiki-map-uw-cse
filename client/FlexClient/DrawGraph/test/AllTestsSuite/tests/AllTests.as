package AllTestsSuite.tests 
{
	
	import flash.system.IMEConversionMode;
	import flashx.textLayout.conversion.ImportExportConfiguration;
	import org.flexunit.Assert;
	
	//
	// Import all of the classes from src/.
	// 
	
	import AbstractToolTip;
	import DrawGraph;
	import Network;
	import Node;
	import Parse;
	
	/**
	 * Runs all of the current unit tests.
	 * 
	 * TODO: modularize the tests
	 * 
	 * @author Thomas Van Doren
	 */
	public class AllTests 
	{
		private var simpleXML : XML;
		private var simpleListXML : XML;
		private var testSearchXML : XML;
		private var testAutocompleteXML : XML;
		private var testAbstractXML : XML;
		private var testGraphXML : XML;
		
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
				
			testSearchXML = 
				<search query="what">
					<item id="42" title="now" />
					<item id="17" title="cow" />
				</search>;
				
			testAutocompleteXML =
				<list phrase="what">
					<item id="42" title="now" />
					<item id="17" title="cow" />
				</list>;
			
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
		
		[Before]
		public function runBeforeEveryTest():void
		{
			// nothing
		}
		
		[After]
		public function runAfterEveryTest():void
		{
			// nothing
		}
		
		[Test(description="Simple test")]
		public function simpleTest():void
		{
			Assert.assertTrue(true);
		}
		
		[Test(description = "Test that Parse.parseXML returns valid array for autocomplete xml")]
		public function testParseXML() : void
		{
			var res : Array = Parse.parseXML(testAutocompleteXML);
			
			Assert.failNull("null array returned", res);
			Assert.assertEquals(res.length, 2);
			
			Assert.failNull("null array returned", res[0]);
			Assert.failNull("null array returned", res[1]);
			
			Assert.assertEquals(res[0].length, 2);
			Assert.assertEquals(res[1].length, 2);
			
			Assert.assertEquals(res[0][0], "42");
			Assert.assertEquals(res[0][1], "now");
						
			Assert.assertEquals(res[1][0], "17");
			Assert.assertEquals(res[1][1], "cow");

		}
		
		[Test(description="Test that Parse.parseXML throws error for malformed XML", expects="Error")]
		public function testParseXMLError() : void
		{
			Parse.parseXML(simpleXML);
		}
		
		[Test(description="Test that Parse.parseXML throws error for list item without id/title attributes", expects="Error")]
		public function testParseXMLAttributeError() : void
		{
			Parse.parseXML(simpleListXML);
		}
	}

}