package view {
	import flash.display.Sprite;
	
	import manager.ConfigManager;
	
	import qtree.QTreeRect;
	import qtree.QTreeStare;

	public class Game extends Sprite {
		public function Game(w:int, h:int) {
			graphics.beginFill(0xffffff, 1);
			graphics.drawRect(0, 0, w, h);
			graphics.endFill();

			var tw:int;
			var nw:int = 240 + 30 * int(10 * Math.random());
			var nh:int = 330;
			for (var i:int = 0; i < 10; i++) {
				if(tw + nw > w){
					nw = w - tw;
				}
				var q:QTreeStare = new QTreeStare(nw, nh, ConfigManager.rectVec);
				createSprite(q.maps, tw);
				createSprite(q.blank, tw, 0, 0xff0000);
				q = null;
				tw += nw;
				if(tw >= w){
					break;
				}
			}
		}

		private function createSprite(maps:Vector.<QTreeRect>, startX:int, startY:int = 0, color:uint = 0x0):void {
			for each (var r:QTreeRect in maps) {
				var s:Sprite = getSprite(r, color);
				s.x += startX;
				s.y += startY;
				addChild(s);
			}
		}

		private function getSprite(r:QTreeRect, color:uint = 0x0):Sprite {
			var s:Sprite = new Sprite();
			s.graphics.beginFill(color);
			s.graphics.drawRect(0, 0, r.w - 2, r.h - 2);
			s.graphics.endFill();
			s.x = r.x + 1;
			s.y = r.y + 1;
			return s;
		}
	}
}
