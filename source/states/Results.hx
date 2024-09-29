package states;

import flixel.FlxObject;
import flixel.util.FlxStringUtil;

class Results extends MusicBeatState
{
    var bfdj:FlxSprite;
    var curAnim:String = 'bfdj';
    var camFollow:FlxObject;
    var bg:FlxSprite;
    public static var epicscore:Int = 0;
    public static var epicmiss:Int = 0;
    public static var epicpercent:Float = 0;
    public static var epicRating:String = '?';
    public static var epiccombo:Int = 0;
    public static var epichighcombo:Int = 0;
    public static var epichits:Int = 0;
    override function create(){
		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);
        FlxG.mouse.visible = true;
        bg = new FlxSprite().loadGraphic(Paths.image('menuBG'));
		bg.antialiasing = ClientPrefs.data.antialiasing;
		add(bg);
        createCharacter(curAnim);
        var scoreTxt:FlxText = new FlxText(0, 100, 0, "Score: " + FlxStringUtil.formatMoney(epicscore, false, true), 12);
		scoreTxt.scrollFactor.set();
		scoreTxt.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(scoreTxt);
        var missTxt:FlxText = new FlxText(0, 200, 0, "Misses: " + FlxStringUtil.formatMoney(epicmiss, false, true), 12);
		missTxt.scrollFactor.set();
		missTxt.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(missTxt);
        var percentTxt:FlxText = new FlxText(0, 300, 0, "Accuracy: " + epicpercent + '%', 12);
		percentTxt.scrollFactor.set();
		percentTxt.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(percentTxt);
        var ratingTxt:FlxText = new FlxText(0, 400, 0, "Rating: " + epicRating, 12);
		ratingTxt.scrollFactor.set();
		ratingTxt.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(ratingTxt);
        var comboTxt:FlxText = new FlxText(0, 500, 0, "Combo: " + FlxStringUtil.formatMoney(epiccombo, false, true), 12);
		comboTxt.scrollFactor.set();
		comboTxt.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(comboTxt);
        var highcomboTxt:FlxText = new FlxText(0, 600, 0, "Highest Combo: " + FlxStringUtil.formatMoney(epichighcombo, false, true), 12);
		highcomboTxt.scrollFactor.set();
		highcomboTxt.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(highcomboTxt);
        var hitsTxt:FlxText = new FlxText(0, 700, 0, "Hits: " + FlxStringUtil.formatMoney(epichits, false, true), 12);
        hitsTxt.scrollFactor.set();
		hitsTxt.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(hitsTxt);
        super.create();
    }
    override function update(elapsed:Float){
        playAnim('idle');
        if (controls.ACCEPT){
            FlxG.mouse.visible = false;
            MusicBeatState.switchState(new FreeplayState());
        }
        super.update(elapsed);
    }

    function createCharacter(animationCurrent:String){
		bfdj = new FlxSprite().makeGraphic(0, 30, '');
		bfdj.frames = Paths.getSparrowAtlas('FREEPLAY/$animationCurrent');
		bfdj.animation.addByPrefix('idle', 'Boyfriend DJ0', 24, false);
		bfdj.animation.addByPrefix('confirm', 'Boyfriend DJ confirm0', 24, false);
        bfdj.x = 600;
        bfdj.y = 300;
		bfdj.antialiasing = ClientPrefs.data.antialiasing;
        playAnim('idle');
		add(bfdj);
    }
    function playAnim(animationCurrent:String){
        bfdj.animation.play(animationCurrent);
    }
}