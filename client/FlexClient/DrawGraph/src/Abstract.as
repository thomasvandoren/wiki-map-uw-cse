package  
{
	/**
	 * This class is used to represent the data in an abstract XML object.
	 * 
	 * @author Thomas Van Doren
	 */
	public class Abstract 
	{
		public var title : String;
		public var abstract : String;
		public var link : String;
		
		/**
		 * Construct a new abstract representation.
		 * 
		 * @param	title
		 * @param	abstract
		 * @param	link
		 */
		public function Abstract(title : String, abstract : String, link : String) 
		{
			this.title = title;
			this.abstract = abstract;
			this.link = link;
		}
		
	}

}