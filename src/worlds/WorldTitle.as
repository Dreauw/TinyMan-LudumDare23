package worlds 
{
	import net.flashpunk.graphics.Image;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key
	import utils.Resource;
	import net.flashpunk.Sfx;
	
	/**
	 * ...
	 * @author Dreauw
	 */
	public class WorldTitle extends World {
		private var clickText : Text;
		private var title : Text;
		private var song:Sfx = new Sfx(Resource.TITLE_SONG);
		private var clickSfx:SfxrSynth = new SfxrSynth();
		private var titleScreen : Image;
		private var interval : Number = 1;
		
		public function WorldTitle() {
			super();
			song.loop();
			clickText = new Text("Click anywhere", 0, 100);
			clickText.size = 20;
			clickText.x = (640 - clickText.width * 2) / 4;
			clickText.y = 180;
			title = new Text("Tiny Man");
			title.size = 24
			title.x = (640 - title.width * 2) / 4;
			title.y = 130;
			titleScreen = new Image(Resource.TITLE_SCREEN);
			clickSfx.params.setSettingsString(Resource.SELECT);
			addGraphic(titleScreen);
			addGraphic(title);
			addGraphic(clickText);
		}
		
		override public function update():void {
			super.update();
			interval -= FP.elapsed;
			if (interval <= 0) {
				clickText.visible = !clickText.visible;
				interval = 1;
			}
			
			if (Input.mouseReleased) {
				song.stop();
				clickSfx.play();
				FP.world = new WorldGame();
			}
		}
		
	}

}