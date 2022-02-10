package
{
	import org.flixel.FlxCamera;
	import org.flixel.FlxEmitter;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxParticle;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxTilemap;
	import org.flixel.system.FlxTile;
	
	public class PlayState extends FlxState
	{
		[Embed(source="../Assets/Images/Volcano.png")] private var volcanoImage:Class;
		[Embed(source="../Assets/Images/Background.png")] private var backgroundImage:Class;
		
		[Embed(source="../Assets/Images/Tiles.png")]private var tilesImage:Class;
		[Embed(source = "../Assets/LevelOne.csv", mimeType = "application/octet-stream")] private var levelOneCSV:Class;//Embed map csv 
		private var mapCSV:Class;
		
		private var player:Player;
		private var playerAlive:Boolean;
		private var playerWon:Boolean;
		private var playerWalkingVelocity:int;
		private var bulletList:FlxGroup;//Actually stones, not bullets. But for simplicity defined as bulelts.
		
		private var enemyList:FlxGroup;
		
		private var volcano:FlxSprite;
		
		private var score:FlxText;
		private var timeText:FlxText;
		
		private var time:int;
		private var timer:Number;
		private var volcanoTimer:Number;
		private var volcanoTime:Number;
		
		private var mapCollisionGroup:FlxGroup;//Collsion group used to reduce number of FlxGcollide calls.
		
		private var hud:FlxGroup;
		private var map:FlxTilemap; 
		private var background:FlxGroup;
		private var levelHeight:int=400;
		private var levelWidth:int=8000;
		
		//Emitters
		private var volcanoSmoke:FlxEmitter;//Persistent emitter
		private var volcanoExplosion:FlxEmitter//Explosion emitter
		private var ashExplosion:FlxEmitter;//Explosion emitter
		private var walkAshes:FlxEmitter;//Persistent emitter-Active when walking through certain tiles
		
		
		private const initialTime:int=120;		
		private const enemyHitknockback:int=3;
		
		//END Condition constants
		private const outOfTime:int=1;
		private const dead:int=2;
		private const win:int=3;
		
		//Map tiles consts
		private const lava:int=12;
		private const lava2:int=13;
		private const lava3:int=14;
		private const flame:int=15;
		//private const burnedSoil:int=21;
		
		override public function create():void
		{
			//Set properties for vars
			FlxG.score=0;//Ensures score is 0
			playerWon=false;
			playerAlive=true;
			timer=0;
			time=initialTime;
			volcanoTimer=0;
			volcanoTime=1;

			FlxG.playMusic(BackgroundMusic, 1);//Background Music
			
			//Object pooling bullet list
			bulletList=new FlxGroup;1
			for (var i:int = 0; i < 100; i++) 
			{
				bulletList.add(new Bullet());
				bulletList.members[i].kill();
			}
			
			//Create objects
			player=new Player(bulletList,16,levelHeight-140)
				
			//Enemy made after player, since they have to be aware of it
			enemyList=new FlxGroup();
			//Create enemy list
			for (var j:int=0;j<3;j++)
			{
				enemyList.add(new IdleChaser(player,500,500));
				enemyList.members[j].kill();
			}
				
			
			volcano=new FlxSprite(0,0);
			volcano.loadGraphic(volcanoImage,false,false,775, 400)
			
			mapCollisionGroup=new FlxGroup();	
				
			hud=new FlxGroup();//Creates element of the hud
			
			score=new FlxText(0,0,60);
			score.setFormat(null, 8, 0xFFFFFFFF, "left");	
			
			timeText=new FlxText(FlxG.width-120,0,120);
			timeText.setFormat(null, 8, 0xFFFFFFFF, "right");		
			
			//The numbers may seem excessive..but I like a lot of particles
			volcanoSmoke=new FlxEmitter(800,800,400);//Appear offscren
			volcanoExplosion=new FlxEmitter(800,800,400);
			walkAshes=new FlxEmitter(800,800,400);
			ashExplosion=new FlxEmitter(800,800,800);
			
			//object pooling particles
			var tempParticle:FlxParticle;
			for (var i:int = 0; i < 400; i++)//Initialize smoke,walk and lava particle and stones (bullets)
			{
				//Smoke particles-persistent
				tempParticle=new smokeParticle();
				tempParticle.scrollFactor=new FlxPoint(0.01,0.01);//Set scroll factor
				volcanoSmoke.add(tempParticle);
				
				//Explosion particles-explosion?
				tempParticle=new lavaExplosionParticle();
				tempParticle.scrollFactor=new FlxPoint(0.01,0.01);
				volcanoExplosion.add(tempParticle);
				
				//Walking on ashes particle-persistent
				tempParticle=new walkingAshParticle();
				walkAshes.add(tempParticle);
			}
			
			for (var j:int = 0; j < 800; j++)//Initialize ashes particles
			{
				//Explosion of ashes
				tempParticle=new AshParticle();
				ashExplosion.add(tempParticle);	
			}
			ashExplosion.width=1200;//Set width of ashes fall, so they randomly appear on 1200pixels (across entire screen)		
			
			volcanoSmoke.kill()
			volcanoExplosion.kill();
			walkAshes.kill();
			ashExplosion.kill();
			
			//Set condition for volcano smoke persistent emitter		
			volcanoSmoke.start(false,15,0.01);
			walkAshes.start(false, 0.3, 0.01);
			
			loadBackground()//Background not in load level so that there can be objects (volcano) between background and map
					
			//Add objects
			add(volcanoSmoke);	
			add (volcano);
			add(volcanoExplosion);
			add(walkAshes);
				
			//Load level map and other initial conditions
			loadLevel();
			add(bulletList);
			add(player);
			add(enemyList);
			add(ashExplosion);
			
			//Set camera
			FlxG.camera.setBounds(0,0,levelWidth,levelHeight,true);//Set bounds for the camera
			FlxG.camera.follow(player,FlxCamera.STYLE_PLATFORMER);//set what the camera will follow		
			
			//Parallax		
			volcano.scrollFactor=new FlxPoint(0.01,0.01);	

			//Set HUD
			FlxG.mouse.show(null,0.5);//Show mouse
			add(hud);
			
			hud.add(score);
			hud.add(timeText);
			
			//Set values dependend on others
			hud.setAll("scrollFactor",new FlxPoint(0,0));//Set to 0 so HUD doesn't move
			hud.setAll("cameras",[FlxG.camera]);//Set so that it stays with the camera.
			
			//Sets the player walking speed
			playerWalkingVelocity=80;
			
			//Add elements to collision group
			mapCollisionGroup.add(walkAshes);
			mapCollisionGroup.add(ashExplosion);
			mapCollisionGroup.add(enemyList);
			
			super.create();
		}
	
		
		override public function update():void
		{
			super.update();

			//check if player wants to exit the game (Stop music and go back to main menu)
			if (FlxG.keys.ESCAPE==true)
			{
				FlxG.music.stop();
				FlxG.switchState(new IntroState);
			}
			
			if(player.x>=levelWidth)//Check if player has won the game
			{
				playerAlive=false;
				EndState.endCondition = win;
				playerWon = true;//Variable just used to indicate in the state that player won, and add him bonus points according to time
			}
			
			//Set emitters positionS
			volcanoSmoke.x=volcano.x+416;
			volcanoSmoke.y=volcano.y+205;
			volcanoExplosion.x=volcano.x+416;
			volcanoExplosion.y = volcano.y + 190;
			
			ashExplosion.x=player.x-200;
			ashExplosion.y=0;
			
			volcanoEruption();//Check if volcano will explode
			
			if(playerAlive==true)
			{
				//Reduce amount of time
				runTimer();
				
				//Check if there are enemies available to place
				var tempEnemy:IdleChaser=(IdleChaser)(enemyList.getFirstAvailable());
				if (tempEnemy!=null)
				{
					spawnEnemy();
				}		
				
			//Display hud
			score.text="Score: "+FlxG.score.toString();//Display score
			timeText.text="Time:" + time.toString();//Display time remaining

			walkAshes.x=player.x+player.width/2;
			walkAshes.y=player.y+30;
			
			
			//Collision
			FlxG.collide(mapCollisionGroup,map);
			FlxG.collide(map,bulletList,killBullet)
			FlxG.collide(bulletList, enemyList, hitEnemy)//Kill players if hit..
			if (player.flickering == false)//Invincibility after being hit (if player is hit he is flickering)
			{
			FlxG.collide(player,enemyList,enemyKillPlayer)//Kill player if he collides with an enemy
			}			
				if(FlxG.collide(player,map)==false)//Check if player is colliding with ground
				{
					walkAshes.frequency = 0;//Stops the emitter
				}
				else
				{
					emitWalkingAshes();
				}	
			
			}
			else
			{
				if (playerWon==true)//If player managed to finish the game
				{
					FlxG.score+=(time*100);//Bonus for finishing with extra time
				}
				FlxG.music.stop();
				FlxG.switchState(new EndState);			
				
				
			}
		}
		
		private function killBullet(tile:FlxTilemap,sprite2:FlxSprite):void
		{
			sprite2.kill();
		}
		
		private function loadLevel():void // Load all the things specific of a certain level.
		{
			
			mapCSV=levelOneCSV;	
			
			//Load map
			map = new FlxTilemap;
			map.loadMap(new mapCSV, tilesImage, 16, 16,0,0,1,10);
			
			//Set spercial properties for tiles
			map.setTileProperties(lava,FlxObject.ANY,killPlayer,Player)//Set the lava as deadly , filter only when player collides
			map.setTileProperties(lava2,FlxObject.ANY,killPlayer,Player)//Set the lava as deadly
			map.setTileProperties(lava3, FlxObject.ANY, killPlayer, Player)//Set the lava as deadly
			map.setTileProperties(flame, FlxObject.ANY, killPlayer, Player)//Set the fire as deadly
				
			add(map);				
			
		}
		
		private function loadBackground():void//Set the background image tiles as if there where background, adapting to the size of the level
		{
			var background:FlxGroup;
			var backgroundTile:FlxSprite;//Use background "tiles" so that the background automatically adjusts to map size (it must be multiple of 400 width)
			var mapSizeBackgrounds:int;//The size of the map according to how many backgrounds it can fit wide.
			var tempX:int=0;		
			
			background=new FlxGroup;
			
			//Use image so that it can't be a more complex background
			backgroundTile=new FlxSprite(tempX,0);
			backgroundTile.loadGraphic(backgroundImage,false,false,400,400);	
			background.add(backgroundTile);
			
			mapSizeBackgrounds=levelWidth/backgroundTile.width;//Get how many tiles fit in the level
			
			for (var i:int = 0; i < mapSizeBackgrounds; i++) //Adds the tiles according to the size of the level
			{
				//Background Tiles
				tempX+=backgroundTile.width//Same variable used for backgroundTiles and cloudTiles since they have same width.
				
				backgroundTile=new FlxSprite(tempX,0);
				backgroundTile.loadGraphic(backgroundImage,false,false,400,400);	
				background.add(backgroundTile);
			}
			
			add(background);
		}
		
		
		//If player collides against lava
		private function killPlayer(tile:FlxTile,sprite2:FlxSprite):void
		{
			playerAlive=false;
			EndState.endCondition=dead;//Set the end condition
		}
		
		//If player collides against enemy
		private function enemyKillPlayer(sprite1:FlxSprite,sprite2:FlxSprite):void
		{
			//Sprite1==player
			//sprite2==enemies
			
			//Knockback according to the direction of the bullet
			//Horizontal knockback
			if (sprite2.velocity.x>0)//Right
			{
				player.x+=enemyHitknockback;//Knockback to the enemy
			}
			else if (sprite2.velocity.x<0)//Left
			{
				player.x-=enemyHitknockback;//Knockback to the enemy
			}
			
			//Horizontal knockback
			if (sprite2.velocity.y>0)//Down
			{
				player.y+=enemyHitknockback;//Knockback to the enemy
			}
			else if (sprite2.velocity.y<0)//Up
			{
				player.y-=enemyHitknockback;//Knockback to the enemy
			}
			
			//Make the player notice he got hit
			FlxG.play(hitSound, 0.8)
			player.flicker(0.5);//Player can't be hit while flickering
			
			player.health-=1;//Substract health
			if (player.health <= 0)
			{
			playerAlive=false;
			EndState.endCondition = dead;//Set the end condition
			}
		}
		
		public function runTimer():void
		{			
			timer+=FlxG.elapsed;//Counter to 1 second, adds amount everyframe (In normal case it will add 1/60 every frame, so 1 second =60 frames)
			
			if (timer>=1)//When 1 second has passed
			{			
				time-=1;//Decrease time remaining
				
				if (time<=0)//If the score is 0 kill the player.
				{	
					playerAlive=false;
					EndState.endCondition=outOfTime;
				}
				
				timer=0;//Set timer back to 0.			
			}			
		}	
			
		public function volcanoEruption():void
		{	
			volcanoTimer+=FlxG.elapsed;
			
			if (volcanoTimer>=volcanoTime)
			{
				FlxG.play(volcanoEruptionSound,0.4);
				volcanoExplosion.start(true,10,0.1,150);//Explosion emitter
				FlxG.shake(0.02,0.3);//Shake camera
				
				//Sets another random tiem for explosion, between 5-15 seconds
				volcanoTimer=0;
				volcanoTime=Math.random()*(15-5)+5;		
				
				ashExplosion.start(true,10,0.1,400);				
			}	
		}
		
		public function emitWalkingAshes():void
		{
			//Emit more ashes if player is running than if he is walking
			
			if(playerWalkingVelocity<=player.maxVelocity.x)//If player is walking
			{				
				walkAshes.frequency = 0.01;
			}
			else//Player is running
			{
				walkAshes.frequency = 5;;//Emit more ashes when running
			}
		}
		
		public function spawnEnemy():void
		{	
			//Place enemy close to the player. forward player, but outside the screen
			var enemy:IdleChaser=(IdleChaser)(enemyList.getFirstAvailable())//Cast to FlxSprite to see if it is a FlxSprite (if not it will return null)
			
				//Place enemy close to the player. forward player, but outside the screen
				enemy.x=Math.random()*((player.x+420)-(player.x+400))+player.x+400;
				enemy.y = int(Math.random() * ((levelHeight - 116)-100)) + 100;
				
				if (FlxG.overlap(map, enemy, spawnEnemy) == false)//Recursion, to check the enemy appears correctly (NOT WORKING PROPERLY)
				{
					//Hard coded certain parts of level to reduce chancees of enemy spawning on map
					if (enemy.x >= 4800 && enemy.x <= 7400)
					{
						enemy.y = int(Math.random() * ((levelHeight - 46)-100)) + 100
					}
					
					if (enemy.x < 7400)//Don't spawn enemies near the ending because the player is reaching the "greener pastures"
					{
						enemy.reset(enemy.x, enemy.y);
						enemy.health = 3;//Ensure enemy always has health 3, when it appears
					}
												
				}

		}		
		
		public function hitEnemy(object1:FlxObject=null,object2:FlxObject=null):void
		{
		//Object 1==bullet
		//object 2==enemy
			object1.kill();
			object2.health-=1;
			
			//Knockback according to the direction of the bullet
			//Horizontal knockback
			if (object1.velocity.x>0)//Right
			{
				object2.x+=enemyHitknockback;//Knockback to the enemy
			}
			else if (object1.velocity.x<0)//Left
			{
				object2.x-=enemyHitknockback;//Knockback to the enemy
			}
			
			//Horizontal knockback
			if (object1.velocity.y>0)//Down
			{
				object2.y+=enemyHitknockback;//Knockback to the enemy
			}
			else if (object1.velocity.y<0)//Up
			{
				object2.y-=enemyHitknockback;//Knockback to the enemy
			}
			
			//Flicker enemy to indicate he has been hit
			object2.flicker(0.2);
			
			FlxG.play(hitSound,0.4);
			
			if (object2.health<=0)
			{
				object2.kill();
				FlxG.score+=50;
			}
			
		}
	
		
		
	}
}
