package;

import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.addons.effects.FlxTrail;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class CustomTrail extends FlxTrail {
    public var ytween:Null<Float>;
    public var tween:FlxTween;

    public function new(Target:FlxSprite, ?Graphic:Dynamic, Length:Int = 10, Delay:Int = 3, Alpha:Float = 0.4, Diff:Float = 0.05, ?Ytween:Float) {
        super(Target, Graphic, Length, Delay);
        this.alpha = Alpha;
        this.ytween = Ytween;
    }

    public function applyTween():Void {
        if (this.ytween != null && (this.tween == null || !this.tween.active)) {
            this.tween = FlxTween.tween(this, { y: this.y - this.ytween }, 0.3, { ease: FlxEase.linear, onComplete: onTweenComplete });
        }
    }

    private function onTweenComplete(tween:FlxTween):Void {
        applyTween();
    }      

    public function destroyTween():Void {
        if (this.tween != null) {
            this.tween.cancel();
            this.tween = null;
        }
    }
}