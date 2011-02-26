package  
{
	
	import spark.components.Panel;
	
	/**
	 * ...
	 * @author Austin Nakamura
	 */
	public class AbstractToolTip extends Panel 
	{
		
		import flash.events.MouseEvent;
		import flash.events.TimerEvent;
		import flash.utils.Timer;
		import mx.controls.Text;
		import spark.components.Group;
		import flash.net.navigateToURL;
		import flash.net.URLRequest;
		import mx.controls.Alert;
		
		import Network;
		
		public var environment:Group;
		public var abstractTimer:Timer;
		
		private var articleID : String;
		private var articleTitle : String;
		private var articleAbstract : String;
		private var articleLink : String;
		
		private var loading : Boolean;
		
		private var abstractText : Text;
		
		/**
		 * Public setter for article title. Since tooltips are not
		 * redraw, it is important to allow the Node class to set
		 * a new title.
		 */
		public function set setTitle(title : String) : void
		{
			this.articleTitle = title;
		}
		
		/**
		 * Create a new tool tip and requests abstract text from the services.
		 * 
		 * @param	environment
		 * @param	articleTitle
		 * @param	articleID
		 */
		public function AbstractToolTip(environment:Group, articleTitle:String, articleID:String) 
		{
			
			this.title = articleTitle;
			
			// Make the tooltip slightly transparent.
			this.alpha = 0.9;
			
			// Set the article name and id
			this.articleTitle = articleTitle;
			this.articleID = articleID;
			
			// Set the height and width of the toolTip
			this.height = environment.height / 3;
			this.width = environment.width / 3;
			
			// Create the abstract text and set default loading text
			abstractText = new Text();
			abstractText.width = this.width;
			abstractText.selectable = false;
			
			// Set loading and text in tooltip
			this.startLoad();
			this.updateText();
			
			// Add elements and events
			this.addElement(abstractText);
			
			this.addEventListener(MouseEvent.CLICK, OpenArticle);
			this.addEventListener(MouseEvent.MOUSE_OVER, KeepUp);
			this.addEventListener(MouseEvent.MOUSE_OUT, RestartTimer);
			
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
			var result : Abstract = Parse.parseAbstract(data);
			
			this.articleTitle = result.title;
			this.articleAbstract = result.abstract;
			this.articleLink = result.link;
			
			this.stopLoad();
			this.updateText();
		}
		
		/**
		 * Report server error on request failure.
		 * 
		 * @param	data
		 */
		public function reportError(data : String) : void
		{
			Alert.show("Could not contact WikiGraph server");
			
			this.stopLoad();
			this.updateText();
		}
		
		/**
		 * Returns true if the tooltip is currently loading an abstract.
		 * 
		 * @return
		 */
		public function isLoading() : Boolean
		{
			return this.loading;
		}
		
		/**
		 * Sets the Text of the tool tip to be an html string
		 * with title and abstract.
		 * 
		 * @param	information
		 * @return
		 */
		private function updateText() : void
		{
			this.title = this.articleTitle;
			
			var html:String = new String();
			
			html = "<font size = '12'>";
			
			if (this.isLoading())
			{
				html += "loading...";
			}
			else if (this.articleAbstract.length == 0)
			{
				html += "Abstract not available for this article.";
			}
			else
			{
				html += articleAbstract;
			}
			
			html += "</font>";
			
			this.abstractText.htmlText = html;
		}
		
		/**
		 * Indicate that this tooltip is loading.
		 */
		private function startLoad() : void
		{
			this.loading = true;
		}
		
		/**
		 * Indicate that this tooltip is no longer loading.
		 */
		private function stopLoad() : void
		{
			this.loading = false;
		}
		
		/**
		 * Open the article in a new page when tool tip is clicked.
		 * This can only happen when the tooltip is not loading AND
		 * a link exists.
		 * 
		 * @param	event
		 */
		private function OpenArticle(event:MouseEvent):void
		{
			if (!this.isLoading() && this.articleLink)
			{
				navigateToURL(new URLRequest(this.articleLink), "_blank");
			}
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
			this.stopLoad();
			visible = false;
		}
		
	}

}