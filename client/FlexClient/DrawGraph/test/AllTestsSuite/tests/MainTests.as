package AllTestsSuite.tests 
{
	
	import org.flexunit.Assert;
	
	//
	// Import source classes.
	// 
	
	import Main;
	
	/**
	 * This class tests all of the function in the Main class.
	 * 
	 * @author Thomas Van Doren
	 */
	public class MainTests 
	{
		
		[Test(description = "filler test..")]
		public function simpleTest() : void
		{
			Assert.assertTrue(true);
		}
		
	}

}