package  
{
	import flash.events.MouseEvent;
	import mx.controls.Button;
	
	/**
	 * ...
	 * @author Austin Nakamura
	 */
	public class Node extends Button 
	{	
		private function ChangeLabel(event:MouseEvent):void
		{
			label = "lolol";
		}
		public function Node() 
		{
			addEventListener(MouseEvent.CLICK, ChangeLabel);
		}
	}
}