import nigui, std/json

# Proc vars
var 
  life*:   int
  charge*: int

# GUI Test vars
var 
  timer*:  Timer
  timer2*:  Timer
  counter* = 1
  counter2* = 1

# User configuration vars
let 
  config*   = parseJson(readfile("Config.json"))
  highest*  = config["highestPercentage"].getInt()
  critical* = config["criticalPercentage"].getInt()
  checker*  = config["healthCheckerMode"].getBool()
  remind*   = config["remindEvery"].getInt() * 1000
  rmints*   = remind / 1000

const a*: string = "b"