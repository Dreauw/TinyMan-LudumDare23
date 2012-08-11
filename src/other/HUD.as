package other 
{
	import entities.Player;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
    import worlds.WorldGame;
	
	/**
	 * ...
	 * @author Dreauw
	 */
	public class HUD {
		private var life : Text;
		private var world : WorldGame;
		private var pLife : Number = 0;
		private var bonus : Text;
		public function HUD(world:WorldGame) {
			this.world = world;
			life = new Text("Life :");
			life.scrollX = life.scrollY = 0;
			life.y = 224;
			bonus = new Text("");
			bonus.scrollX = life.scrollY = 0;
			bonus.y = 224;
			bonus.x = 300;
			world.addGraphic(life, 0);
			world.addGraphic(bonus);
		}
		
		public function update() : void {
			if (world.player.bonusDuration > 0) {
				bonus.text = Math.floor(world.player.bonusDuration).toString();
			} else if (bonus.text != "") {
				bonus.text = "";
			}
			
			if (world.player.life != pLife) {
				pLife = world.player.life;
				life.text = "Life : " + (world.player.life.toString());
			}
		}
	}

}