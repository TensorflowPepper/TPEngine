import flixel.FlxG;
import flixel.input.FlxInput;
import flixel.input.actions.FlxAction;
import flixel.input.actions.FlxActionInput;
import flixel.input.actions.FlxActionInputDigital;
import flixel.input.actions.FlxActionManager;
import flixel.input.actions.FlxActionSet;
import flixel.input.gamepad.FlxGamepadButton;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.keyboard.FlxKey;

class KeyBinds
{

    public static var gamepad:Bool = false;

    public static function resetBinds():Void{

        FlxG.save.data.upBind = "D";
        FlxG.save.data.downBind = "F";
        FlxG.save.data.leftBind = "J";
        FlxG.save.data.rightBind = "K";
        FlxG.save.data.killBind = "R";
        PlayerSettings.player1.controls.loadKeyBinds();
	}

    public static function keyCheck():Void
    {
        if(FlxG.save.data.upBind == null){
            FlxG.save.data.upBind = "J";
            trace("No UP");
        }
        if (StringTools.contains(FlxG.save.data.upBind,"NUMPAD"))
            FlxG.save.data.upBind = "J";
        if(FlxG.save.data.downBind == null){
            FlxG.save.data.downBind = "F";
            trace("No DOWN");
        }
        if (StringTools.contains(FlxG.save.data.downBind,"NUMPAD"))
            FlxG.save.data.downBind = "F";
        if(FlxG.save.data.leftBind == null){
            FlxG.save.data.leftBind = "D";
            trace("No LEFT");
        }
        if (StringTools.contains(FlxG.save.data.leftBind,"NUMPAD"))
            FlxG.save.data.leftBind = "D";
        if(FlxG.save.data.rightBind == null){
            FlxG.save.data.rightBind = "K";
            trace("No RIGHT");
        }
        if (StringTools.contains(FlxG.save.data.rightBind,"NUMPAD"))
            FlxG.save.data.rightBind = "K";

        trace('${FlxG.save.data.leftBind}${FlxG.save.data.downBind}${FlxG.save.data.upBind}${FlxG.save.data.rightBind}');
    }

}