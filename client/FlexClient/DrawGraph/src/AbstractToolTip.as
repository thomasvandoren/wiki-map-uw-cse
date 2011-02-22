package  
{
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import mx.controls.Button;
	import mx.controls.Text;
	import mx.styles.CSSStyleDeclaration;
	import spark.components.Group;
	import spark.components.BorderContainer;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	/**
	 * ...
	 * @author Austin Nakamura
	 */
	public class AbstractToolTip extends BorderContainer 
	{
		public var abstractText:Text;
		public var environment:Group;
		public var abstractTimer:Timer;
		public var abStyle:CSSStyleDeclaration;
		public var articleTitle:String;
		public var articleID:String;
		public var articleURL:URLRequest;
		public function UpdateAbstract(information:String):void
		{
			var newText:String = new String();
			newText = "<font size = '10'><b>";
			newText += information;
			newText += "</b></font>";
			abstractText.htmlText = newText;
		}
		private function OpenArticle(event:MouseEvent):void
		{
			articleURL = new URLRequest("http://en.wikipedia.org/wiki/" + articleTitle);
			navigateToURL(articleURL, "_blank");
			//abstractText.text = "grumble";
			
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
			visible = false;
		}
		//constructor, on creation we'll expand it to call the server for the abstract info
		public function AbstractToolTip(environment:Group,articleTitle:String,articleID:String) 
		{
			var defaultText:String = new String();
			//can set the font style with this
			//testing (I'll change it later) will recieve the abstract
			//where it will be formatted
			defaultText = "<u>Title</u>: <b>" + articleTitle + "</b>";
			defaultText += "<br><br><font size = '12'>";
			defaultText += "loading...";
			defaultText += "</font>";
			//sets the height and width of the toolTip
			this.height = environment.height/3;
			this.width = environment.width/3;
			//creates the abstract text
			abstractText = new Text();
			abstractText.width = this.width;
			abstractText.htmlText = defaultText;
			abstractText.selectable = false;
			//add elements and events
			addElement(abstractText);
			addEventListener(MouseEvent.CLICK, OpenArticle);
			addEventListener(MouseEvent.MOUSE_OVER, KeepUp);
			addEventListener(MouseEvent.MOUSE_OUT, RestartTimer);
			//setup the timer
			this.abstractTimer = new Timer(400, 1);
			this.abstractTimer.addEventListener(TimerEvent.TIMER, TimerDing);
			//transfer the article name
			this.articleTitle = articleTitle;
			this.articleID = articleID;
			//at this point, start a search for the abstract text
			//once we get it, it will probably return to some function
			//which will update the abstractText object to have the article text in it.
			Network.abstractGet(articleID, environment, this);
		}
		
	}

}