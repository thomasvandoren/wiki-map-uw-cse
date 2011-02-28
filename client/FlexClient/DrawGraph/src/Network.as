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
		
		private static var service : HTTPService;
		private static var lockAbstracts : Boolean;
		
		public static function set serviceProvider(service : HTTPService) : void
		{
			Network.service = service;
		}
		
		/**
		 * Get the lock abstract status.
		 */
		public static function get isLocked() : Boolean
		{
			return Network.lockAbstracts;
		}
		
		/**
		 * Set the lock abstract status.
		 */
		public static function set isLocked(lockValue : Boolean) : void
		{
			Network.lockAbstracts = lockValue;
		}
		
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
			if (!Network.lockAbstracts)
			{
				apiRequest("abstract/" + id + "/", successCb, failureCb);
			}
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
			apiRequest("autocomplete/?q=" + escape(phrase), successCb, failureCb);
		}
		
		/**
		 * Make an async call for graph results.
		 * 
		 * @param	id
		 * @param	successCb
		 * @param	failureCb
		 */
		public static function graphGet(id : String, successCb : Function, failureCb : Function, lockNetwork : Boolean = false) : void
		{
			// Lock abstract calls out while a graph is loading.
			if (lockNetwork)
			{
				Network.lockAbstracts = true;
			}
			
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
			apiRequest("search/?q=" + escape(phrase), successCb, failureCb);
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
			
			if (service == null)
			{
				service = new HTTPService();
			}
			
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
					
					// Unlock Network.
					Network.lockAbstracts = false;
					
					var x : Object = event.result;
					successCb(new XML(event.result));
				}
				, function (event:FaultEvent) : void
				{
					trace("apiRequest -> IO_ERROR");
					
					// Unlock Network.
					Network.lockAbstracts = false;
					
					failureCb(event.fault.faultString);
				}));
			
		}
		
	}

}