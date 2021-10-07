# This is a mess, I made this in a rush sowwy
import nigui
import std/os
import std/json
import winim/lean
import std/strscans
from AudWrapper   import play
from std/strutils import replace
from std/osproc   import execCmdEx

var life:   int
var charge: int

proc checkLife*(): int = 
   var life_raw = execCmdEx("WMIC PATH Win32_Battery Get EstimatedChargeRemaining")[0].replace("\n", "")
   if not scanf(life_raw, "EstimatedChargeRemaining$s$i", life): # Thanks beef331, impbox
      raise newException(ValueError, "Invalid EstimatedCharge")
   else: result = life

proc isCharging*(): bool =
   var status_raw = execCmdEx("WMIC PATH Win32_Battery Get BatteryStatus")[0].replace("\n", "")
   if not scanf(status_raw, "BatteryStatus$s$i", charge):
      raise newException(ValueError, "Invalid BatteryStatus")
   else:
      case charge
        of 1: return false
        of 2: return true
        of 6: return true
        of 7: return true
        of 8: return true
        of 9: return true
        else: return false

# Thanks enthus1ast
proc hideWindow*(hide = true) =
  if hide:
    ShowWindow(FindWindowW("ConsoleWindowClass", NULL), SW_HIDE);
  else:
    ShowWindow(FindWindowW("ConsoleWindowClass", NULL), SW_SHOW);
       
let 
  config*   = parseJson(readfile("Config.json"))
  highest*  = config["highestPercentage"].getInt()
  critical* = config["criticalPercentage"].getInt()
  checker*  = config["healthCheckerMode"].getBool()
  remind*   = config["remindEvery"].getInt() * 1000
  rmints*   = remind / 1000
  
var 
  timer*:  Timer
  timer2*:  Timer
  counter* = 1
  counter2* = 1
  
proc runGUI*() = 
    app.init()
    var 
      window = newWindow("BattAlarm - by NullCode")
      container = newLayoutContainer(Layout_Vertical)
      textArea = newTextArea()
    window.width = 600.scaleToDpi
    window.height = 400.scaleToDpi
    window.add(container)
    container.add(textArea)
    textArea.addLine "                           BattAlarm Test"
    textArea.addLine "Check how fast your battery charges/discharges"
    textArea.addLine "------------------------------------------------------------------"
    textArea.addLine "Settings:"
    textArea.addLine "----------"
    textArea.addLine "Highest percentage: " & $highest & "%"
    textArea.addLine "Critical percentage: " & $critical & "%"
    textArea.addLine "Display stats every: " & $rmints & " seconds"
    textArea.addLine ""
    proc timerProc(event: TimerEvent) =
        textArea.addLine("Battery Percentage: " & $checkLife())
        textArea.addLine("Is device charging: " & $isCharging())    
        textArea.addLine(" ")    
        counter.inc()
    proc alarm(event: TimerEvent) = 
        if checkLife() >= highest:
            if isCharging(): play("assets" / "Highest.wav", 4500)
            else: discard
        if checkLife() <= critical:
            if isCharging(): discard
            else: play("assets" / "Critical.wav", 4500)
        sleep(remind)
    timer = startRepeatingTimer(remind, timerProc)
    timer2 = startRepeatingTimer(remind, alarm)
    window.show()
    app.run()