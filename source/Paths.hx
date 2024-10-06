package;

#if sys
import sys.FileSystem;
#end

import flixel.graphics.frames.FlxAtlasFrames;

class Paths
{

    static final audioExtension:String = "ogg";

    inline static public function file(key:String, location:String, extension:String):String{

        var data:String = 'assets/$location/$key.$extension';
        if (FileSystem.exists('mods/$location/$key.$extension')){
            data = 'mods/$location/$key.$extension';
        }
        return data;

    }

    inline static public function image(key:String, forceLoadFromDisk:Bool = false):Dynamic{

        var data:String = file(key, "images", "png");

        if(ImageCache.exists(data) && !forceLoadFromDisk){
            //trace(key + " is in the cache");
            return ImageCache.get(data);
        }
        else{
            //trace(key + " loading from file");
            return data;
        }
            
    }

    inline public static function getPreloadPath(file:String = '')
        {
            return 'assets/$file';
        }
    
    inline static public function lua(key:String,?library:String)
        {
            return 'scripts/modcharts/$key.lua';
        }
    
        inline static public function luaImage(key:String, ?library:String)
        {
            return 'scripts/modcharts/$key.png';
        }

    inline static public function xml(key:String, ?location:String = "images"){
        return file(key, location, "xml");
    }

    inline static public function text(key:String, ?location:String = "data"){
        return file(key, location, "txt");
    }

    inline static public function json(key:String, ?location:String = "data"){
        return file(key, location, "json");
    }

    inline static public function sound(key:String){
        return file(key, "sounds", audioExtension);
    }

    inline static public function music(key:String){
        return file(key, "music", audioExtension);
    }

    inline static public function voices(key:String, type:String = ""){
        if(type.length > 0){ type = "-" + type; }
        if (FileSystem.exists('mods/songs/$key/Voices$type.ogg')){
            return 'mods/songs/$key/Voices$type.ogg';
        }else if (FileSystem.exists('mods/songs/$key/Voices.ogg')){
            return 'mods/songs/$key/Voices.ogg';
        }else if (FileSystem.exists('assets/songs/$key/Voices.ogg')){
            return 'assets/songs/$key/Voices.ogg';
        }else{
            return 'assets/songs/$key/Voices$type.ogg';
        }
    }

    inline static public function inst(key:String){
        if (FileSystem.exists('mods/songs/$key/Inst.ogg')){
            return 'mods/songs/$key/Inst.ogg';
        }else{
            return 'assets/songs/$key/Inst.ogg';
        }
    }

    inline static public function getSparrowAtlas(key:String){
        return FlxAtlasFrames.fromSparrow(image(key), xml(key));
    }

    inline static public function getPackerAtlas(key:String){
        return FlxAtlasFrames.fromSpriteSheetPacker(image(key), text(key, "images"));
    }

    inline static public function getTextureAtlas(key:String){
        return 'assets/images/$key';
    }

    inline static public function video(key:String){
        return file(key, "videos", "mp4");
    }
    
    inline static public function font(key:String, ?extension:String = "ttf"){
        return file(key, "fonts", extension);
    }

}