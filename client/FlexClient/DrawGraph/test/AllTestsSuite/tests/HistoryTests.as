package AllTestsSuite.tests 
{
	
	import org.flexunit.Assert;
	import spark.components.Group;
	
	//
	// Import source classes.
	// 
	
	import History;
	
	/**
	 * This class tests all of the function in the History class.
	 * 
	 * @author Michael Rush
	 */
	public class HistoryTests 
	{
		
		/**
		 * Test that history is being properly constructed
		 */
		[Test(description = "Test that History is being properly constructed to be empty")]
		public function testConstruct() : void
		{
			history = new History(testGraph, testEnv);
			Assert.assertTrue(history.getTerms().length == 0);
			Assert.assertTrue(history.getIDs().length == 0);
		}
		
		/**
		 * Test that addRecord adds terms and IDs in the correct order, limited to 10 replacing the LRU, and detecting and updating duplicates
		 */
		[Test(description = "Test that History.addRecord is properly adding terms and IDs in the correct order with correct overflow and duplicate filtering")]
		public function testAddRecord() : void
		{
			history = new History(testGraph, testEnv);
			expectedTerms = ["10", "9", "8", "7", "6", "5", "4", "3", "2", "1"];
			expectedIDs = ["100", "90", "80", "70", "60", "50", "40", "30", "20", "10"];
			
			//Stage 1: Add 10 pairs
			for (var i : int = 1; i < 11; i++) {
				history.addRecord(String(i), String(i * 10));
			}
			
			Assert.assertTrue(history.getTerms().length == 10);
			Assert.assertTrue(history.getIDs().length == 10);
			
			actualTerms = history.getTerms();
			actualIDs = history.getIDs();
			
			while (actualTerms.length > 0) {
				Assert.assertTrue(actualTerms.pop() == expectedTerms.pop());
				Assert.assertTrue(actualIDs.pop() == expectedIDs.pop());
			}
			
			//Stage 2: Catch duplicates
			expectedTerms = ["9", "8", "7", "6", "5", "3", "2", "1", "4", "10"];
			expectedIDs = ["90", "80", "70", "60", "50", "30", "20", "10", "40", "100"];
			
			history.addRecord("4", "40");
			history.addRecord("4", "40");
			history.addRecord("10", "100");
			
			actualTerms = history.getTerms();
			actualIDs = history.getIDs();
			
			while (actualTerms.length > 0) {
				Assert.assertTrue(actualTerms.pop() == expectedTerms.pop());
				Assert.assertTrue(actualIDs.pop() == expectedIDs.pop());
			}
			
			//Stage 3: Limit Results to 10, remove LRU
			expectedTerms = ["7", "6", "5", "3", "2", "1", "4", "10", "11", "12"];
			expectedIDs = ["70", "60", "50", "30", "20", "10", "40", "100", "110", "120"];
			
			history.addRecord("11", "110");
			history.addRecord("12", "120");
			
			actualTerms = history.getTerms();
			actualIDs = history.getIDs();
			
			while (actualTerms.length > 0) {
				Assert.assertTrue(actualTerms.pop() == expectedTerms.pop());
				Assert.assertTrue(actualIDs.pop() == expectedIDs.pop());
			}
		}
		
		/**
		 * Test that removeRecord removes terms and IDs in the correct order, and detecting out of bounds index
		 */
		[Test(description = "Test that History.removeRecord is properly removing terms and IDs in the correct order with correct out of bounds detection")]
		public function testRemoveRecord() : void
		{
			history = new History(testGraph, testEnv);
			expectedTerms = ["10", "9", "8", "7", "6", "5", "4", "3", "2"];
			expectedIDs = ["100", "90", "80", "70", "60", "50", "40", "30", "20"];
			
			for (var i : int = 1; i < 11; i++) {
				history.addRecord(String(i), String(i * 10));
			}
			
			history.removeRecord(9);
			
			actualTerms = history.getTerms();
			actualIDs = history.getIDs();
			while (actualTerms.length > 0) {
				Assert.assertTrue(actualTerms.pop() == expectedTerms.pop());
				Assert.assertTrue(actualIDs.pop() == expectedIDs.pop());
			}
			
			expectedTerms = ["10", "9", "8", "6", "5", "4", "3", "2"];
			expectedIDs = ["100", "90", "80", "60", "50", "40", "30", "20"];
			history.removeRecord(3);
			
			actualTerms = history.getTerms();
			actualIDs = history.getIDs();
			while (actualTerms.length > 0) {
				Assert.assertTrue(actualTerms.pop() == expectedTerms.pop());
				Assert.assertTrue(actualIDs.pop() == expectedIDs.pop());
			}
			
			//Trying to remove an index out of bounds
			expectedTerms = ["10", "9", "8", "6", "5", "4", "3", "2"];
			expectedIDs = ["100", "90", "80", "60", "50", "40", "30", "20"];
			history.removeRecord(8);
			
			actualTerms = history.getTerms();
			actualIDs = history.getIDs();
			while (actualTerms.length > 0) {
				Assert.assertTrue(actualTerms.pop() == expectedTerms.pop());
				Assert.assertTrue(actualIDs.pop() == expectedIDs.pop());
			}
			
		}
		
		
		//
		// Define the test values and the expected values.
		//
		private var history : History;
		private var testGraph : Graph;
		private var testEnv : Group;
		private var actualTerms : Array;
		private var actualIDs : Array;
		private var expectedTerms : Array;
		private var expectedIDs : Array;
		
		[Before]
		public function setupXML() : void
		{
			testGraph = new Graph(new Group(),null);
			testEnv = new Group();
		}
		
	}

}