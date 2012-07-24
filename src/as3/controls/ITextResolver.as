package as3.controls 
{
	
	/**
	 * ...
	 * @author hbb
	 */
	public interface ITextResolver 
	{
		/**
		 * 通过具体的实现规则，解析给定的字符。
		 * @param	value
		 * @return
		 */
		function resolve(value:String):String;
	}
	
}