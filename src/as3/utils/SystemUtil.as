package as3.utils 
{
	import flash.system.Capabilities;
	/**
	 * ...
	 * @author hbb
	 */
	public class SystemUtil
	{
		/**
		 * 检测swf运行的环境是否是浏览器
		 * @return
		 */
		public static function get isBrowser():Boolean
		{
			switch( Capabilities.playerType.toLowerCase() )
			{
				case 'activex': return true;
				case 'plugin': return true;
				default: return false;
			}
		}
	}

}