package as3.controls.utils 
{
	import fl.data.DataProvider;
	/**
	 * ...
	 * @author hbb
	 */
	public class DataProviderUtil
	{
		
		public static function indexOf(dp:DataProvider, value:*, key:String='label'):int
		{
			for (var i:int = dp.length; i--; )
			{
				if (dp.getItemAt(i)[key] == value)
					return i;
			}
			return -1;
		}
		
	}

}