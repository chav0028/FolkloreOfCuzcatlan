package
{
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	
	public class Player extends FlxSprite
	{
		[Embed(source="../Assets/Images/Player.png")]private var playerImage:Class;
		
		//Variables used to shoot
		public const SHOTSPEED:Number=180;
		private var bulletList:FlxGroup;
		
		public function Player(_bulletList,X:Number=0, Y:Number=0)
		{
			//Load player graphic
			super(X, Y);
			bulletList=_bulletList;//Point to the same object
			loadGraphic(playerImage,true,true,25,32);
			
			//Animations
			addAnimation("idle",[0],10);
			addAnimation("walk",[1,2,3,4,5,6,7,8],10,true);
			addAnimation("run",[1,2,3,4,5,6,7,8],30,true);//Just change the frame per seconds to simulate running
			addAnimation("jump",[9],10);
			
			play("idle");//set initial animation		
			
			width=21;//Adjust size of collision box, because the hat will be not collideable
			centerOffsets();//Center collision box
			
			health=3;
			maxVelocity.y=100;
			acceleration.y=100;
			drag.x=maxVelocity.x*4;//They don't stop instantaneously and they don't keep moving forever
		}
		
		override public function update():void
		{
			acceleration.x=0;//Needs to assign 0 for drag to work properly
			var playerRunning:Boolean=false;//Variable to determine if player is running
			
			//Horizontal movement
			/*if (FlxG.keys.LEFT||FlxG.keys.A)
			{
				facing=LEFT;
				acceleration.x=-maxVelocity.x*4;
			}
			if (FlxG.keys.RIGHT||FlxG.keys.D)
			{
				facing=RIGHT;
				acceleration.x=maxVelocity.x*4;
			}*/
			
			//Continous movement
			acceleration.x=maxVelocity.x*4;
			
			//Running
			if (FlxG.keys.SHIFT)
			{
				maxVelocity.x=160;
				playerRunning=true;
			}
			else
			{
				maxVelocity.x=80;
			}
			
			//Jump
			if ((FlxG.keys.SPACE||FlxG.keys.UP||FlxG.keys.W) && isTouching(FLOOR))
			{
				velocity.y=-maxVelocity.y;
			}
			
			//Shoot
			if(FlxG.mouse.justPressed())
			{
				FlxG.play(shootSound,0.3);
				shoot();
			}
			
			//Change animation that is playing according to what is active
			if(!isTouching(FLOOR))
			{
				play("jump");
			}
			else if (acceleration.x!=0)
			{
				if (playerRunning==true)
				{
					play("run");
				}
				else
				{
					play("walk");
				}
			}
			else
			{
				play("idle");
			}
			
			//Change sounds (Shoot sound in just pressed
			if (FlxG.keys.justPressed("SPACE")||FlxG.keys.justPressed("UP")||FlxG.keys.justPressed("W"))
			{
				FlxG.play(jumpSound,0.3);
			}
				
				
			super.update();
		}
		
		private function shoot():void
		{
			var bullet:FlxSprite=(FlxSprite)(bulletList.getFirstAvailable())//Cast to FlxSprite to see if it is a FlxSprite (if not it will return null)
			
			//Check if there are bullets available
			if (bullet !=null)
			{
				bullet.reset(0,0);//Draw pullet
				bullet.x=x+width/2-bullet.width/2//Set bullet to middle of player.
				bullet.y=y+height/2-bullet.height/2;
				
				//Shoot bullet where mouse is
				var angle:Number=FlxU.getAngle(new FlxPoint(x,y),FlxG.mouse.getWorldPosition())-90;//Get angle between between player and mouse (-90 because flash angle 0
				//is at the top)
				angle=(angle*Math.PI/180);//Convert angle to radians.
				
				bullet.velocity.x=Math.cos(angle)*SHOTSPEED;//Get direction vector and multiply by magnitude (Speed) cos=x
				bullet.velocity.y=Math.sin(angle)*SHOTSPEED;
				
				x=x-3;//Knockback for shooting
			}			
		}
		
		
	}
}