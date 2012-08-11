package entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import worlds.WorldGame;
	import utils.Resource;
	import utils.Particle;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Dreauw
	 */
	public class Ant extends EntityBase {
		public var life : Number = 2;
		public var dir : Number = 1;
		public var sprite : Spritemap;
		public function Ant(x : Number, y : Number, poison : Boolean = false) {
			super();
			poisoned = poison;
			sprite = new Spritemap(Resource.ANT, 31, 12);
			sprite.add("run", [0, 1, 0, 2], 5, true);
			sprite.add("stand", [0], 1);
			sprite.play("stand");
			graphic = sprite;
			setHitbox(31, 12);
			this.x = x;
			this.y = y;
			gravity = 600;
			acceleration.y = gravity;
			maxVelocity = new Point(50, 600);
			type = "mob";
			layer = 1;
			if (poisoned) sprite.color = 0x00FF00;
		}
		
		override public function update():void {
			// IA
			if (dir == 2 && (world as WorldGame).map.isTilePassable(x / 16 + 2, y / 16 + 1 )) {
				dir = 1;
			} else if (dir == 1 && (world as WorldGame).map.isTilePassable(x / 16, y / 16 + 1 )) {
				dir = 2;
			}
			
			
			if (dir == 1) {
				moveLeft(30);
				sprite.play("run");
				sprite.flipped = true;
			} else if (dir == 2) {
				moveRight(30);
				sprite.play("run");
				sprite.flipped = false;
			} else {
				sprite.play("stand");
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
			super.update();
		}
		
		override public function moveCollideX(e:Entity):Boolean {
			dir = (dir == 1 ? 2 : 1);
			return super.moveCollideX(e);
		}
		
	}

}