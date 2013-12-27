package qtree {
	import vo.RectVO;

	/**
	 * 四叉树不规则切图
	 * @author Zhangziran
	 *
	 */
	public class QTreeStare extends QTree {
		private var _prs:Vector.<RectVO>;
		private var _prsLen:int;
		private var _spr:RectVO;
		private var _mpr:RectVO;

		public function QTreeStare($w:int, $h:int, $prs:Vector.<RectVO>):void {
			//图片规格
			_prs = $prs;
			_prsLen = _prs.length;

			init();

			super($w, $h);
		}

		private function init():void {
			_spr = new RectVO();
			_mpr = new RectVO();
			for each (var r:RectVO in _prs) {
				if (_spr.w <= 0) {
					_spr.w = r.w;
				} else if (_spr.w > r.w) {
					_spr.w = r.w;
				}
				if (_spr.h <= 0) {
					_spr.h = r.h;
				} else if (_spr.h > r.h) {
					_spr.h = r.h;
				}
				if (_mpr.w <= 0) {
					_mpr.w = r.w;
				} else if (_mpr.w < r.w) {
					_mpr.w = r.w;
				}
				if (_mpr.h <= 0) {
					_mpr.h = r.h
				} else if (_mpr.h < r.h) {
					_mpr.h = r.h;
				}
			}
		}

		//%%%%%%%%%%%%%%%%%%%%%
		//overrides
		//%%%%%%%%%%%%%%%%%%%%%
		override protected function check(rect:QTreeRect):Boolean {
			if (rect.w < _spr.w || rect.h < _spr.h) {
				return false;
			}
			return true;
		}

		/**
		 * 将父节点切分成四个子节点
		 * @param rect 父节点的Rect
		 */
		override protected function cut(rect:QTreeRect):Vector.<QTreeRect> {
			var vec:Vector.<QTreeRect> = new Vector.<QTreeRect>();
			//随机取一种图片大小作为目标
			var pr:RectVO = getRectVO(rect);
			if (pr) {
				//修改二或三象限的WH
				var wh:Array = getRectWH(pr, rect);
				//随机修改目标的象限
				var qr:Array = randomTarget(wh);
				for (var i:int = 0, len:int = qr.length; i < len; i++) {
					var r:QTreeRect = qr[i];
					r.x += rect.x;
					r.y += rect.y;
					if (r.w >= _spr.w && r.h >= _spr.h) {
						vec.push(r);
					} else {
						if (r.w > 0 && r.h > 0) {
							_blank.push(r);
						}
					}
				}
			}

			return vec;
		}

		private function randomTarget(wh:Array):Array {
			var index:int = int(Math.random() * (QTreeEnum.BR + 1));
			index = Math.max(1, index);
			index = Math.min(QTreeEnum.BR, index);
			var r:QTreeRect = new QTreeRect();
			r.is_cut = false;
			r.w = wh[0][0];
			r.h = wh[0][1];
			var r1:QTreeRect = new QTreeRect();
			r1.w = wh[1][0];
			r1.h = wh[1][1];
			var r2:QTreeRect = new QTreeRect();
			r2.w = wh[2][0];
			r2.h = wh[2][1];
			var r3:QTreeRect = new QTreeRect();
			r3.w = wh[3][0];
			r3.h = wh[3][1];
			switch (index) {
				case QTreeEnum.UL:
					r.x = 0;
					r.y = 0;
					r1.y = 0;
					r1.x = r.w;
					r2.x = 0;
					r2.y = r.h;
					r3.y = r1.h;
					r3.x = r2.w;
					break;
				case QTreeEnum.UR:
					r.x = r1.w;
					r.y = 0;
					r1.y = 0;
					r1.x = 0;
					r2.x = r3.w;
					r2.y = r.h;
					r3.y = r1.h;
					r3.x = 0;
					break;
				case QTreeEnum.BL:
					r.x = 0;
					r.y = r2.h;
					r1.x = r.w;
					r1.y = r3.h;
					r2.x = 0;
					r2.y = 0;
					r3.x = r2.w;
					r3.y = 0;
					break;
				case QTreeEnum.BR:
					r3.x = 0;
					r3.y = 0;
					r1.x = 0;
					r1.y = r3.h;
					r2.y = 0;
					r2.x = r3.w;
					r.x = r1.w;
					r.y = r2.h;
					break;
			}
			return [r, r1, r2, r3];
		}

		//获取四个象限宽高
		private function getRectWH(r:RectVO, rect:QTreeRect):Array {
			if (r.w > r.h) {
				var wh:Array = getRectW(r.w, r.h, rect.w - r.w, rect.h - r.h);
			} else if (r.w < r.h) {
				wh = getRectH(r.w, r.h, rect.w - r.w, rect.h - r.h);
			} else if (Math.random() > 0.5) {
				wh = getRectW(r.w, r.h, rect.w - r.w, rect.h - r.h);
			} else {
				wh = getRectH(r.w, r.h, rect.w - r.w, rect.h - r.h);
			}
			return wh;
		}

		//修改第二象限高
		private function getRectW(w:int, h:int, w1:int, h1:int):Array {
			if (h1 > _mpr.h) {
				var w2:int = w1;
				var h2:int = int((h1 + h) / 2);
				h2 = h2 - h2 % _spr.h;
				var w3:int = w;
				var h3:int = h1;
				h1 = h + h1 - h2;
				return [[w, h], [w2, h2], [w3, h3], [w1, h1]];
			} else {
				return [[w, h], [w1, h], [w, h1], [w1, h1]];
			}
		}

		//修改第三象限宽
		private function getRectH(w:int, h:int, w1:int, h1:int):Array {
			if (w1 > _mpr.w) {
				var w2:int = w1;
				var h2:int = h;
				var w3:int = int((w1 + w) / 2);
				w3 = w3 - w3 % _spr.w;
				var h3:int = h1;
				w1 = w + w1 - w3;
				return [[w, h], [w2, h2], [w3, h3], [w1, h1]];
			} else {
				return [[w, h], [w1, h], [w, h1], [w1, h1]];
			}
		}

		//随机取一种图片大小
		private function getRectVO(rect:QTreeRect):RectVO {
			var tmp:Vector.<RectVO> = new Vector.<RectVO>();
			for (var i:int = 0; i < _prsLen; i++) {
				var r:RectVO = _prs[i];
				if (r.w <= rect.w && r.h <= rect.h) {
					if (!(r.w == rect.w && r.h == rect.h)) {
						tmp.push(r);
					}
				}
			}
			var prsCurrLen:int = tmp.length;
			if (prsCurrLen == 0) {
				return null;
			}
			var index:int = int(Math.random() * (prsCurrLen + 1)) - 1;
			index = Math.max(0, index);
			index = Math.min(prsCurrLen - 1, index);
			var pr:RectVO = tmp[index];
			tmp = null;
			return pr;
		}
	}
}
