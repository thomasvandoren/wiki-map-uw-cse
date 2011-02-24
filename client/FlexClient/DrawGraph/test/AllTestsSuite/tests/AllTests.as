package AllTestsSuite.tests 
{
	
	import org.flexunit.Assert;
	
	//
	// Import all of the classes from src/.
	// 
	
	import AbstractToolTip;
	import Config;
	import CustomAutoComplete;
	import DrawGraph;
	import DrawSplash;
	import Network;
	import Node;
	import Parse;
	
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