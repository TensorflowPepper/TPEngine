package;

import flixel.util.FlxColor;
import flixel.FlxG;

class ToolShit {
    
    static public function truncateFloat(number:Float, precision:Int):Float
    {
        var num = number;
        num = num * Math.pow(10, precision);
        num = Math.round(num) / Math.pow(10, precision);
        return num;
    }

    static public function generateAccuracy(sicks:Int, goods:Int, bads:Int, shits:Int, misses:Int, ghosttaps:Int):Array<Dynamic> {
        var accuracy:Float;

        if (FlxG.save.data.ghosttap) {
            if (sicks + goods + bads + shits + misses != 0) accuracy = truncateFloat((sicks * 100 + goods * 80 + bads * 50 + shits * 40) / (sicks + goods + bads + shits + misses), 4);
            else accuracy = 0;
        } else {
            if (sicks + goods + bads + shits + misses + ghosttaps != 0) accuracy = truncateFloat((sicks * 100 + goods * 80 + bads * 50 + shits * 40) / (sicks + goods + bads + shits + misses + ghosttaps), 3);
            else accuracy = 0;
        }

        var letterRanking:String = "Clear";
        
        if (((FlxG.save.data.ghosttap && misses == 0) || (!FlxG.save.data.ghosttap && misses == 0 && ghosttaps == 0)) && (sicks + goods + bads + shits + misses) != 0) {
            letterRanking = "FC";
            if (shits == 0 && bads == 0) {
                letterRanking = "GFC";
                if (goods == 0) {
                    letterRanking = "SFC";
                }
            }
        }

        if ((FlxG.save.data.ghosttap && misses < 10 && misses > 0) || (!FlxG.save.data.ghosttap && (misses + ghosttaps) < 10 && (misses + ghosttaps) > 0)) letterRanking = "SDCB";
        else if ((FlxG.save.data.ghosttap && misses > 10) || (!FlxG.save.data.ghosttap && (misses + ghosttaps) > 10)) letterRanking = "Clear";

        var returningArray:Array<Dynamic> = [];
        returningArray.push(accuracy);
        returningArray.push(letterRanking);
        return returningArray;
    }

    static public function generateRanking(?accuracy:Float, ?misses:Int, ?ghosttaps:Int, ?score:Int, letterRanking:String) {
        var ranking:String = "";

        var conditions:Array<Bool> = [
            accuracy == 100,
            accuracy >= 99,
            accuracy >= 95,
            accuracy >= 90,
            accuracy >= 85,
            accuracy >= 80,
            accuracy >= 70,
            accuracy >= 60,
            accuracy >= 50,
            accuracy > 0,
            accuracy == 0
        ];

        for(i in 0...conditions.length)
        {
            var boolean = conditions[i];
            if (boolean)
            {
                switch(i)
                {
                    case 0:
                        ranking = " Perfect Combo!!!";
                    case 1:
                        ranking = " Marvelous!!";
                    case 2:
                        ranking = " Precise!!";
                    case 3:
                        ranking = " Sick!";
                    case 4:
                        ranking = " Nice!";
                    case 5:
                        ranking = " Good!";
                    case 6:
                        ranking = " Bad";
                    case 7:
                        ranking = " Shit...";
                    case 8:
                        ranking = " U Kiddin'?";
                    case 9:
                        ranking = " R U AFK?";
                    case 10:
                        ranking = " wut";
                }
                break;
            }
        }

        return "Score: " + score + " Misses: " + misses + " Ghost Taps: " + ghosttaps + "   Rating: " + (accuracy + "% (" + ranking + " )" + " [" + letterRanking + "]");
    }

    static public function formatTime(?duration:Int) {
        var minutes:Int = 0;
        var seconds:Int = 0;
        var leftTime:Int = duration;
           
        while (leftTime >= 60) {
            leftTime -= 60;
            minutes += 1;
            continue;
        }

        seconds = leftTime;

        return minutes + ":" + (seconds < 10 ? "0" + seconds : seconds + "");
    }

    static public function formatColor(difficulty:String):FlxColor {
        switch (difficulty.toLowerCase()) {
            case "easy":
                return FlxColor.fromString("0x0AFFA0");
            case "normal":
                return FlxColor.fromString("0xFFFFA0");
            case "hard":
                return FlxColor.fromString("0xFF0000");
            case "expert":
                return FlxColor.fromString("0xEE0AEE");
            case "insane":
                return FlxColor.fromString("0xFEFEFE");
        }
        return formatColor("normal");
    }
}