package entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.masks.Grid;
	import utils.Resource;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Dreauw
	 */
	public class Map extends Entity {
		private var tilemap : Tilemap;
		private var grid : Grid;
		public function Map(tiles:Array, solidTiles:Array) : void {
			tilemap = new Tilemap(Resource.TILESET, tiles[0] * 16, tiles[1] * 16, 16, 16);
			tilemap.loadFromString(tiles[2], ",", "\n");
			if (solidTiles.length > 0) {
				type = "solid";
				grid = tilemap.createGrid(solidTiles);
				mask = grid;
			}
			layer = 5;
			graphic = tilemap;
			super();
		}
		
		public function isTilePassable(x : Number, y : Number) : Boolean{
			return !grid.getTile(x, y);
		}
	}

}