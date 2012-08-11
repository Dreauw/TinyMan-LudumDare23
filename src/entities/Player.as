package entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.FP;
	import flash.geom.Point;
	import utils.Resource;
	import utils.Particle;
	import worlds.WorldGame;
	import worlds.WorldTitle;
	
	/**
	 * ...
	 * @author Dreauw
	 */
	
	public class Player extends EntityBase {
		public var life : Number = 4;
		private var spriteLegs : Spritemap;
		private var spriteSmall : Spritemap;
		private var shootSfx : SfxrSynth = new SfxrSynth();
		private var sizeSfx : SfxrSynth = new SfxrSynth();
		private var getSfx : SfxrSynth = new SfxrSynth();
		private var hurtSfx : SfxrSynth = new SfxrSynth();
		private var small : Boolean = false;
		private var inWall : Boolean = false;
		private var poisonDuration : Number = 0;
		private var poisonCount : Number = 0;
		private var flashDuration : Number = 0;
		private var canFlash : Boolean = true;
		public var swim : Boolean = false;
		private var jumpCount : Number = 1;
		private var bonusId : Number = -1;
		public var bonusDuration : Number = 0;
		
		public function Player() {
			super();
			Input.define("Left", Key.A, Key.LEFT);
			Input.define("Right", Key.D, Key.RIGHT);
			Input.define("Jump", Key.W, Key.UP);
			Input.define("Size", Key.SHIFT, Key.Q);
			x = 64;
			y = 0;
			spriteLegs = new Spritemap(Resource.LEGS, 89, 112);
			spriteLegs.add("run", [0, 1, 0, 2], 5, true);
			spriteLegs.add("stand", [0], 1, true);
			spriteSmall = new Spritemap(Resource.PLAYER, 10, 14);
			spriteSmall.add("run", [0, 1, 0, 2], 5, true);
			spriteSmall.add("stand", [0], 1, true);
			spriteSmall.play("stand");
			setSmall(true);
			maxVelocity = new Point(150, 1000);
			gravity = 600;
			acceleration.y = gravity;
			shootSfx.params.setSettingsString(Resource.SHOOT);
			shootSfx.cacheSound();
			sizeSfx.params.setSettingsString(Resource.SIZE);
			sizeSfx.cacheSound();
			getSfx.params.setSettingsString(Resource.GET);
			getSfx.cacheSound();
			hurtSfx.params.setSettingsString(Resource.HURT);
			hurtSfx.cacheSound();
			layer = 2;
		}
		
		public function flash(duration : Number) : void {
			if (!canFlash) return;
			flashDuration = duration;
			spriteLegs.color = 0xFF8888;
			spriteLegs.alpha = 0.8;
			spriteSmall.color = 0xFF8888;
			spriteSmall.alpha = 0.8;
		}
		
		public function setSmall(small : Boolean) : void {
			if (small != this.small) {
				sizeSfx.play();
				this.small = small;
				if (small) {
					x += width/2
					y = y+112-14;
					graphic = spriteSmall;
					setHitbox(10, 14);
					if (collide("solid", x, y)) {
						flash(2);
						inWall = true;
					} else {
						inWall = false;
					}
				} else {
					x -= 89 / 2;
					if (y < 112-height) {
						y -= 112-height;
					} else {
						y = 0;
					}
					graphic = spriteLegs;
					setHitbox(89, 112);
					if (collide("solid", x, y)) {
						flash(2);
						inWall = true;
					} else {
						inWall = false;
					}
				}
				(graphic as Spritemap).play("stand");
			}
		}
		
		public function updateCamera() : void {
			if (x / 16 > 199 && x / 16 < 289) {
				FP.camera.x += 2;
				return;
			}
			if ((x + width / 2) > FP.screen.width / 4) {
				FP.camera.x = ((x + width / 2) - FP.screen.width / 4);
			}
			/*
			if (((y + height / 2) > FP.screen.height/4) && small) {
				FP.camera.y = ((y + height / 2) - FP.screen.height/4);
			}
			*/
		}
		
		public function poison(count:Number) : void{
			spriteLegs.color = 0x88FF88;
			spriteSmall.color = 0x88FF88;
			poisonCount = count;
			flashDuration = 2;
			poisonDuration = 5;
			canFlash = false;
		}
		
		override public function update():void {
			if (flashDuration > 0 && canFlash) {
				flashDuration -= FP.elapsed;
				if (flashDuration <= 0) {
					spriteLegs.alpha = 1;
					spriteLegs.color = 0xFFFFFF;
					spriteSmall.alpha = 1;
					spriteSmall.color = 0xFFFFFF;
				}
			}
			
			if (poisonDuration > 0) {
				poisonDuration -= FP.elapsed;
				if (poisonDuration <= 0) {
					Particle.emit("poison", x + width / 2, y + height / 2, 10);
					life -= 1;
					hurtSfx.play();
					poisonCount -= 1;
					if (poisonCount > 0) {
						flashDuration = 2;
						poisonDuration = 5;
					} else {
						spriteLegs.color = 0xFFFFFF;
						spriteSmall.color = 0xFFFFFF;
						canFlash = true;
					}
				}
			}
			
			if (inWall && flashDuration <= 0) {
				life -= 1;
				hurtSfx.play();
				flash(2);
			}
			
			if (small) spriteSmall.flipped = FP.screen.mouseX < (x - FP.camera.x);
			if (Input.pressed("Size")) {
				setSmall(!small);
			}
			
			if (Input.check("Left")) {
				moveLeft(50);
				(graphic as Spritemap).play("run");
				if (!small) spriteLegs.flipped = true;
			} else if (Input.check("Right")) {
				moveRight(50);
				(graphic as Spritemap).play("run");
				if (!small) spriteLegs.flipped = false;
			} else {
				notMove();
				(graphic as Spritemap).play("stand");
			}
			var entity : Entity = collide("mob", x, y) as Entity;
			if (entity && flashDuration <= 0) {
				var mob : EntityBase = collide("mob", x, y) as EntityBase;
				if (mob) {
					if (mob.poisoned) {
						poison(2);
						Particle.emit("blood", mob.x + mob.width / 2 , mob.y + mob.height / 2, 20);
						world.remove(mob);
					} else {
						if (!small) {
							Particle.emit("blood", mob.x + mob.width / 2 , mob.y + mob.height / 2, 20);
							world.remove(mob);
						} else {
							Particle.emit("blood", x + width / 2 , y + height / 2, 10);
							flash(0.5);
							life -= 1;
							hurtSfx.play();
							velocity.x += ((graphic as Spritemap).flipped ? 300 : -300);
						}
					}
				} else {
					// Wasp
					Particle.emit("blood", x + width / 2 , y + height / 2, 10);
					flash(0.5);
					life -= 1;
					hurtSfx.play();
					velocity.x += 500;
				}
			}
			if (bonusDuration > 0) bonusDuration -= FP.elapsed;
			if (bonusId > 0 && bonusDuration <= 0) {
				if (bonusId == 0) {
					maxVelocity = new Point(maxVelocity.x - 50, maxVelocity.y);
				}
				bonusId = -1;
			}
			
			var bonus : Bonus = collide("bonus", x, y) as Bonus;
			if (bonus) {
				getSfx.play();
				Particle.emit("bonus", x + width / 2 , y + height / 2, 10);
				if (bonus.bonusType == 0) {
					bonusId = 0;
					bonusDuration = 5;
					world.remove(bonus);
					maxVelocity = new Point(maxVelocity.x + 50, maxVelocity.y);
				} else if (bonus.bonusType == 1) {
					bonusDuration = 5;
					bonusId = 1;
					bonus.destroy();
				} else if (bonus.bonusType == 2) {
					life += 1;
					world.remove(bonus);
				}
			}
			
			if (Input.check("Jump") && onGround) {
				if (swim) {
					if (!small) jump(200);
				} else {
					jump(300);
				}
			}
			if (Input.released("Jump") && !onGround && bonusId == 1 && jumpCount > 0) {
				jumpCount -= 1;
				jump(250);
			}
			
			if (onGround) jumpCount = 1;
			
			super.update();
			updateCamera();
			
			if (Input.mousePressed && small) {
				var startPoint : Point = new Point(x + (spriteSmall.flipped ? 0 : width), y + height / 2 - 2);
				shootSfx.play();
				world.add(new Bullet(startPoint, new Point(FP.camera.x + FP.screen.mouseX, FP.camera.y + FP.screen.mouseY)));
			}
		}
		
	}
	

}