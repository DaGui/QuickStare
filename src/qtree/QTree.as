package qtree {

	/**
	 * 四叉树规则切图
	 * @author Zhangziran
	 *
	 */
	public class QTree {
		//最终拼图
		protected var _maps:Vector.<QTreeRect>;
		//空白间隙
		protected var _blank:Vector.<QTreeRect>;
		//根节点
		protected var _root:QTreeNode;
		//深度
		protected var _depth:int;

		public function QTree($w:int, $h:int):void {
			_maps = new Vector.<QTreeRect>();
			_blank = new Vector.<QTreeRect>();

			_root = new QTreeNode();

			var rect:QTreeRect = new QTreeRect();
			rect.x = rect.y = 0;
			rect.w = $w;
			rect.h = $h;
			_root.rect = rect;
			_root.level = _depth;
			buildBranch(_root);
		}

		public function dispose():void {

		}

		/**
		 * 创建parent的四个子节点
		 * @param parent 父节点
		 * @param rect 父节点的Rect
		 *
		 */
		protected function buildBranch(parent:QTreeNode):void {
			var rects:Vector.<QTreeRect> = cut(parent.rect);
			var vec:Vector.<QTreeNode> = new Vector.<QTreeNode>();
			var isPutMaps:Boolean;
			for (var i:int = 0, len:int = rects.length; i < len; i++) {
				var rect:QTreeRect = rects[i];
				if (check(rect) == false) {
					continue;
				}
				if(rect.is_cut == false){
					isPutMaps = true;
					_maps.push(rect);
					continue;
				}
				var node:QTreeNode = new QTreeNode();
				node.rect = rect;
				node.level = parent.level + 1;
				if (_depth < node.level) {
					_depth = node.level;
				}
				buildBranch(node);
				vec.push(node);
			}
			if (vec.length == 0 && isPutMaps == false) {
				_maps.push(parent.rect);
			}
			parent.subs = vec;
		}

		protected function check(rect:QTreeRect):Boolean {
			if (rect.w < 100 || rect.h < 100) {
				return false;
			}
			return true;
		}

		/**
		 * 将父节点切分成四个子节点
		 * @param rect 父节点的Rect
		 */
		protected function cut(rect:QTreeRect):Vector.<QTreeRect> {
			var vec:Vector.<QTreeRect> = new Vector.<QTreeRect>();
			var nw:int = rect.w / 2;
			var nh:int = rect.h / 2;
			for (var i:int = i, len:int = 4; i < len; i++) {
				var r:QTreeRect = new QTreeRect();
				r.w = nw;
				r.h = nh;
				switch (i) {
					case 0:
						r.x = rect.x;
						r.y = rect.y;
						break;
					case 1:
						r.x = rect.x + nw;
						r.y = rect.y;
						break;
					case 2:
						r.x = rect.x;
						r.y = rect.y + nh;
						break;
					case 3:
						r.x = rect.x + nw;
						r.y = rect.y + nh;
						break;
				}
				vec.push(r);
			}
			return vec;
		}

		public function get root():QTreeNode {
			return _root;
		}

		public function get depth():int {
			return _depth;
		}

		public function get maps():Vector.<QTreeRect> {
			return _maps;
		}

		public function get blank():Vector.<QTreeRect> {
			return _blank;
		}


	}
}
