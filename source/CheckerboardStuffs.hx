package;

import flixel.graphics.frames.FlxAtlasFrames;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.addons.display.FlxBackdrop;

class CheckerboardStuffs extends FlxTypedSpriteGroup<FlxSprite> {    

    public function new(x:Int, y:Int) {
        super(x, y);

        createCubes();
    }

    function createCubes() {
        var numCubesX:Int = Math.ceil(1920 / 128);
        var numCubesY:Int = Math.ceil(1080 / 128);

        for (yIndex in 0...numCubesY) {
            for (xIndex in 0...numCubesX) {
       			var cube:FlxSprite = new FlxSprite();
                cube.loadGraphic(Paths.image('storyMenuMt/a'));
                cube.scrollFactor.set();
                cube.x = 128 * xIndex;
                cube.y = 128 * yIndex;
        		add(cube);
            }
        }
    }
}