package as3.controls 
{
	import asunit.framework.TestCase;
	import fl.controls.ComboBox;
	
	/**
	 * ...
	 * @author hbb
	 */
	public class ProvinceCityAssociatorTest extends TestCase
	{
		private var provComboBox:ComboBox;
		private var cityComboBox:ComboBox;
		
		public function ProvinceCityAssociatorTest(testMethod:String=null) 
		{
			super(testMethod);
		}
		
		override protected function setUp():void 
		{
			super.setUp();
			provComboBox = new ComboBox();
			cityComboBox = new ComboBox();
		}
		
		public function testNewPC():void
		{
			var asso:ProvinceCityAssociator = new ProvinceCityAssociator(provComboBox, cityComboBox);
			assertEquals(asso.province, '');
			assertEquals(asso.city, '');
			asso.data = ProvinceCityData.xml;
			assertEquals(asso.province, '');
			assertEquals(asso.city, '');
		}
		
		public function testPC_SetGetP():void
		{
			var asso:ProvinceCityAssociator = new ProvinceCityAssociator(provComboBox, cityComboBox);
			asso.province = '北京';
			assertEquals(asso.province, '');
			asso.data = ProvinceCityData.xml;
			asso.province = '上海';
			assertEquals(asso.province, '上海');
			asso.province = 'xxxx';
			assertEquals(asso.province, '上海');
			asso.province = '';
			assertEquals(asso.province, '上海');
		}
		
		public function testPC_SetGetPC():void
		{
			var asso:ProvinceCityAssociator = new ProvinceCityAssociator(provComboBox, cityComboBox);
			asso.data = ProvinceCityData.xml;
			asso.province = '上海';
			assertEquals(asso.city, '');
			asso.city = '闸北';
			assertEquals(asso.city, '闸北');
			asso.city = '新疆';
			assertEquals(asso.city, '闸北');
			asso.city = '';
			assertEquals(asso.city, '闸北');
			assertEquals(asso.province, '上海');
			asso.province = '北京';
			assertEquals(asso.city, '');
		}
		
		
		public function testPC_SetGetCityNoProvince():void
		{
			var asso:ProvinceCityAssociator = new ProvinceCityAssociator(provComboBox, cityComboBox);
			asso.data = ProvinceCityData.xml;
			asso.cityNoProvince = '闸北';
			assertEquals(asso.city, '闸北');
			assertEquals(asso.province, '上海');
			asso.cityNoProvince = '新疆';
			assertEquals(asso.city, '闸北');
			assertEquals(asso.province, '上海');
			asso.cityNoProvince = '苏州';
			assertEquals(asso.city, '苏州');
			assertEquals(asso.province, '江苏');
			asso.cityNoProvince = '';
			assertEquals(asso.city, '苏州');
			assertEquals(asso.province, '江苏');
		}

	}

}