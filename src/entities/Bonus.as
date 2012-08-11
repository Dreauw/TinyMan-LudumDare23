package entities 
{
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import utils.Resource;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Dreauw
	 */
	public class Bonus extends Entity {
		public var bonusType : Number;
		public var respawnDuration : Number = 0;
		public function Bonus(x : Number, y : Number, bonusType : Number) {
			this.bonusType = bonusType;
			this.x = x;
			this.y = y;
			graphic = new Image(Resource.BONUS, new Rectangle(10 * bonusType, 0, 10, 10));
			setHitbox(10, 10);
			type = "bonus";
		}
		
		public function destroy() : void {
			if (bonusType == 1) {
				respawnDuration = 5;
				visible = false;
				collidable = false;
			}
		}
		
		override public function update():void {
			super.update();
			if (respawnDuration > 0) {
				respawnDuration -= FP.elapsed;
				if (respawnDuration <= 0) {
					visible = true;
					collidable = true;
				}
			}
		}
		
	}

}