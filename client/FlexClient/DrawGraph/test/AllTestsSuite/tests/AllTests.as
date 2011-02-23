package AllTestsSuite.tests 
{
	
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
		private var testSearchXML : XML;
		private var testAutocompleteXML : XML;
		private var testAbstractXML : XML;
		private var testGraphXML : XML;
		
		public function AllTest() : void
		{
			simpleXML = <b />;
			testSearchXML = 
				<search query="what">
					<item id="42" title="now" />
					<item id="17" title="cow" />
				</search>;
				
			testAutocompleteXML =
				<list phrase="what">
					<item id="42" title="now" />
					<item id="17" title="cow" />
				</autocomplete>;
			
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
		
		[Test(description="Test that Parse.parseXML throws exception for malformed XML", expects="Error")]
		public function testParseXML() : void
		{
			Parse.parseXML(simpleXML);
		}
	}

}