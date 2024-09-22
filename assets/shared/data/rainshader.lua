--[[
    for all the clueless folk that cry for help because "i moved shader to psych mod but it not work like in base game!!!!!" 
]]

function get(p)
    return getProperty('camGame.'..p);
end

function onCreatePost()
    initLuaShader('rain', 100);
    makeLuaSprite('rainShaderSpr');
    setSpriteShader('rainShaderSpr', 'rain');

    setShaderFloatArray('rainShaderSpr', 'uScreenResolution', {screenWidth, screenHeight});
    setShaderFloat('rainShaderSpr', 'uTime', 0);
    setShaderFloat('rainShaderSpr', 'uScale', screenHeight / 200);
    -- 0.5 is constant for the last song, Blazin
    -- for other songs (they change as the song progresses):
    -- Darnell: 0 - 0.1
    -- Lit Up: 0.1 - 0.2
    -- 2Hot: 0.2 - 0.4
    setShaderFloat('rainShaderSpr', 'uIntensity', 0);

    -- FlxG.camera is by default camGame
    runHaxeCode([[
        var obj = game.getLuaObject('rainShaderSpr');
        FlxG.camera.setFilters([new ShaderFilter(obj.shader)]);
        return;
    ]]);
end

-- avoiding use of os.clock() to have rain halt at pause instead of advancing further than it should
local time = 0;
function onUpdatePost(e)
    setShaderFloat('rainShaderSpr', 'uIntensity', getProperty("songPercent") *0.1);
    --debugPrint(getProperty("songPercent") *0.1)
    time = time + e;
    setShaderFloatArray('rainShaderSpr', 'uCameraBounds',
        {get('scroll.x') + get('viewMarginX'), -- left
        get('scroll.y') + get('viewMarginY'), -- top
        get('scroll.x') + (get('width') - get('viewMarginX')), -- right
        get('scroll.y') + (get('height') - get('viewMarginY'))} -- bottom
    );
    setShaderFloat('rainShaderSpr', 'uTime', time);
end

function onGameOver()
    runHaxeCode([[
        FlxG.camera.setFilters([]);
        return;
    ]]);
end