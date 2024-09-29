package states.stages;

import states.stages.objects.*;

class PhillyStreets extends BaseStage
{
	// If you're moving your stage from PlayState to a stage file,
	// you might have to rename some variables if they're missing, for example: camZooming -> game.camZooming
	var phillyCars1:BGSprite;
	var phillyCars2:BGSprite;
	var phillyTraffic:BGSprite;
	override function create()
	{
		// Spawn your stage sprites here.
		// Characters are not ready yet on this function, so you can't add things above them yet.
		// Use createPost() if that's what you want to do.
		var scrollingSky:BGSprite = new BGSprite('weekend1/phillySkybox', -650, -375, 0.1, 0.1);
		addSprite(scrollingSky);
		var scrollingSky:BGSprite = new BGSprite('weekend1/phillySkyline', -545, -273, 0.2, 0.2);
		addSprite(scrollingSky);
		var phillyForegroundCity:BGSprite = new BGSprite('weekend1/phillyForegroundCity', 625, 94, 0.3, 0.3);
		addSprite(phillyForegroundCity);
		var phillyConstruction:BGSprite = new BGSprite('weekend1/phillyConstruction', 1800, 364,  0.7, 1);
		addSprite(phillyConstruction);
		var phillyHighwayLights:BGSprite = new BGSprite('weekend1/phillyHighwayLights', 284, 305, 1, 1);
		addSprite(phillyHighwayLights);
		var phillyHighway:BGSprite = new BGSprite('weekend1/phillyHighway', 139, 209, 1, 1);
		addSprite(phillyHighway);
		var phillySmog:BGSprite = new BGSprite('weekend1/phillySmog', -6, 245, 1, 1);
		addSprite(phillySmog);
		phillyCars1 = new BGSprite('weekend1/phillyCars', 1748, 818, 1, 1, ['car1']);
		phillyCars1.animation.addByPrefix('car1', 'car1', 24, false);
		phillyCars1.animation.addByPrefix('car2', 'car2', 24, false);
		phillyCars1.animation.addByPrefix('car3', 'car3', 24, false);
		phillyCars1.animation.addByPrefix('car4', 'car4', 24, false);
		addSprite(phillyCars1);
		phillyCars2 = new BGSprite('weekend1/phillyCars', 1748, 818, 1, 1, ['car2']);
		phillyCars2.animation.addByPrefix('car1', 'car1', 24, false);
		phillyCars2.animation.addByPrefix('car2', 'car2', 24, false);
		phillyCars2.animation.addByPrefix('car3', 'car3', 24, false);
		phillyCars2.animation.addByPrefix('car4', 'car4', 24, false);
		phillyCars2.flipX = true;
		addSprite(phillyCars2);
		getCarPosition();
		phillyTraffic = new BGSprite('weekend1/phillyTraffic', 1840, 608, 0.9, 1, ['tored']);
		phillyTraffic.animation.addByPrefix('tored', 'greentored', 24, false);
		phillyTraffic.animation.addByPrefix('togreen', 'redtogreen', 24, false);
		addSprite(phillyTraffic);
		var phillyForeground:BGSprite = new BGSprite('weekend1/phillyForeground', 88, 317, 1, 1);
		addSprite(phillyForeground);
	}

	function getCarPosition(){
		phillyCars1.x = 1800;
		phillyCars1.y = 480;
		phillyCars1.angle = -20;
		phillyCars2.x = 1800;
		phillyCars2.y = 480;
		phillyCars2.angle = 30;
	}
	
	override function createPost()
	{
		// Use this function to layer things above characters!
			var spraycanPile:BGSprite = new BGSprite('weekend1/SpraycanPile', 920, 1045, 0.9, 1);
		addSprite(spraycanPile);
	}

	function addSprite(sprite:BGSprite){
		add(sprite);
	}

	override function update(elapsed:Float)
	{
		// Code here
	}

	// Steps, Beats and Sections:
	//    curStep, curDecStep
	//    curBeat, curDecBeat
	//    curSection
	override function stepHit()
	{
		// Code here
	}
	override function beatHit()
	{
		// Code here
	}
	override function sectionHit()
	{
		// Code here
	}

	// Substates for pausing/resuming tweens and timers
	override function closeSubState()
	{
		if(paused)
		{
			//timer.active = true;
			//tween.active = true;
		}
	}

	override function openSubState(SubState:flixel.FlxSubState)
	{
		if(paused)
		{
			//timer.active = false;
			//tween.active = false;
		}
	}

	// For events
	override function eventCalled(eventName:String, value1:String, value2:String, flValue1:Null<Float>, flValue2:Null<Float>, strumTime:Float)
	{
		switch(eventName)
		{
			case "My Event":
		}
	}
	override function eventPushed(event:objects.Note.EventNote)
	{
		// used for preloading assets used on events that doesn't need different assets based on its values
		switch(event.event)
		{
			case "My Event":
				//precacheImage('myImage') //preloads images/myImage.png
				//precacheSound('mySound') //preloads sounds/mySound.ogg
				//precacheMusic('myMusic') //preloads music/myMusic.ogg
		}
	}
	override function eventPushedUnique(event:objects.Note.EventNote)
	{
		// used for preloading assets used on events where its values affect what assets should be preloaded
		switch(event.event)
		{
			case "My Event":
				switch(event.value1)
				{
					// If value 1 is "blah blah", it will preload these assets:
					case 'blah blah':
						//precacheImage('myImageOne') //preloads images/myImageOne.png
						//precacheSound('mySoundOne') //preloads sounds/mySoundOne.ogg
						//precacheMusic('myMusicOne') //preloads music/myMusicOne.ogg

					// If value 1 is "coolswag", it will preload these assets:
					case 'coolswag':
						//precacheImage('myImageTwo') //preloads images/myImageTwo.png
						//precacheSound('mySoundTwo') //preloads sounds/mySoundTwo.ogg
						//precacheMusic('myMusicTwo') //preloads music/myMusicTwo.ogg
					
					// If value 1 is not "blah blah" or "coolswag", it will preload these assets:
					default:
						//precacheImage('myImageThree') //preloads images/myImageThree.png
						//precacheSound('mySoundThree') //preloads sounds/mySoundThree.ogg
						//precacheMusic('myMusicThree') //preloads music/myMusicThree.ogg
				}
		}
	}
}