package entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import utils.Resource;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Dreauw
	 */
	public class Wasp extends Entity{
		
		public function Wasp()  {
			super();
			graphic = new Image(Resource.RUN_MODE);
			x = FP.camera.x;
			y = 0;
			type = "mob";
			setHitbox(40, 240);
			layer = 0;
		}
		
		override public function update():void {
			super.update();
			x = FP.camera.x;
		}
		
	}

}