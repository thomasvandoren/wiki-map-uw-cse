package AllTestsSuite.tests 
{
	
	import org.flexunit.Assert;
	import spark.components.Group;
	
	//
	// Import source classes.
	// 
	
	import Node;
	
	/**
	 * This class tests all of the function in the Node class.
	 * 
	 * @author Thomas Van Doren
	 */
	public class NodeTests 
	{
		
		[Test(description = "check getX and getY in Node")]
		public function checkXandY() : void
		{
			var testGroup:Group = new Group();
			testGroup.width = 200;
			testGroup.height = 200;
			var testGraph:Graph = new Graph(testGroup, null);
			var angleDiffer:Number = 30;
			var index:Number = 5;
			var testNode:Node = new Node(testGraph, angleDiffer, index);
			testNode.width = 20;
			testNode.height = 20;
			var checkX:Number = testNode.getX(0.4, testNode, 0);
			var checkY:Number = testNode.getY(0.4, testNode, 0);
			var expectedX:Number = ((Math.cos((5 - 1) * 30 + 0)) * 200 * 0.4) + (200 / 2) - 20 / 2;
			var expectedY:Number = ((Math.sin((5 - 1) * 30 + 0)) * 200 * 0.4) + (200 / 2) - 20 / 2;
			Assert.assertEquals(checkX, expectedX);
			Assert.assertEquals(checkY, expectedY);
		}
	}

}