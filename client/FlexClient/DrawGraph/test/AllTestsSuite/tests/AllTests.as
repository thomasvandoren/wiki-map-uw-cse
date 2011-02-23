package AllTestsSuite.tests 
{
	
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
		
		[Test]
		public function simpleTest():void
		{
			Assert.assertTrue(true);
		}
	}

}