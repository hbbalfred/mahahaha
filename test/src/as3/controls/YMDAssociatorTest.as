package as3.controls 
{
	import asunit.framework.TestCase;
	import fl.controls.ComboBox;
	
	/**
	 * ...
	 * @author hbb
	 */
	public class YMDAssociatorTest extends TestCase
	{
		private var yearComboBox:ComboBox;
		private var monthComboBox:ComboBox;
		private var dateComboBox:ComboBox;
		
		public function YMDAssociatorTest(testMethod:String=null) 
		{
			super(testMethod);
		}
		
		override protected function setUp():void 
		{
			super.setUp();
			yearComboBox = new ComboBox();
			monthComboBox = new ComboBox();
			dateComboBox = new ComboBox();
		}
		
		public function testNewYMD():void
		{
			var asso:YMDAssociator = new YMDAssociator(yearComboBox, monthComboBox, dateComboBox);
			assertEquals(asso.year, 0);
			assertEquals(asso.month, 0);
			assertEquals(asso.date, 0);
			assertEquals(asso.yearText, '');
			assertEquals(asso.monthText, '');
			assertEquals(asso.dateText, '');
			assertEquals(asso.yearResolver, asso);
			assertEquals(asso.monthResolver, asso);
			assertEquals(asso.dateResolver, asso);
		}
		
		public function testNewYM():void
		{
			var asso:YMDAssociator = new YMDAssociator(yearComboBox, monthComboBox);
			assertEquals(asso.year, 0);
			assertEquals(asso.month, 0);
			assertEquals(asso.date, new Date().getDate());
		}
		
		public function testNewMD():void
		{
			var asso:YMDAssociator = new YMDAssociator(null, monthComboBox,dateComboBox);
			assertEquals(asso.year, new Date().getFullYear());
			assertEquals(asso.month, 0);
			assertEquals(asso.date, 0);
		}
		
		public function testNewWidthYearRank():void
		{
			var asso:YMDAssociator = new YMDAssociator(
				yearComboBox, monthComboBox, dateComboBox,'请选择', 2010, 1990);
			assertEquals(asso.year, 0);
			assertEquals(asso.month, 0);
			assertEquals(asso.date, 0);
			
			asso.year = 1989;
			assertEquals(asso.year, 0);
			asso.year = 2011;
			assertEquals(asso.year, 0);
			
			asso = new YMDAssociator(
				yearComboBox, monthComboBox, dateComboBox, '请选择', 1400, 1400);
			asso.year = 1399;
			assertEquals(asso.year, 0);
			asso.year = 1401;
			assertEquals(asso.year, 0);
		}
		
		public function testYMD_SetGetYear():void
		{
			var asso:YMDAssociator = new YMDAssociator(yearComboBox, monthComboBox, dateComboBox);
			asso.year = 1949;
			assertEquals(asso.yearText, '1949');
			asso.yearText = '2000';
			assertEquals(asso.year, 2000);
			asso.year = 0;
			assertEquals(asso.year, 2000);
		}
		
		public function testYMD_SetGetMonth():void
		{
			var asso:YMDAssociator = new YMDAssociator(yearComboBox, monthComboBox, dateComboBox);
			asso.month = -1;
			assertEquals(asso.month, 0);
			asso.month = 13;
			assertEquals(asso.month, 0);
			asso.monthText = '6';
			assertEquals(asso.month, 6);
			asso.month = 11;
			assertEquals(asso.monthText, '11');
			asso.month = 0;
			assertEquals(asso.month, 11);
		}
		
		public function testYMD_SetGetDate():void
		{
			var asso:YMDAssociator = new YMDAssociator(yearComboBox, monthComboBox, dateComboBox);
			asso.date = -1;
			assertEquals(asso.date, 0);
			asso.date = 40;
			assertEquals(asso.dateText, '');
			
			asso.year = 2009;
			asso.month = 3;
			assertEquals(asso.date, 0);
			asso.date = 31;
			assertEquals(asso.date, 31);
			asso.month = 2;
			assertEquals(asso.dateText, '');
			asso.date = 28;
			assertEquals(asso.date, 28);
			asso.date = 29;
			assertEquals(asso.date, 28);
			asso.year = 2008;
			assertEquals(asso.date, 28);
			asso.date = 29;
			assertEquals(asso.date, 29);
			asso.date = 0;
			assertEquals(asso.date, 29);
		}
		
		public function testMD_SetGetDate():void
		{
			var asso:YMDAssociator = new YMDAssociator(null, monthComboBox, dateComboBox);
			asso.date = -1;
			assertEquals(asso.date, 0);
			asso.date = 40;
			assertEquals(asso.dateText, '');
			
			asso.year = 2009;
			asso.month = 3;
			assertEquals(asso.date, 0);
			asso.date = 31;
			assertEquals(asso.date, 31);
			asso.month = 2;
			assertEquals(asso.dateText, '');
			asso.date = 28;
			assertEquals(asso.date, 28);
			asso.date = 29;
			assertEquals(asso.date, 28);
			asso.year = 2008;
			assertEquals(asso.date, 28);
			asso.date = 29;
			assertEquals(asso.date, 29);
			asso.date = 0;
			assertEquals(asso.date, 29);
		}
		
	}

}