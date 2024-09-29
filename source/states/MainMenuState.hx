package states;

import flixel.FlxObject;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import states.editors.MasterEditorMenu;
import options.OptionsState;
import psychlua.*;
import psychlua.LuaUtils;
import psychlua.HScript;
import substates.GameplayChangersSubstate;
import flixel.ui.FlxButton;

#if SScript
import tea.SScript;
#end

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.1'; // This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	var optionShit:Array<String> = [
		'story_mode',
		'freeplay',
		#if MODS_ALLOWED 'mods', #end
		'credits',
		'options'
		#if ACHIEVEMENTS_ALLOWED ,'awards' #end
	];

	var magenta:FlxSprite;
	var camFollow:FlxObject;

	var char:FlxSprite;

	override function create()
	{
		#if MODS_ALLOWED
		Mods.pushGlobalMods();
		#end
		Mods.loadTopMod();

		#if DISCORD_ALLOWED
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.scrollFactor.set(0, yScroll);
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		bg.screenCenter();
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.antialiasing = ClientPrefs.data.antialiasing;
		magenta.scrollFactor.set(0, yScroll);
		magenta.setGraphicSize(Std.int(magenta.width * 1.175));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.color = 0xFFfd719b;
		add(magenta);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);
	

		for (i in 0...optionShit.length)
		{
			var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
			var menuItem:FlxSprite = new FlxSprite(0, (i * 140) + offset);
			menuItem.antialiasing = ClientPrefs.data.antialiasing;
			menuItem.frames = Paths.getSparrowAtlas('mainmenu/menushit');
			menuItem.animation.addByPrefix('idle', optionShit[i] + "1", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + "2", 24);
			menuItem.animation.play('idle');
			menuItems.add(menuItem);
			var scr:Float = (optionShit.length - 4) * 0.135;
			if (optionShit.length < 6)
				scr = 0;
			menuItem.scrollFactor.set(0, scr);
			menuItem.updateHitbox();
			menuItem.screenCenter(X);
			switch (optionShit[i])
			{
				case 'story_mode':
					menuItem.setPosition(0, 0);
				case 'freeplay':
					menuItem.setPosition(0, 60);
				case 'mods':
					menuItem.setPosition(0, 120);
				case 'credits':
					menuItem.setPosition(0, 180);
				case 'options':
					menuItem.setPosition(0, 240);
				case 'awards':
					menuItem.setPosition(0, 300);
			}
		}

		char = new FlxSprite().makeGraphic(0, 30, '');
		char.frames = Paths.getSparrowAtlas('characters/nene');
		char.animation.addByPrefix('idle', 'idle', 24, false);
		char.animation.play('idle');
		char.antialiasing = ClientPrefs.data.antialiasing;
		add(char);

		var psychVer:FlxText = new FlxText(12, FlxG.height - 44, 0, "Chainsaw Engine v" + psychEngineVersion, 12);
		psychVer.scrollFactor.set();
		psychVer.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(psychVer);
		var fnfVer:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);
		fnfVer.scrollFactor.set();
		fnfVer.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(fnfVer);
		changeItem();

		#if ACHIEVEMENTS_ALLOWED
		// Unlocks "Freaky on a Friday Night" achievement if it's a Friday and between 18:00 PM and 23:59 PM
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18)
			Achievements.unlock('friday_night_play');

		#if MODS_ALLOWED
		Achievements.reloadList();
		#end
		#end


		super.create();

		FlxG.camera.follow(camFollow, null, 9);
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * elapsed;
			if (FreeplayState.vocals != null)
				FreeplayState.vocals.volume += 0.5 * elapsed;
		}


		if (!selectedSomethin)
		{
			
			char.animation.play('idle');
			if (controls.UI_UP_P)
				changeItem(-1);

			if (controls.UI_DOWN_P)
				changeItem(1);

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				FlxG.mouse.visible = false;
				FlxG.sound.play(Paths.sound('confirmMenu'));
				if (optionShit[curSelected] == 'gameplay_changers')
				{
					openSubState(new GameplayChangersSubstate());
				}
				else
				{
					selectedSomethin = true;

					if (ClientPrefs.data.flashing)
						FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					FlxFlicker.flicker(menuItems.members[curSelected], 1, 0.06, false, false, function(flick:FlxFlicker)
					{
						switch (optionShit[curSelected])
						{
							case 'story_mode':
								MusicBeatState.switchState(new StoryMenuState());
							case 'freeplay':
								MusicBeatState.switchState(new FreeplayState());

							#if MODS_ALLOWED
							case 'mods':
								MusicBeatState.switchState(new ModsMenuState());
							#end

							#if ACHIEVEMENTS_ALLOWED
							case 'awards':
								MusicBeatState.switchState(new AchievementsMenuState());
							#end

							case 'credits':
								MusicBeatState.switchState(new CreditsState());
							case 'options':
								MusicBeatState.switchState(new options.OptionsMainState());
								options.OptionsMainState.onPlayState = false;
								if (PlayState.SONG != null)
								{
									PlayState.SONG.arrowSkin = null;
									PlayState.SONG.splashSkin = null;
									PlayState.stageUI = 'normal';
								}
							}
					});

					for (i in 0...menuItems.members.length)
					{
						if (i == curSelected)
							continue;
						FlxTween.tween(menuItems.members[i], {alpha: 0}, 0.4, {
							ease: FlxEase.quadOut,
							onComplete: function(twn:FlxTween)
							{
								menuItems.members[i].kill();
							}
						});
					}
				}
			}
			#if desktop
			if (controls.justPressed('debug_1'))
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			if (FlxG.keys.justPressed.EIGHT)
				{
					selectedSomethin = true;
					MusicBeatState.switchState(new states.Results());
				}
			#end
		}

		super.update(elapsed);
	}

	function changeItem(huh:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'));
		menuItems.members[curSelected].animation.play('idle');

		curSelected += huh;

		/*if (curSelected == 0 || curSelected == menuItems.length - 1){
			remove(char);
			char = new FlxSprite().makeGraphic(0, 30, '');
			char.frames = Paths.getSparrowAtlas('characters/nene');
			char.animation.addByPrefix('idle', 'idle', 24, false);
			char.animation.play('idle');
			char.antialiasing = ClientPrefs.data.antialiasing;
			add(char);
		}
		if (curSelected == 1){
			remove(char);
			char = new FlxSprite().makeGraphic(120, 30, '');
			char.frames = Paths.getSparrowAtlas('characters/danfi');
			char.animation.addByPrefix('idle', 'idle', 24, false);
			char.animation.play('idle');
			char.antialiasing = ClientPrefs.data.antialiasing;
			char.flipX = true;
			char.x = 60;
			char.y = 30;
			add(char);
		}
		if (curSelected == 2){
			remove(char);
			char = new FlxSprite().makeGraphic(120, 30, '');
			char.frames = Paths.getSparrowAtlas('characters/pf');
			char.animation.addByPrefix('idle', 'idle', 24, false);
			char.animation.play('idle');
			char.antialiasing = ClientPrefs.data.antialiasing;
			char.x = 60;
			char.y = 30;
			add(char);
		}
		if (curSelected == 3){
			remove(char);
			char = new FlxSprite().makeGraphic(120, 0, '');
			char.frames = Paths.getSparrowAtlas('characters/tankmanCaptain');
			char.animation.addByPrefix('idle', 'Tankman Idle Dance', 24, false);
			char.animation.play('idle');
			char.antialiasing = ClientPrefs.data.antialiasing;
			char.x = 60;
			char.y = 0;
			add(char);
		}
		if (curSelected == 4){
			remove(char);
			char = new FlxSprite().makeGraphic(120, 0, '');
			char.frames = Paths.getSparrowAtlas('characters/DADDY_DEAREST');
			char.animation.addByPrefix('idle', 'Dad idle dance', 24, false);
			char.animation.play('idle');
			char.antialiasing = ClientPrefs.data.antialiasing;
			char.flipX = true;
			char.x = 60;
			char.y = 0;
			add(char);
		}
		if (curSelected == 5){
			remove(char);
			char = new FlxSprite().makeGraphic(120, 30, '');
			char.frames = Paths.getSparrowAtlas('characters/BOYFRIEND');
			char.animation.addByPrefix('idle', 'BF idle dance', 24, false);
			char.animation.play('idle');
			char.antialiasing = ClientPrefs.data.antialiasing;
			char.x = 60;
			add(char);
		}*/

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.members[curSelected].animation.play('selected');

	}
}
