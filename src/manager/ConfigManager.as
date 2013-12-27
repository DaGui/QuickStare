package manager {
	import flash.utils.Dictionary;

	import vo.PicktureVO;
	import vo.RectVO;

	public class ConfigManager {
		public static var types:Array;
		public static var rects:Dictionary;
		public static var rectVec:Vector.<RectVO>;
		public static var pictures:Dictionary;
		public static var rect_pictures:Dictionary;

		public static function parseConfig():void {
			var xml:XML = initXml();
			types = String(xml.type.@value).split(",");

			rects = new Dictionary();
			rectVec = new Vector.<RectVO>();
			var rl:XMLList = xml.rect;
			for (var i:int = 0, len:int = rl.length(); i < len; i++) {
				var ri:int = rl[i].@id;
				var rw:int = rl[i].@w;
				var rh:int = rl[i].@h;
				var rvo:RectVO = new RectVO();
				rvo.h = rh;
				rvo.w = rw;
				rvo.id = ri;
				rects[ri] = rvo;
				rectVec.push(rvo);
			}

			pictures = new Dictionary();
			rect_pictures = new Dictionary();
			var pl:XMLList = xml.picture;
			for (var j:int = 0, lenp:int = pl.length(); j < lenp; j++) {
				var pi:int = pl[j].@id;
				var pr:int = pl[j].@rect;
				var pt:int = pl[j].@type;
				var pvo:PicktureVO = new PicktureVO();
				pvo.id = pi;
				pvo.rectID = pr;
				pvo.type = pt;
				pictures[pi] = pvo;
				rect_pictures[pr] ||= [];
				rect_pictures[pr].push(pi);
			}
		}

		//简化的XML处理
		private static function initXml():XML {
			return <root>
					<!-- 类型配置 -->
					<type value="1,2,3,4,5,6,7,8,9,10,11,12,13,14,15"/>

					<rect id="4" w="120" h="120"/>
					<rect id="2" w="90" h="120"/>
					<rect id="3" w="120" h="90"/>
					<rect id="1" w="120" h="60"/>
					<rect id="6" w="60" h="120"/>
					<rect id="5" w="90" h="90"/>
					<rect id="7" w="90" h="60"/>
					<rect id="8" w="60" h="90"/>
					<rect id="9" w="60" h="60"/>
					<rect id="10" w="150" h="60"/>
					<rect id="10" w="60" h="180"/>

					<!-- 图片配置-->
					<picture id="1" type="1" rect="1"/>
					<picture id="2" type="2" rect="2"/>
					<picture id="3" type="3" rect="3"/>
					<picture id="4" type="4" rect="4"/>
					<picture id="5" type="5" rect="5"/>
					<picture id="6" type="6" rect="6"/>
					<picture id="7" type="7" rect="7"/>
					<picture id="8" type="8" rect="8"/>
					<picture id="9" type="9" rect="9"/>
					<picture id="10" type="10" rect="10"/>
					<picture id="11" type="11" rect="11"/>
					<picture id="12" type="12" rect="12"/>
					<picture id="13" type="13" rect="13"/>
					<picture id="14" type="14" rect="14"/>
					<picture id="15" type="15" rect="15"/>
					<picture id="16" type="1,2" rect="1"/>
					<picture id="17" type="2,3" rect="2"/>
					<picture id="18" type="3,4" rect="3"/>
					<picture id="19" type="4,5" rect="4"/>
					<picture id="20" type="5,6" rect="5"/>
					<picture id="21" type="6,7" rect="6"/>
					<picture id="22" type="7,8" rect="7"/>
					<picture id="23" type="8,9" rect="8"/>
					<picture id="24" type="9,10" rect="9"/>
					<picture id="25" type="10,11" rect="10"/>
					<picture id="26" type="11,12" rect="11"/>
					<picture id="27" type="12,13" rect="12"/>
					<picture id="28" type="13,14" rect="13"/>
					<picture id="29" type="14,15" rect="14"/>
					<picture id="30" type="15,1" rect="15"/>
				</root>
		}
	}
}
