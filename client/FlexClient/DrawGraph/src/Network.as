package  
{
	
	/**
	 * This class makes *all* of the requests to the data services api.
	 * 
	 * @author Michael Rush
	 */
	public class Network 
	{
		
		import mx.rpc.AsyncToken;
		import mx.rpc.Responder;
		import mx.rpc.events.FaultEvent;
		import mx.rpc.events.ResultEvent;
		import mx.rpc.http.HTTPService;
		
		import Config;
		
		private static var service : HTTPService = new HTTPService();
		
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
			
			// Cancel any remaining requests
			service.cancel();
			
			// Set the request url and response type
			service.url = Config.apiUrl + url;
			service.resultFormat = "xml";
			
			// Readonly api only recognizes GET requests
			service.method = "GET";
			
			var token : AsyncToken = service.send();
			token.addResponder(new Responder(function (event : ResultEvent) : void
				{
					
					trace("apiRequest -> COMPLETE");
					
					var x : Object = event.result;
					successCb(new XML(event.result));
				}
				, function (event:FaultEvent) : void
				{
					trace("apiRequest -> IO_ERROR");
					
					failureCb(event.fault.faultString);
				}));
			
		}
		
	}

}