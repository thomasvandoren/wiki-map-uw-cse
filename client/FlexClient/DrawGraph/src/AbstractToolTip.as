package  
{
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import mx.controls.Text;
	import spark.components.Group;
	
	/**
	 * ...
	 * @author Austin Nakamura
	 */
	public class AbstractToolTip extends Text 
	{
		public var environment:Group;
		public var abstractTimer:Timer;
		private function OpenArticle(event:MouseEvent):void
		{
			text = "grumble";
		}
		private function KeepUp(event:MouseEvent):void
		{
			abstractTimer.reset();
		}
		private function RestartTimer(event:MouseEvent):void
		{
			abstractTimer.start();
		}
		private function TimerDing(event:TimerEvent):void
		{
			alpha = 0;
		}
		public function AbstractToolTip(environment:Group) 
		{
			text = "this should be an abstract";
			addEventListener(MouseEvent.CLICK, OpenArticle);
			addEventListener(MouseEvent.MOUSE_OVER, KeepUp);
			addEventListener(MouseEvent.MOUSE_OUT, RestartTimer);
			this.abstractTimer = new Timer(5000, 1);
			this.abstractTimer.addEventListener(TimerEvent.TIMER, TimerDing);
			abstractTimer.start();
		}
		
	}

}