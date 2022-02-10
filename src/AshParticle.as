package
{
	import org.flixel.FlxParticle;
	import org.flixel.FlxPoint;
	
	public class AshParticle extends FlxParticle
	{
		//Const can control the direction of the particles.
		private const MAXVALX:Number=400;
		private const MAXVALY:Number=0;
		private const MINVALX:Number=-400;
		private const MINVALY:Number=-5;
		
		public function AshParticle()
		{
			super();
			//Set color of particles
			makeGraphic(2,2,0xAA1C0000);
		}
		
		override public function onEmit():void
		{			
			var newVelocity:FlxPoint=new FlxPoint();
			var length:Number;
			
			//Set speed of particles
			var speed:int=Math.random()*30;
			
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
			
			//RANDOM gravity
			acceleration.y=Math.random()*(25-15)+15;;
		}
		
	}
}