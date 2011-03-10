package  
{
	
	import flash.display.MovieClip;
	import mx.core.ByteArrayAsset;
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
		import GIFPlayerComponent;
		import EmbedAssets;
		
		public var environment:Group;
		public var abstractTimer:Timer;
		
		private var articleID : String;
		private var articleTitle : String;
		private var articleAbstract : String;
		public var articleLink : String;
		
		private var loading : Boolean;
		
		private var loaderImg : GIFPlayerComponent;
		private var abstractText : Text;
		
		private var loaderImgSrc : ByteArrayAsset = new EmbedAssets.LOADING_SMALL();
		
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
			this.setStyle("fontSize", 18);
			
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
			abstractText.setStyle("fontSize", 16);
			
			// Add elements and events
			this.addElement(this.abstractText);
			this.createLoaderImg();
			
			this.addEventListener(MouseEvent.CLICK, openArticle);
			this.addEventListener(MouseEvent.MOUSE_OVER, KeepUp);
			this.addEventListener(MouseEvent.MOUSE_OUT, RestartTimer);
			
			// Setup the timer
			this.abstractTimer = new Timer(500, 1);
			this.abstractTimer.addEventListener(TimerEvent.TIMER, TimerDing);
			
			this.getAbstract();
		}
		
		/**
		 * Gets the abstract from the services, if they are not locked.
		 */
		public function getAbstract() : void
		{
			// Set loading and text in tooltip
			this.startLoad();
			this.updateText();
			
			// Send request for abstract.
			if (Network.isLocked)
			{
				this.hide();
			}
			else
			{
				Network.abstractGet(articleID, setText, reportError);
			}
		}
		
		/**
		 * Receives XML callback for abstract. Sets the abstract text.
		 * 
		 * @param	data
		 */
		public function setText(data : XML) : void
		{
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
		 * Create the loading image and add it to the tool tip panel.
		 */
		private function createLoaderImg() : void
		{
			this.loaderImg = new GIFPlayerComponent();
			this.loaderImg.byteArray = this.loaderImgSrc;
			this.addElement(this.loaderImg);
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
			
			var abText:String = new String();
			
			if (this.isLoading())
			{
				abText += "        loading...";
			}
			else if (this.articleAbstract.length == 0)
			{
				abText += "Abstract not available for this article.";
			}
			else
			{
				abText += articleAbstract;
			}
			
			this.abstractText.text = abText;
		}
		
		/**
		 * Indicate that this tooltip is loading.
		 */
		private function startLoad() : void
		{
			this.loaderImg.visible = true;
			this.loading = true;
			
			this.buttonMode = false;
			this.abstractText.useHandCursor = false;
			this.abstractText.buttonMode = false;
			this.abstractText.mouseChildren = false;
		}
		
		/**
		 * Indicate that this tooltip is no longer loading.
		 */
		private function stopLoad() : void
		{
			this.loaderImg.visible = false;
			this.loading = false;
			
			this.buttonMode = true;
			this.abstractText.useHandCursor = true;
			this.abstractText.buttonMode = true;
			this.abstractText.mouseChildren = false;
		}
		
		/**
		 * Open the article in a new page when tool tip is clicked.
		 * This can only happen when the tooltip is not loading AND
		 * a link exists.
		 * 
		 * @param	event
		 */
		public function openArticle(event:MouseEvent):void
		{
			if (!this.isLoading() && this.articleTitle)
			{
				var url : URLRequest = new URLRequest(Config.apiUrl + "link/?q=" + escape(this.articleTitle));
				navigateToURL(url, "_blank");
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
			this.hide();
		}
		
		/**
		 * Hide the tooltip.
		 */
		private function hide() : void
		{
			this.stopLoad();
			visible = false;
		}
		
	}

}