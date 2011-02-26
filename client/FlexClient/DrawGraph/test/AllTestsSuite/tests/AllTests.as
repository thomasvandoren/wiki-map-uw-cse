package AllTestsSuite.tests 
{
	
	import org.flexunit.Assert;
	
	//
	// Import all of the classes from src/.
	// 
	
	/**
	 * Runs general unit tests.
	 * 
	 * @author Thomas Van Doren
	 */
	public class AllTests 
	{
		
		[Test(description="Simple test")]
		public function simpleTest():void
		{
			Assert.assertTrue(true);
		}
		
	}

}