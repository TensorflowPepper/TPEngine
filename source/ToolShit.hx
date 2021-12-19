package;

import flixel.util.FlxColor;

class ToolShit {
    
    static public function generateAccuracy(?sicks:Int, ?goods:Int, ?bads:Int, ?shits:Int, ?misses:Int) {
        return (sicks + goods + bads + shits + misses) != 0 ? (sicks * 100 + goods * 80 + bads * 50 + shits * 40 + misses * 0) / (sicks + goods + bads + shits + misses) : null;
    }

    static public function generateRanking(?accuracy:Int, ?misses:Int, ?score:Int) {

        var ranking:String = "N/A";
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
            accuracy == 0,
            accuracy == null
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
                    case 11:
                        ranking = " N/A";
                }
                break;
            }
        }

        return "Score: " + score + "   Misses: " + misses + "   Rating: " + (accuracy + "% (" + ranking + " )");
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