package as3.utils
{
	public class ArrayUtil
	{
		public static function shuffle( arr:Array ):void
		{
			var t:*, r:int, i:int = 0, ii:int = arr.length;
			for (; i < ii; ++i)
			{
				r = Math.random() * ii;
				t = arr[r];
				arr[r] = arr[i];
				arr[i] = t;
			}
		}
		
		public static function equal(a1:Array, a2:Array):Boolean
		{
			if (a1 == a2) return true;
			if (a1.length != a2.length) return false;
			
			var i:int = 0, ii:int = a1.length;
			for (; i < ii; ++i)
				if (a1[i] != a2[i])
					return false;
			return true;
		}
	}
}