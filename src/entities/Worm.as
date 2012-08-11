package entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import utils.Resource;
	import utils.Particle;
	
	/**
	 * ...
	 * @author Dreauw
	 */
	public class Worm extends  EntityBase {
		private var life : Number = 2;
		private var dir : Number = 0;
		private var moveTimer : Number = 4;
		private var collideStart : Number = 0;
		private var resetCollide : Boolean = false;
		
		public function Worm(x : Number, yS : Number) : void {
			graphic = new Image(Resource.WORM);
			setHitbox(5, 36);
			this.x = x;
			this.y = yS;
			type = "mob";
		}
		
		override public function update():void {
			// IA
			moveTimer -= FP.elapsed;
			if (moveTimer <= 0) {
				dir = (dir == 1 ? 2 : 1);
				moveTimer = 4;
				collideStart = 0;
			}
			
			if (dir == 1) {
				acceleration.y = 200;	
			} else if (dir == 2) {
				acceleration.y  = -200;
			}
			
			// Hit
			var bullet : Entity = collide("bullet", x, y) as Entity;
			if (bullet) {
				Particle.emit("blood", bullet.x, bullet.y, 5);
				world.remove(bullet);
				life -= 1;
			}
			if (life <= 0) {
				world.remove(this);
			}
			if (collideStart != 0) resetCollide = true;
			super.update();
			if (resetCollide) collideStart = 0;
		}
		
		override public function moveCollideY(e:Entity):Boolean {
			/*
			resetCollide = false;
			if (collideStart == 0) collideStart = y;
			if (Math.abs(collideStart - y) < height) {
				return false;
			}
			*/
			return super.moveCollideY(e);
		}
		
	}

}