package
{
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	
	public class Bullet extends FlxSprite
	{		
		public function Bullet()
		{	
			super(-100,-100);
			makeGraphic(4,4,0xFF939D9F);

		}
		
		public override function reset(X:Number, Y:Number):void
		{
			health=8;//Health will mean bullet lives 8 seconds
			super.reset(X,Y);
		}
		
		public override function update():void
		{
			health-=FlxG.elapsed;
						
			//Bullet gravity
			acceleration.y=50;
			
			if (health<0)
			{
				kill();
			}
			
			super.update();
			
		}
		
	}
}