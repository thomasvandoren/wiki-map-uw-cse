package  
{
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import mx.controls.Button;
	import spark.components.Group;
	
	/**
	 * ...
	 * @author Austin Nakamura
	 */
	public class Node extends Button 
	{	
		public var environment:Group;
		public var abstractTimer:Timer;
		private function ChangeLabel(event:MouseEvent):void
		{
			label = "lolol";
		}
		private function GetArticle(event:MouseEvent):void
		{
			abstractTimer.start();
		}
		private function TimerDing(event:TimerEvent):void
		{
			var toolTip:AbstractToolTip = new AbstractToolTip(environment);
			toolTip.x = (this.x) - (this.width);
			toolTip.y = (this.y);
			environment.addElement(toolTip);
		}
		private function StopTimer(event:MouseEvent):void
		{
			abstractTimer.reset();
		}
		public function Node(environment:Group) 
		{
			this.environment = environment;
			this.abstractTimer = new Timer(1500, 1);
			this.abstractTimer.addEventListener(TimerEvent.TIMER, TimerDing);
			addEventListener(MouseEvent.CLICK, ChangeLabel);
			addEventListener(MouseEvent.MOUSE_OVER, GetArticle);
			addEventListener(MouseEvent.MOUSE_OUT, StopTimer);
		}
	}
}