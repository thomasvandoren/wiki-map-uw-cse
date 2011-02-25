package AllTestsSuite.tests 
{

	import mx.rpc.http.test.HTTPServiceStub;
	
	import org.flexunit.async.Async;
	import org.flexunit.Assert;
	
	//
	// Import source classes.
	// 
	
	import Network;
	
	/**
	 * This class tests all of the function in the Network class.
	 * 
	 * @author Thomas Van Doren
	 */
	public class NetworkTests 
	{
		
		[Test(async, description = "Test abstractGet function")]
		public function testAbstractGet() : void
		{
			Assert.assertTrue(true);
		}
		
		//
		// Define class vars.
		//
		
		/**
		 * Create a new loader before every test.
		 */
		[Before]
		public function setUp() : void
		{
			
		}
		
		/**
		 * Clear the loader after every test.
		 */
		[After]
		public function tearDown() : void
		{
			
		}
		
	}

}