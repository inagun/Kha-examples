package actors;
import sdg.Object;
import kha.Image;
import sdg.atlas.Atlas;
import sdg.graphics.Sprite;
import sdg.atlas.Region;
import sdg.components.Motion;
import sdg.components.Animator;
import sdg.collision.Hitbox;


class Actor extends Object
{
	var speed:Float;
	var sprite:Sprite;	
	var motion:Motion;
	var animator:Animator;
	var body:Hitbox;
	var health:Int = 1;

	public function new(x:Float, y:Float,i:Image,w:Int,h:Int)
	{
		super(x, y);

		var regions = Atlas.createRegionsFromAsset(i, w, h);
		
		sprite = new Sprite(regions[0]);
		graphic = sprite;
		setSizeAuto();

		body = new Hitbox(this, 'play', null, 'collision');
		
		setupAnimations(regions);
		
		motion = new Motion();
		motion.drag.x = 0.5;
		motion.drag.y = 0.5;
		motion.maxVelocity.x = 3;
		motion.maxVelocity.y = 3;
		addComponent(motion);
	}


	function setupAnimations(regions:Array<Region>)
	{
		animator = new Animator();
		animator.addAnimation('idle', [regions[0]]);
		animator.addAnimation('run', regions.slice(0, 2), 5);
		animator.addAnimation('attack', [regions[0],regions[2]], 5);

		addComponent(animator);

		animator.play('idle');
	}
	
	public override function moveCollideX(object:Object):Bool
	{
		motion.velocity.x = 0;
		return true;
	}
	
	public override function moveCollideY(object:Object):Bool
	{
		motion.velocity.y = 0;
		return true;
	}	
	
	public override function update()
	{
		super.update();

		if(Math.abs(motion.acceleration.y) > 0 && Math.abs(motion.acceleration.x) > 0)
		{
			motion.acceleration.y *= Math.sqrt(2);
			motion.acceleration.x *= Math.sqrt(2);
		}

		body.moveBy(motion.velocity.x, motion.velocity.y, 'collision');

		if ((motion.velocity.x != 0 || motion.velocity.y != 0) && animator.nameAnim != 'run')	
		{		
			animator.play('run');					
		}
		else if (motion.velocity.x == 0 && motion.velocity.y == 0 && animator.nameAnim != 'idle')		
		{
				animator.play('idle');	
		}
	}
}

