import std/os
import std/strformat
from std/osproc import execCmd
import AudioPlayer, BattProcs, BattVars, GUI_Helper

when defined(windows): 
    let str_rm = " seconds\n\nThis window will be hidden in 5 seconds..."
else: 
    let str_rm = " seconds"
    discard execCmd("clear")
    
if checker: runGUI()
else:
    echo &"""BattHider - By NullCode
-----------------------

Your chosen configuration settings:
-----------------------------------
Highest Battery level: {$highest}%
Critical Battery level: {$critical}%
You will be reminded every: {$rmints}{str_rm}"""

    sleep(5000)
    when defined(windows): hideWindow()
    
    while a == "b":
        if checkLife() >= highest:
            if isCharging(): play("assets" / "Highest.wav", 4500)
            else: discard
        if checkLife() <= critical:
            if isCharging(): discard
            else: play("assets" / "Critical.wav", 4500)
        sleep(remind)
