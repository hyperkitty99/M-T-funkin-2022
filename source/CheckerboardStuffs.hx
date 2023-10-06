package;

import flixel.graphics.frames.FlxAtlasFrames;
import animateatlas.AtlasFrameMaker;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.addons.display.FlxBackdrop;

class CheckerboardStuffs extends FlxTypedSpriteGroup<FlxSprite> {    

    public function new(x:Int, y:Int) {
        super(x, y);

        createRetards();
    }

    function createRetards() {
        var numRetardsX:Int = Math.ceil(1920 / 128);
        var numRetardsY:Int = Math.ceil(1080 / 128);

        for (yIndex in 0...numRetardsY) {
            for (xIndex in 0...numRetardsX) {
       			var retard:FlxSprite = new FlxSprite();
                retard.loadGraphic(Paths.image('storyMenuMt/a'));
        		retard.scrollFactor.set();
                retard.x = 128 * xIndex;
                retard.y = 128 * yIndex;
        		add(retard);
            }
        }
    }
}