package 
{
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	import worlds.WorldTitle;
	import net.flashpunk.utils.Key;
	
	[Frame(factoryClass = "Preloader")]
	
	/**
	 * ...
	 * @author Dreauw
	 */
	public class Main extends Engine {
		
		public function Main():void {
			super(640, 480);
			//FP.console.enable();
			//FP.console.toggleKey = Key.F1;
			FP.screen.scale = 2;
			FP.world = new WorldTitle();
		}
		
		override public function focusLost():void {
			super.focusLost();
			paused = true;
		}
		
		override public function focusGained():void  {
			super.focusGained();
			paused = false;
		}
		
	}
	
}