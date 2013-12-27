package {
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.Security;

	import manager.ConfigManager;

	import view.Game;

	[SWF(backgroundColor = "0x0", frameRate = "60")]
	public class QuickStare extends Sprite {
		private var container:Sprite;
		private var game:Game;

		private const HEIGHT:int = 330;
		private const WIDTH:int = 2000;
		private const GAME_WIDTH:int = 600;

		public function QuickStare() {
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.RESIZE, onResize);

			ConfigManager.parseConfig();

			container = new Sprite();
			addChild(container);

			game = new Game(WIDTH, HEIGHT);
			game.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			game.addEventListener(MouseEvent.MOUSE_UP, onUp);
			container.addChild(game);

			var mask:Sprite = new Sprite();
			mask.graphics.beginFill(0xff0000, 1);
			mask.graphics.drawRect(0, 0, GAME_WIDTH, HEIGHT);
			container.addChild(mask);
			game.mask = mask;

			container.y = stage.stageHeight / 2 - HEIGHT / 2;
			container.x = stage.stageWidth / 2 - GAME_WIDTH / 2;
		}

		private var startX:int;

		protected function onUp(event:MouseEvent):void {
			game.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
		}

		protected function onDown(event:MouseEvent):void {
			startX = mouseX;
			game.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
		}

		protected function onMove(event:MouseEvent):void {
			var newX:int = mouseX - startX;
			var newGameX:int = newX + game.x;
			newGameX = Math.min(0, newGameX);
			newGameX = Math.max(GAME_WIDTH - WIDTH, newGameX);
			game.x = newGameX;
			startX = mouseX;
		}

		protected function onResize(event:Event):void {
			container.y = stage.stageHeight / 2 - HEIGHT / 2;
			container.x = stage.stageWidth / 2 - GAME_WIDTH / 2;
		}
	}
}
