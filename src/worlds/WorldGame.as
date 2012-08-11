package worlds 
{
	import entities.Map;
	import entities.Player;
	import entities.Wasp;
	import entities.Worm;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.World;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Tilemap;
	import other.Area;
	import other.HUD;
	import utils.Particle;
	import utils.Resource;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import flash.ui.Mouse;
	import net.flashpunk.Sfx;
	import SfxrSynth;
	
	/**
	 * ...
	 * @author Dreauw
	 */
	
	public class WorldGame extends World {
		public var map : Map;
		public var player : Player = new Player();
		private var hud : HUD; 
		private var cursor : Image;
		private var area : Area = new Area();
		private var song:Sfx = new Sfx(Resource.JUNGLE_SONG);
		private var deathOrVictoryText : Text;
		private var deathSfx : SfxrSynth = new SfxrSynth();
		
		public function WorldGame() {
			super();
			deathSfx.params.setSettingsString(Resource.DEATH);
			song.loop();
			FP.screen.color = 0x95C7E8;
			loadMap(Resource.MAP001_0);
			add(player);
			Particle.instance = new Particle();
			addGraphic(Particle.instance, 0);
			hud = new HUD(this);
			// Cursor
			cursor = new Image(Resource.CURSOR);
			addGraphic(cursor, 0);
			Mouse.hide();
			
			// Tutorial
			addGraphic(new Text("  Press SHIFT to change your size", 16, 180, {size : 12}));
			addGraphic(new Text("In normal size you can crush the ant", 16, 190, { size : 12 } ));
			addGraphic(new Text("It's a poisoned ant", 439, 180, { size : 12 } ));
			addGraphic(new Text("   Don't touch !", 439, 190, { size : 12 } ));
			addGraphic(new Text("You need to be small to enter", 620, 180, { size : 12 } ));
			addGraphic(new Text("When your a small, you can't swim", 1213, 180, { size : 12 } ));
			addGraphic(new Text("It's a speed bonus", 1690, 180, { size : 12 } ));
			addGraphic(new Text("Double Jump skill", 2095, 180, { size : 12 } ));
			addGraphic(new Text("Life", 2297, 90, { size : 12 } ));
		}
		
		public function loadMap(tiles : Array) : void {
			if (map) {
				remove(map);
			}
			map = new Map(tiles, [1, 2, 3]);
			add(map);
		}
		
		public function startRunMode() : void {
			song.stop();
			song = new Sfx(Resource.RUN_SONG);
			song.loop();
		}
		
		override public function update():void {
			hud.update();
			cursor.x = mouseX;
			cursor.y = mouseY;
			area.update(this, Math.floor(player.x / 16));
			
			if (player.x / 16 >= 288) {
				// Victory
				if (!deathOrVictoryText) {
					deathOrVictoryText = new Text("Victory !\n Click");
					deathOrVictoryText.scrollX = deathOrVictoryText.scrollY = 0;
					deathOrVictoryText.x = (640 - deathOrVictoryText.width * 2) / 4;
					deathOrVictoryText.y = 100;
					addGraphic(deathOrVictoryText);
					song.stop();
				}
				if (Input.mouseReleased) {
					FP.world = new WorldTitle;
				}
				return;
			}
			
			super.update();
			// GameOver
			if (player.life <= 0) {
				if (!deathOrVictoryText) {
					deathSfx.play();
					song.stop();
					Particle.emit("blood", player.x + player.width / 2, player.y + player.height / 2, 20);
					remove(player);
					deathOrVictoryText = new Text("Game Over\n   Click");
					deathOrVictoryText.scrollX = deathOrVictoryText.scrollY = 0;
					deathOrVictoryText.x = (640 - deathOrVictoryText.width * 2) / 4;
					deathOrVictoryText.y = 100;
					addGraphic(deathOrVictoryText);
				}
				if (Input.mouseReleased) {
					FP.world = new WorldTitle;
				}
				return;
			}
		}
	}

}