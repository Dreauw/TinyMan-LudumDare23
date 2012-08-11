package entities 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Dreauw
	 */
	public class EntityBase extends Entity {
		protected var velocity : Point = new Point(0, 0);
		protected var maxVelocity : Point = new Point(100, 1000);
		protected var acceleration : Point = new Point(0, 0);
		protected var friction : Number = 0.7;
		protected var gravity : Number = 600;
		protected var onGround : Boolean = false;
		public var poisoned : Boolean;
		
		public function EntityBase() {
			super();
			layer = 1;
		}
		
		public function notMove() : void {
			acceleration.x = 0;
		}
		
		public function moveLeft(nbr:Number) : void {
			if (acceleration.x > 0) acceleration.x = 0;
			acceleration.x -= nbr;
		}
		
		public function moveRight(nbr:Number) : void {
			if (acceleration.x < 0) acceleration.x = 0;
			acceleration.x += nbr;
		}
		
		public function jump(nbr:Number) : void {
			onGround = false;
			velocity.y = -nbr;
		}
		
		override public function update():void {
			
			super.update();
			
			velocity.x += acceleration.x * FP.elapsed;
			velocity.x *= friction;
			
			velocity.y += acceleration.y * FP.elapsed;
			
			if (Math.abs(velocity.y) > Math.abs(maxVelocity.y)) velocity.y = FP.sign(velocity.y) * maxVelocity.y;
			if (Math.abs(velocity.x) > Math.abs(maxVelocity.x)) velocity.x = FP.sign(velocity.x) * maxVelocity.x;
			
			onGround = false;
			moveBy(velocity.x * FP.elapsed, velocity.y * FP.elapsed, "solid");

		}
		
		override public function moveCollideX(e:Entity):Boolean {
			velocity.x = 0;
			acceleration.x = 0;
			return super.moveCollideX(e);
		}
		
		override public function moveCollideY(e:Entity):Boolean {
			// Ceiling
			if (velocity.y < 0) {
				velocity.y = 0
			} else {
				velocity.y = 0;
				acceleration.y = gravity;
				onGround = true;
			}
			return super.moveCollideX(e);
		}
	}

}