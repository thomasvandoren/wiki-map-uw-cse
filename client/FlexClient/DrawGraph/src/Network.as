package  
{
	
	/**
	 * This class makes *all* of the requests to the data services api.
	 * 
	 * @author Michael Rush
	 */
	public class Network 
	{
		import mx.controls.Alert;
		import flash.events.Event;
		import flash.events.IOErrorEvent;
		import flash.net.URLLoader;
		import flash.net.URLRequest;
		
		import Config;
		
		private static var requestLoader : URLLoader;
		
		/**
		 * Make an async request for an abstract.
		 * 
		 * @param	id
		 * @param	successCb
		 * @param	failureCb
		 */
		public static function abstractGet(id : String, successCb : Function, failureCb : Function) : void
		{
			//TODO: validate/sanitize id
			apiRequest("abstract/" + id + "/", successCb, failureCb);
		}
		
		/**
		 * Make an async request for autocomplete results.
		 * 
		 * @param	phrase
		 * @param	successCb
		 * @param	failureCb
		 */
		public static function autocompleteGet(phrase : String, successCb : Function, failureCb : Function) : void
		{
			//TODO: validate/sanitize phrase!
			apiRequest("autocomplete/?q=" + phrase, successCb, failureCb);
		}
		
		/**
		 * Make an async call for graph results.
		 * 
		 * @param	id
		 * @param	successCb
		 * @param	failureCb
		 */
		public static function graphGet(id : String, successCb : Function, failureCb : Function) : void
		{
			//TODO: validate/sanitize id
			apiRequest("graph/" + id + "/", successCb, failureCb);
		}
		
		/**
		 * Make an async request for search results.
		 * 
		 * @param	phrase
		 * @param	successCb
		 * @param	failureCb
		 */
		public static function searchGet(phrase : String, successCb : Function, failureCb : Function) : void
		{
			//TODO: validate/sanitize phrase!
			apiRequest("search/?q=" + phrase, successCb, failureCb);
		}
		
		/**
		 * Makes a request to the specified api url. The url and api type must be set in config.
		 * 
		 * @param	url			The relative api url (e.g. search/?q=My+Favorite+Search)
		 * @param	successCb
		 * @param	failureCb
		 */
		private static function apiRequest(url : String, successCb : Function, failureCb : Function) : void
		{
			trace("apiRequest(" + url + ")");
			
			// Close any remaining requests
			try
			{
				requestLoader.close()
			}
			catch (e : Error)
			{
				// Nothing was loading...
			}
			
			var xmlRequest : URLRequest = new URLRequest(Config.apiUrl + url);
			requestLoader = new URLLoader(xmlRequest);
			
			// Call successCb with XML result when complete.
			requestLoader.addEventListener(Event.COMPLETE, function (event:Event) : void
			{
				trace("apiRequest -> COMPLETE");
				
				successCb(new XML(requestLoader.data));
			});
			
			// Call failureCb with string result if error occurs.
			requestLoader.addEventListener(IOErrorEvent.IO_ERROR, function (event:Event) : void
			{
				trace("apiRequest -> IO_ERROR");
				
				failureCb(requestLoader.data.toString());
			});
			
            requestLoader.load(xmlRequest);
		}
		
	}

}