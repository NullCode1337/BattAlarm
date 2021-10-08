import BattVars 
import std/strscans
from std/strutils import replace
from std/osproc   import execCmdEx
when defined(windows): import winim/lean

proc checkLife*(): int = 
   when defined(windows):
       var life_raw = execCmdEx("WMIC PATH Win32_Battery Get EstimatedChargeRemaining")[0].replace("\n", "")
       if not scanf(life_raw, "EstimatedChargeRemaining$s$i", life): # Thanks beef331, impbox
          raise newException(ValueError, "Invalid EstimatedCharge")
       else: return life
   else:
       var life = execCmdEx("cat /sys/class/power_supply/BAT0/capacity")[0] # WIP

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
        var status_raw = "wip"
        
when defined(windows):
    proc hideWindow*(hide = true) = # Thanks enthus1ast
      if hide:
        ShowWindow(FindWindowW("ConsoleWindowClass", NULL), SW_HIDE);
      else:
        ShowWindow(FindWindowW("ConsoleWindowClass", NULL), SW_SHOW);
