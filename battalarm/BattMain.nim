import std/os
import BattTestGUI
from AudWrapper import play

const a: string = "b"
  
if checker: 
    runGUI()
else:
    echo "BattHider - By NullCode\n-----------------------"
    echo "\nYour chosen configuration settings:"
    echo "Highest Battery level: " & $highest & "%"
    echo "Critical Battery level: " & $critical & "%"
    echo "You will be reminded every " & $rmints & " seconds\n\nThis window will be hidden in 5 seconds..."
    sleep(5000)
    hideWindow()
    
    while a == "b":
        if checkLife() >= highest:
            if isCharging(): play("assets" / "Highest.wav", 4500)
            else: discard
        if checkLife() <= critical:
            if isCharging(): discard
            else: play("assets" / "Critical.wav", 4500)
        sleep(remind)