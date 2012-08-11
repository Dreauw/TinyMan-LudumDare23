package other 
{
	import entities.Bonus;
	import entities.Wasp;
	import entities.Worm;
	import worlds.WorldGame;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import entities.Ant;
	import utils.Resource;
	
	/**
	 * ...
	 * @author Dreauw
	 */
	public class Area {
		private var currentArea : Number = 0;
		private var currentMap : Number = 1;
		public function Area() {
			
		}
		
		public function update(world : WorldGame, x : Number) : void {
			switch(currentMap) {
				case 1:
					updateAreaMap1(world, x);
					break;
			}
		}
		
		private function updateAreaMap1(world : WorldGame, x : Number) : void {
			// Area 1
			if (x > 0 && x < 89 && currentArea != 1) {
				currentArea = 1;
				world.add(new Ant(357, 84));
				world.add(new Ant(564, 100, true));
				world.add(new Ant(925, 196));
				world.add(new Ant(1141, 68));
				world.add(new Worm(915, 64));
				var ant : Ant = new Ant(1007, 116);
				ant.dir = 0;
				ant.sprite.flipped = true;
				world.add(ant);
				world.add(new Ant(1501, 68, true));
				world.add(new Bonus(1736, 118, 0));
				world.add(new Bonus(2144, 166, 1));
				world.add(new Bonus(2306, 70, 2));
				world.add(new Worm(2394, 44));
				world.add(new Ant(2590, 84));
				world.add(new Ant(2799, 164));
				world.add(new Worm(2966, 188));
			}
			
			// Water
			if (x >= 75 && x <= 89) {
				world.player.swim = true;
			} else if (world.player.swim) {
				world.player.swim = false;
			}
			
			// Area 2
			if (x > 199 && currentArea != 2) {
				currentArea = 2;
				world.startRunMode();
				world.add(new Ant(3282, 84));
				world.add(new Ant(3417, 68));
				world.add(new Ant(3537, 212));
				world.add(new Ant(3864, 84));
				world.add(new Ant(4111, 84));
				var antt : Ant = new Ant(4421, 164);
				antt.dir = 0;
				antt.sprite.flipped = true;
				world.add(antt);
				world.add(new Worm(3686, 140));
				world.add(new Bonus(3442, 70, 0));
				world.add(new Bonus(3539, 214, 0));
				world.add(new Bonus(4472, 86, 1));
				world.add(new Wasp());
			}
		}
		
	}

}