package  
{
	
	import flash.net.URLRequest;
	import spark.components.BorderContainer;
	
	/**
	 * ...
	 * @author Austin Nakamura
	 */
	public class AbstractToolTip extends BorderContainer 
	{
		
		import flash.events.MouseEvent;
		import flash.events.TimerEvent;
		import flash.text.TextFormat;
		import flash.utils.Timer;
		import mx.controls.Button;
		import mx.controls.Text;
		import mx.styles.CSSStyleDeclaration;
		import spark.components.Group;
		import flash.net.navigateToURL;
		import mx.controls.Alert;
		
		import Config;
		import Network;
		
		public static var fontSize:int;
		public var abstractText:Text;
		public var environment:Group;
		public var abstractTimer:Timer;
		public var abStyle:CSSStyleDeclaration;
		public var articleTitle:String;
		public var articleID:String;
		
		/**
		 * Create a new tool tip and requests abstract text from the services.
		 * 
		 * @param	environment
		 * @param	articleTitle
		 * @param	articleID
		 */
		public function AbstractToolTip(environment:Group,articleTitle:String,articleID:String) 
		{
			// Make the tooltip slightly transparent.
			alpha = 0.9;
			
			// Set the article name and id
			this.articleTitle = articleTitle;
			this.articleID = articleID;
			
			// Set the height and width of the toolTip
			this.height = environment.height / 3;
			this.width = environment.width / 3;
			
			// Create the abstract text and set default loading text
			abstractText = new Text();
			abstractText.width = this.width;
			abstractText.htmlText = getAbstractText("loading...");;
			abstractText.selectable = false;
			
			// Add elements and events
			addElement(abstractText);
			addEventListener(MouseEvent.CLICK, OpenArticle);
			addEventListener(MouseEvent.MOUSE_OVER, KeepUp);
			addEventListener(MouseEvent.MOUSE_OUT, RestartTimer);
			
			// Setup the timer
			this.abstractTimer = new Timer(400, 1);
			this.abstractTimer.addEventListener(TimerEvent.TIMER, TimerDing);
			
			// Send request for abstract.
			Network.abstractGet(articleID, setText, reportError);
		}
		
		/**
		 * Receives XML callback for abstract. Sets the abstract text.
		 * 
		 * @param	data
		 */
		public function setText(data : XML) : void
		{
			//TODO: use the *ALL* of the abstract data (link especially).
			abstractText.htmlText = getAbstractText(Parse.parseAbstract(data));
		}
		
		/**
		 * Report server error on request failure.
		 * 
		 * @param	data
		 */
		public function reportError(data : String) : void
		{
			Alert.show("Could not contact WikiGraph server");
		}
		
		/**
		 * Returns an html string with the abstract title and text
		 * to be inserted into the tooltip.
		 * 
		 * @param	information
		 * @return
		 */
		private function getAbstractText(text:String) : String
		{
			var out:String = new String();
			
			out = "<u>Title</u>: <b>" + articleTitle + "</b>";
			out += "<br><br><font size = '12'>";
			out += text;
			out += "</font>";
			
			return out;
		}
		
		/**
		 * Open the article in a new page when tool tip is clicked.
		 * 
		 * @param	event
		 */
		private function OpenArticle(event:MouseEvent):void
		{
			//TODO: use the url from the abstractGet, once parseAbstract is updated.
			navigateToURL(new URLRequest(Config.wikiPath + articleTitle), "_blank");
		}
		
		/**
		 * Restart the timer to keep the tooltip open on mouse over.
		 * 
		 * @param	event
		 */
		private function KeepUp(event:MouseEvent):void
		{
			abstractTimer.reset();
		}
		
		/**
		 * Restart the timer for displaying tooltip.
		 * @param	event
		 */
		private function RestartTimer(event:MouseEvent):void
		{
			
			abstractTimer.start();
		}
		
		/**
		 * Hide element after a certain period.
		 * 
		 * @param	event
		 */
		private function TimerDing(event:TimerEvent):void
		{
			visible = false;
		}
		
	}

}