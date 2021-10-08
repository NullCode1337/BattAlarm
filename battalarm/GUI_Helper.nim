import std/os, nigui
import AudioPlayer, BattProcs, BattVars 

proc runGUI*() = 
    when defined(windows): hideWindow()
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
    timer = startRepeatingTimer(remind, timerProc)
    timer2 = startRepeatingTimer(remind, alarm)
    window.show()
    app.run()