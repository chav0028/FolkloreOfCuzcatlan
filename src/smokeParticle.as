package
{
	import org.flixel.FlxParticle;
	import org.flixel.FlxPoint;
	
	public class smokeParticle extends FlxParticle
	{
		//Const can control the direction of the particles.
		private const MAXVALX:Number=10;
		private const MAXVALY:Number=100;
		private const MINVALX:Number=-5;
		private const MINVALY:Number=10;

		public function smokeParticle()
		{
			super();
			//Set color of particles
			makeGraphic(4,4,0xAA2E1E21);
		}
		
		override public function onEmit():void
		{			
			var newVelocity:FlxPoint=new FlxPoint();
			var length:Number;
			
			//Set speed of particles
			var speed:int=Math.random()*(-35+1)-1;		
			
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
			
			//Assign the newVelocity
			velocity=newVelocity;		
			
		}
		
	}
}