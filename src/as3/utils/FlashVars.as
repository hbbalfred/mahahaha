package as3.utils
{
	public class FlashVars
	{
		private static var data:Object;
		
		/**
		 * 初始化Flashvars，一般情况下将 stage.loaderInfo.parameters 传入。
		 * 此后则无法初始，除非传入强制传入第二个参数为true。
		 * 
		 * @param	data		初始对象。
		 * @param	overwrite	覆盖初始。
		 */
		public static function init( data:Object, overwrite:Boolean = false ):void
		{
			if(!FlashVars.data || overwrite)
				FlashVars.data = data || {};
		}
		
		/**
		 * 是否拥有该Flashvars
		 * @param	name
		 * @return
		 */
		public static function has( name:String ):Boolean
		{
			return name in data;
		}
		
		/**
		 * 取得该Flashvars，没有的话为空。
		 * @param	name
		 * @return
		 */
		public static function getValue( name:String ):String
		{
			return has(name) ? data[name] : '';
		}
		
		/**
		 * 取得该Flashvars，并转成Number，没有或者失败的话为0.
		 * @param	name
		 * @return
		 */
		public static function getValueAsNumber( name:String ):Number
		{
			return has(name) ? parseFloat(data[name]) : 0;
		}
		
	}
}
