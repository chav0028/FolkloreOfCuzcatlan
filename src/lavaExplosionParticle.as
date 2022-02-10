package
{
	import org.flixel.FlxParticle;
	import org.flixel.FlxPoint;
	
	public class lavaExplosionParticle extends FlxParticle
	{
		//Const can control the direction of the particles.
		private const MAXVALX:Number=100;
		private const MAXVALY:Number=-50;
		private const MINVALX:Number=-100;
		private const MINVALY:Number=-200;
		
		public function lavaExplosionParticle()
		{
			super();
			var randomNumber:int;
			
			//Pick a random number between options of colors
			randomNumber=(Math.floor(Math.random() * (3 - 1 + 1)) + 1);
			
			//Randomly pick a color for lava
			if (randomNumber==1)
			{
			makeGraphic(4,4,0xFFF88F22)
			}
			else if (randomNumber==2)
			{
			makeGraphic(4,4,0xFFA42E24)
			}
			else
			{
			makeGraphic(4,4,0xFF954f1b)
			}
			
		}
		
		//onEmit is the function called when the particles are emitted
		override public function onEmit():void
		{
			var newVelocity:FlxPoint=new FlxPoint();
			var length:Number;
			
			var speed:int=Math.random()*60;//Circle explosion, random speed
			
			
			//Important, how to get a random number between 2 numbers Math.random()*(Max value-min value)+Min value;
			newVelocity.x=Math.random()*(MAXVALX-MINVALX)+MINVALX;
			newVelocity.y=Math.random()*(MAXVALY-MINVALY)+MINVALY;
			
			//Pythagorean theorem, get hypotenuse (magnitude)
			length=Math.sqrt((newVelocity.x*newVelocity.x)+(newVelocity.y*newVelocity.y));
			
			//Normalize vectors
			newVelocity.x/=length;
			newVelocity.y/=length;
			
			//Scale the direction vectors
			newVelocity.x*=speed;
			newVelocity.y*=speed;
			
			//gravity
			acceleration.y=20;
			
			
			//Assign the newVelocity
			velocity=newVelocity;
			
			
		}
		
		
	}
}