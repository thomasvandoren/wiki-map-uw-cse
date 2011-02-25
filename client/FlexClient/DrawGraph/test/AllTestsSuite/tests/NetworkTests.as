package AllTestsSuite.tests 
{

	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.test.HTTPServiceStub;
	import mx.rpc.Responder;
	
	import org.flexunit.async.Async;
	import org.flexunit.Assert;
	
	//
	// Import source classes.
	// 
	
	import Network;
	import Config;
	
	/**
	 * This class tests all of the functions in the Network class.
	 * 
	 * @author Thomas Van Doren
	 */
	public class NetworkTests 
	{
		
		/**
		 * Test that abstractGet accesses the services.
		 */
		[Test(async, description = "Test abstractGet function")]
		public function testAbstractGet() : void
		{
			testRequestSetup(testAbstractXML);
			
			Network.abstractGet("42", function (data : XML) : void 
				{
					trace ("success");
					
					Assert.assertEquals(testAbstractXML, data);
				}
				, function (data : String) : void
				{
					trace("failure");
					
					Assert.assertFalse(true, "unexpected fault occurred");
				});
		}
		
		/**
		 * Test that autocompleteGet accesses the services.
		 */
		[Test(async, description = "Test autocompleteGet function")]
		public function testAutocompleteGet() : void
		{
			testRequestSetup(testAutocompleteXML);
			
			Network.autocompleteGet("what", function (data : XML) : void 
				{
					trace ("success");
					
					Assert.assertEquals(testAutocompleteXML, data);
				}
				, function (data : String) : void
				{
					trace("failure");
					
					Assert.assertFalse(true, "unexpected fault occurred");
				});
		}
		
		/**
		 * Test that graphGet accesses the services.
		 */
		[Test(async, description = "Test graphGet function")]
		public function testGraphGet() : void
		{
			testRequestSetup(testGraphXML);
			
			Network.graphGet("42", function (data : XML) : void
				{
					Assert.assertEquals(testGraphXML, data);
				}
				, function (data : String) : void
				{
					Assert.assertFalse(true, "unexpected fault occurred");
				});
			
		}
		
		/**
		 * Test that searchGet accesses the services.
		 */
		[Test(async, description = "Test searchGet function")]
		public function testSearchGet() : void
		{
			testRequestSetup(testSearchXML);
			
			Network.searchGet("what", function (data : XML) : void
				{
					Assert.assertEquals(testSearchXML, data);
				}
				, function (data : String) : void
				{
					Assert.assertFalse(true, "unexpected fault occurred");
				});
		}
		
		/**
		 * Test that result returned from services is the expected value.
		 * 
		 * @param	event
		 * @param	passThroughData
		 */
		public function successCb(event : ResultEvent, passThroughData : Object) : void
		{
			Assert.assertEquals(passThroughData, event.result);
		}
		
		/**
		 * Fail if a result was expected, but a timeout occured.
		 * 
		 * @param	passThroughData
		 */
		public function failureCb(passThroughData : Object) : void
		{
			Assert.assertFalse(true, "unexpected failure on service call");
		}
		
		/**
		 * Setup the service and async listener for a single test.
		 * 
		 * @param	expected
		 */
		private function testRequestSetup(expected : XML) : void
		{
			service.result(null, null, "GET", expected);
			
			service.addEventListener(
				ResultEvent.RESULT,
				Async.asyncHandler(this, successCb, 1000, expected, failureCb), 
				false, 
				0, 
				true);
		}
		
		//
		// Define class vars.
		//
		
		private var service : HTTPServiceStub;
		
		//TODO: factor these values into a common class accessible by all test classes.
		
		private var testAbstractXML : XML = 
			<info id="42">
				<title>Some random title</title>
				<abstract>More text of importance</abstract>
				<link>http://fake/url/here</link>
			</info>;
		
		private var testAutocompleteXML : XML =
			<list phrase="what">
				<item id="42" title="now" />
				<item id="17" title="cow" />
			</list>;

		private var testGraphXML : XML = 
			<graph center="42">
				<source id="42" title="A title for all" len="" is_disambiguation="false">
					<dest id="17" str="2"/>
					<dest id="101" str="1"/>
				</source>
				<source id="17" title="Seventeen"></source>
				<source id="101" title="Dalmations"></source>
			</graph>;
				
		private var testSearchXML : XML = 
			<search query="what">
				<item id="42" title="now" />
				<item id="17" title="cow" />
			</search>;
			
		/**
		 * Create a new loader before every test.
		 */
		[Before]
		public function setUp() : void
		{
			service = new HTTPServiceStub();
			service.delay = 500;
			service.resultFormat = "xml";
			service.method = "GET";
			
			Network.serviceProvider = service;
		}
		
		/**
		 * Clear the loader after every test.
		 */
		[After]
		public function tearDown() : void
		{
			service = null;
			Network.serviceProvider = null;
		}
		
	}

}