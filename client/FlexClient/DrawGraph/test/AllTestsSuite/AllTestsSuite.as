package AllTestsSuite 
{
	import AllTestsSuite.tests.*;
	
	/**
	 * This class manages all of the unit test classes.
	 * 
	 * @author Thomas Van Doren
	 */
	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class AllTestsSuite 
	{
		//
		// List all test classes to include in this Suite.
		//
		
		public var allTest : AllTests;
		
		public var parseTest : ParseTests;
	}

}