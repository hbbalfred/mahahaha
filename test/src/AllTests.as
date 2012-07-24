package  
{
	import as3.controls.ProvinceCityAssociatorTest;
	import as3.controls.YMDAssociatorTest;
	import as3.utils.URLRequestUtilTest;
	import asunit.framework.TestSuite;
	
	/**
	 * ...
	 * @author hbb
	 */
	public class AllTests extends TestSuite
	{
		
		public function AllTests() 
		{
			//addTest(new YMDAssociatorTest());
			//addTest(new ProvinceCityAssociatorTest());
			addTest(new URLRequestUtilTest());
		}
		
	}

}