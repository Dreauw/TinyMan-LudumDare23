package entities 
{
	import net.flashpunk.Entity;
	import flash.geom.Point;
	import net.flashpunk.graphics.Image;
	import utils.Resource;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Dreauw
	 */
	public class Bullet extends Entity {
		public var speed : Number = 3;
		public var duration : Number = 2;
		private var dir : Point;
		
		public function Bullet(startPoint : Point, targetPoint : Point) {
			graphic = new Image(Resource.BULLET);
			type = "bullet";
			dir = new Point(targetPoint.x - startPoint.x, targetPoint.y - startPoint.y);
			x = startPoint.x;
			y = startPoint.y;
			layer = 4;
		}
		
		override public function update():void {
			super.update();
			duration -= FP.elapsed;
			if (duration <= 0) {
				world.remove(this);
				return;
			}
			dir.normalize(speed);
			moveBy(dir.x, dir.y, "solid");
		}
		
		override public function moveCollideX(e:Entity):Boolean {
			world.remove(this);
			return super.moveCollideX(e);
		}
		
		override public function moveCollideY(e:Entity):Boolean {
			world.remove(this);
			return super.moveCollideY(e);
		}
		
	}

}