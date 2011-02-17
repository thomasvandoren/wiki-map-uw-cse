package  
{
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.StyleSheet;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import mx.controls.Text;
	import mx.styles.CSSStyleDeclaration;
	import spark.components.Group;
	import spark.components.BorderContainer;
	/**
	 * ...
	 * @author Austin Nakamura
	 */
	public class AbstractToolTip extends BorderContainer 
	{
		public var abstractText:Text;
		public var environment:Group;
		public var abstractTimer:Timer;
		public var tipStyle:StyleSheet;
		public var abStyle:CSSStyleDeclaration
		private function OpenArticle(event:MouseEvent):void
		{
			abstractText.text = "grumble";
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
		//constructor, on creation we'll expand it to call the server for the abstract info
		public function AbstractToolTip(environment:Group) 
		{
			var testing:String = new String();
			//can set the font style with this
			//testing (I'll change it later) will recieve the abstract
			//where it will be formatted
			testing = "<font size = '10'><b>";
			testing += "loading...";;
			testing += "</b></font>";
			//sets the height and width of the toolTip
			this.height = 72;
			this.width = 144;
			//creates the abstract text
			abstractText = new Text();
			abstractText.width = 144;
			abstractText.htmlText = testing;
			abstractText.selectable = false;
			//add elements and events
			addElement(abstractText);
			addEventListener(MouseEvent.CLICK, OpenArticle);
			addEventListener(MouseEvent.MOUSE_OVER, KeepUp);
			addEventListener(MouseEvent.MOUSE_OUT, RestartTimer);
			//setup the timer
			this.abstractTimer = new Timer(1200, 1);
			this.abstractTimer.addEventListener(TimerEvent.TIMER, TimerDing);
			//abstractTimer.start();
		}
		
	}

}