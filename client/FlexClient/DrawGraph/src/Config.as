package  
{
	/**
	 * Provides an easy interface to quickly change wiki usage
	 * 
	 * @author Austin Nakamura
	 */
	public class Config 
	{
		
		// The base url for wikigraph.
		public static var baseUrl : String = "http://wikigraph.cs.washington.edu";
		
		// The relative services path.
		public static var apiPath : String = "/test-api/";
		
		// The api url for accessing the services.
		public static var apiUrl : String = baseUrl + apiPath;
		
		// Deprecated name...
		public static var dataPath : String = "http://wikigraph.cs.washington.edu/test-api/";
		
		// The article url base.
		public static var wikiPath : String = "http://en.wikipedia.org/wiki/";
		
	}
}