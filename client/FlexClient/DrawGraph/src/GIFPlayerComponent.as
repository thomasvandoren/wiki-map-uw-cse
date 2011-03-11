package  
{
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import mx.core.ByteArrayAsset;
	import mx.core.UIComponent;
	import org.bytearray.gif.player.GIFPlayer;
	
	/**
	 * Wrapper for GIFPlayer. This class was created as suggested at:
	 * 
	 * 		http://code.google.com/p/as3gif/wiki/How_to_use
	 * 
	 * @author Thomas Van Doren
	 */
	public class GIFPlayerComponent extends UIComponent
	{
		
		private var m_gif : GIFPlayer = new GIFPlayer();
		private var _url : String;
		private var _byteArray : ByteArray
		
		public function GIFPlayerComponent() 
		{
			super();
			this.addChild( m_gif );
		}
		
		public function get url() : String
		{
			return _url;
		}
		
		/**
		 * Load the gif into the 
		 */
		public function set url(value : String) : void
		{
			_url = value;
			var urlReq : URLRequest = new URLRequest( _url );
			m_gif.load(urlReq);
		}
		
		public function get byteArray() : ByteArray
		{
			return _byteArray
		}
		
		public function set byteArray(value : ByteArray) : void
		{
			_byteArray = value;
			m_gif.loadBytes(_byteArray);
		}
		
	}

}