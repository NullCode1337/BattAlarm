import std/os
import BattVars 
import std/strutils
from std/osproc   import execCmdEx
when defined(windows): 
    import winim/lean
    import std/strscans

proc checkLife*(): int = 
    when defined(windows):
        var life_raw = execCmdEx("WMIC PATH Win32_Battery Get EstimatedChargeRemaining")[0].replace("\n", "")
        if not scanf(life_raw, "EstimatedChargeRemaining$s$i", life): # Thanks beef331, impbox
            raise newException(ValueError, "Invalid EstimatedCharge")
        else: return life
    else:
        if dirExists("/sys/class/power_supply/BAT0"):
            life = strip(execCmdEx("cat /sys/class/power_supply/BAT0/capacity")[0]).parseint 
            return life
        if dirExists("/sys/class/power_supply/BAT1"):
            life = strip(execCmdEx("cat /sys/class/power_supply/BAT1/capacity")[0]).parseint
            return life
            
proc isCharging*(): bool =
   when defined(windows): 
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
   else:
       if dirExists("/sys/class/power_supply/BAT0"):
            var status_raw = execCmdEx("cat /sys/class/power_supply/BAT0/status")[0].strip
            if contains("Dis", status_raw): return true
            else: return false
       if dirExists("/sys/class/power_supply/BAT1"):
            var status_raw = execCmdEx("cat /sys/class/power_supply/BAT1/status")[0].strip
            if contains("Dis", status_raw): return true
            else: return false
        
when defined(windows):
    proc hideWindow*(hide = true) = # Thanks enthus1ast
      if hide:
        ShowWindow(FindWindowW("ConsoleWindowClass", NULL), SW_HIDE);
      else:
        ShowWindow(FindWindowW("ConsoleWindowClass", NULL), SW_SHOW);
