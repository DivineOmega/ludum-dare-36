package scripts;

import com.stencyl.graphics.G;
import com.stencyl.graphics.BitmapWrapper;

import com.stencyl.behavior.Script;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.ActorScript;
import com.stencyl.behavior.SceneScript;
import com.stencyl.behavior.TimedTask;

import com.stencyl.models.Actor;
import com.stencyl.models.GameModel;
import com.stencyl.models.actor.Animation;
import com.stencyl.models.actor.ActorType;
import com.stencyl.models.actor.Collision;
import com.stencyl.models.actor.Group;
import com.stencyl.models.Scene;
import com.stencyl.models.Sound;
import com.stencyl.models.Region;
import com.stencyl.models.Font;
import com.stencyl.models.Joystick;

import com.stencyl.Engine;
import com.stencyl.Input;
import com.stencyl.Key;
import com.stencyl.utils.Utils;

import openfl.ui.Mouse;
import openfl.display.Graphics;
import openfl.display.BlendMode;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.events.TouchEvent;
import openfl.net.URLLoader;

import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2Fixture;
import box2D.dynamics.joints.B2Joint;

import motion.Actuate;
import motion.easing.Back;
import motion.easing.Cubic;
import motion.easing.Elastic;
import motion.easing.Expo;
import motion.easing.Linear;
import motion.easing.Quad;
import motion.easing.Quart;
import motion.easing.Quint;
import motion.easing.Sine;

import com.stencyl.graphics.shaders.BasicShader;
import com.stencyl.graphics.shaders.GrayscaleShader;
import com.stencyl.graphics.shaders.SepiaShader;
import com.stencyl.graphics.shaders.InvertShader;
import com.stencyl.graphics.shaders.GrainShader;
import com.stencyl.graphics.shaders.ExternalShader;
import com.stencyl.graphics.shaders.InlineShader;
import com.stencyl.graphics.shaders.BlurShader;
import com.stencyl.graphics.shaders.SharpenShader;
import com.stencyl.graphics.shaders.ScanlineShader;
import com.stencyl.graphics.shaders.CSBShader;
import com.stencyl.graphics.shaders.HueShader;
import com.stencyl.graphics.shaders.TintShader;
import com.stencyl.graphics.shaders.BloomShader;



class ActorEvents_13 extends ActorScript
{
	public var _wanderpoint1:Float;
	public var _movingleft:Bool;
	public var _wanderpoint2:Float;
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_reset_positions():Void
	{
		actor.setX(randomInt(Math.floor((actor.getWidth())), Math.floor(((getSceneWidth()) - (actor.getWidth())))));
		_wanderpoint1 = asNumber(randomInt(Math.floor((actor.getWidth())), Math.floor(actor.getX())));
		propertyChanged("_wanderpoint1", _wanderpoint1);
		_wanderpoint2 = asNumber(randomInt(Math.floor(actor.getX()), Math.floor(((getSceneWidth()) - (actor.getWidth())))));
		propertyChanged("_wanderpoint2", _wanderpoint2);
	}
	
	
	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		nameMap.set("wander_point_1", "_wanderpoint1");
		_wanderpoint1 = 0.0;
		nameMap.set("moving_left", "_movingleft");
		_movingleft = false;
		nameMap.set("wander_point_2", "_wanderpoint2");
		_wanderpoint2 = 0.0;
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		Engine.engine.setGameAttribute("simulation_on", false);
		_customEvent_reset_positions();
		
		/* ======================== Actor of Type ========================= */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorType(0), event.otherActor.getType(),event.otherActor.getGroup()))
			{
				Engine.engine.setGameAttribute("simulation_on", false);
				actor.getLastCollidedActor().setY(-50);
				engine.allActors.reuseIterator = false;
				for(actorOnScreen in engine.allActors)
				{
					if(actorOnScreen != null && !actorOnScreen.dead && !actorOnScreen.recycled && actorOnScreen.isOnScreenCache)
					{
						actorOnScreen.shout("_customEvent_" + "reset_positions");
					}
				}
				engine.allActors.reuseIterator = true;
				return;
			}
		});
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if((actor.getX() > _wanderpoint2))
				{
					_movingleft = true;
					propertyChanged("_movingleft", _movingleft);
					actor.growTo(-100/100, 100/100, 0.5, Quad.easeInOut);
				}
				if((actor.getX() < _wanderpoint1))
				{
					_movingleft = false;
					propertyChanged("_movingleft", _movingleft);
					actor.growTo(100/100, 100/100, 0.5, Quad.easeInOut);
				}
				if((_movingleft == true))
				{
					actor.setXVelocity(-3);
				}
				else
				{
					actor.setXVelocity(3);
				}
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}