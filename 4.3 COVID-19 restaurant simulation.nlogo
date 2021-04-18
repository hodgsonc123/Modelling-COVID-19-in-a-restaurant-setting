;
breed [tablesOfTwo tableOfTwo]
breed [tablesOfSix tableOfSix]
breed [tablesOfEight tableOfEight]
breed [chairs chair]
breed [waiters waiter]
breed [customers customer]
breed [bartenders bartender]
breed [chefs chef]
breed [nodes node]
breed [sinks sink]
breed [sanitisationStations sanitisationStation]
breed [toilets toilet]
breed [acOuts acOut]
breed [screens screen]
breed [largeTables largeTable]

patches-own [
  concentration
  patchType
  airDirection
  gridSquare
  pushPull
  pullDir
  airTransfer
  fomiteInfectedDoor
]

turtles-own [legendFlag]

waiters-own [
  location
  next-location
  final-location
  ticks-since-here
  busy
  moving
  timeAtLocation
  assignedTable

  infectionRisk
  infected
  exposureTime
  time-in-restaurant

  coughTime
  sneezeTime
  coughQueued
  sneezeQueued

  risk
  protectedRisk
  inhalationProtection
  emissionProtection

  handContamination
  fomiteRisk
  fomiteProtection
  counted
]

customers-own [
  location
  next-location
  final-location
  previous-location
  moving
  timeAtLocation
  assignedTable

  ticks-in-restaurant
  ticks-since-here
  stayLength
  atTable
  sat
  assignedTable
  assignedChair
  toiletUse
  sinkUse
  toiletUsed
  sinkUsed

  infectionRisk
  infected
  exposureTime
  time-in-restaurant

  coughTime
  sneezeTime
  coughQueued
  sneezeQueued

  risk
  protectedRisk
  inhalationProtection
  emissionProtection

  handContamination
  fomiteRisk
  fomiteProtection
  counted
]

bartenders-own [
  location
  next-location
  final-location
  ticks-since-here
  busy
  moving
  timeAtLocation
  assignedTable

  infectionRisk
  infected
  exposureTime
  time-in-restaurant

  coughTime
  sneezeTime
  coughQueued
  sneezeQueued

  risk
  protectedRisk
  inhalationProtection
  emissionProtection

  handContamination
  fomiteRisk
  fomiteProtection
  counted
]

chefs-own [location
  next-location
  final-location
  ticks-since-here
infected]

nodes-own [
  nodeType
  tableNumber
  tableSize
  beingServed
  occupied
  needsOrder
  needsDrinksOrder
  needsDrink
  needsFood
  hasFood
  needsCheckback
  needsCleared
  needsBill
  needsSanitised
  entryTick
  visits
  fomiteInfected
  sanitiser-here
]

tablesOfTwo-own[number nodeType fomiteInfected]
tablesOfSix-own[number nodeType fomiteInfected]
tablesOfEight-own[number nodeType fomiteInfected]

chairs-own [
  chairTaken
  clean
  tableNo
  chairNo
]

globals [
  numberOfTablesAndChairs
  showSinks
  showSaniStations
  linksShowing
  time

  constant-output

  averageConcentration
  averageConcentrationTemp

  averageSpeed
  averageSpeedTemp

  averageRisk
  averageRiskTemp

  numAtRisk
  totalPutAtRisk

  averageFomiteRisk
  averageFomiteRiskTemp

  averageHand
  averageHandTemp

  averageStay
  averageStayTemp

  lastTableEntry

  percentagePutAtRisk

  leftWindowOpen
  topWindowOpen

  mouse-was-down?

  total-customers
  total-infectious

  colourIntensity

  riskReporter
  concentrationReporter
  fomiteReporter
]


to setup
  clear-all
  resize-world -18 30 -23 17
  set numberOfTablesAndChairs 0

  ifelse twoM-distanced-seating = false  [
  setup-patches
  spawn-twos
  spawn-sixs
  spawn-eights
  spawn-chairs
  spawn-nodes
  spawn-sinks
  setup-chair-links
  spawn-toilets
  spawn-sanitisation-stations
  spawn-acOut
  spawn-largeTable
  ;spawn-screens
      ask patch -5 12 [set plabel "SEATING AREA " set plabel-color black ]
  ]
  [
  setup-patches
  spawn-twos-2
  spawn-sixs-2
  spawn-eights-2
  spawn-chairs-2
  spawn-nodes-2
  spawn-sinks
  setup-chair-links-2
  spawn-toilets
  spawn-sanitisation-stations
  spawn-acOut
  spawn-largeTable
      ask patch -5 10 [set plabel "SEATING AREA " set plabel-color black ]
  ]

  grid

  spawn-waiters
  spawn-bartenders
  spawn-chefs
  spawn-legend

  ask patch 9 4 [set plabel "BAR " set plabel-color black ]
  ask patch 17 13 [set plabel "KITCHEN " set plabel-color black ]
  ask patch -7 -19 [set plabel "TOILETS " set plabel-color black ]
  ask patch 11 -17 [set plabel "ENTRANCE" set plabel-color black ]
  ask patch -15 0 [set plabel "FRONT" set plabel-color black ]
  ask patch 0 16 [set plabel "SIDE" set plabel-color black ]

   reset-ticks
end


to spawn-legend

  create-turtles 1 [setxy 21 16 set color black set heading 90 ]
  ask patch 25 16 [set plabel "Waiter" set plabel-color black ]

  create-turtles 1 [setxy 21 14 set color 115 set heading 90 ]
  ask patch 26 14 [set plabel "Bartender" set plabel-color black ]

  create-turtles 1 [setxy 21 12 set color 83 set heading 90 ]
  ask patch 26 12 [set plabel "Customer" set plabel-color black ]

  create-turtles 1 [setxy 21 10 set color red set shape "infectedturtle" set heading 90 ]
  ask patch 28 10 [set plabel "Infected person" set plabel-color black ]

  create-turtles 1 [setxy 21 8 set color orange + 2 set heading 90 ]
  ask patch 29 8 [set plabel "Probable infection" set plabel-color black ]

  create-turtles 1 [setxy 21 6 set color grey set shape "square" set heading 90 ]
  ask patch 25 6 [set plabel "Door" set plabel-color black ]

  create-turtles 1 [setxy 21 4 set color 135 set shape "square" set heading 90 ]
  ask patch 29 4 [set plabel "Recirculation vent" set plabel-color black ]

  create-turtles 1 [setxy 21 2 set color black set shape "square" set heading 90 ]
  ask patch 24 2 [set plabel "Wall" set plabel-color black ]

  create-turtles 1 [setxy 21 0 set color blue set shape "square" set heading 90 ]
  ask patch 28 0 [set plabel "Closed window" set plabel-color black ]

  create-turtles 1 [setxy 16 -2 set color black set size 0.5 set shape "circle" ]
  ask patch 26 -2 [set plabel " Unoccupied Table node" set plabel-color black ]

  create-turtles 1 [setxy 16 -4 set color green set size 0.5 set shape "circle" ]
  ask patch 25 -4 [set plabel " Occupied Table node" set plabel-color black ]

  create-turtles 1 [setxy 16 -6 set color pink + 2 set size 0.5 set shape "circle" ]
  ask patch 22 -6 [set plabel "Regular node" set plabel-color black ]

  create-turtles 1 [setxy 16 -8 set color green set size 2 set shape "square" set heading 90 ]
  ask patch 22 -8 [set plabel "Table of two" set plabel-color black ]

  create-turtles 1 [setxy 16 -10 set color green set size 4 set shape "tableOfSix" set heading 90 ]
  ask patch 22 -10 [set plabel "Table of six" set plabel-color black ]

  create-turtles 1 [setxy 16 -13 set color green set size 4 set shape "tableOfEight" set heading 90 ]
  ask patch 23 -13 [set plabel "Table of eight" set plabel-color black ]

  create-turtles 1 [setxy 16 -16 set shape "square 2" set color yellow set heading 270 ]
  ask patch 20 -16 [set plabel "Chair" set plabel-color black ]

  create-turtles 1 [setxy 16 -18 set shape "sink" set color grey set size 2 set heading 270 ]
  ask patch 20 -18 [set plabel "Sink" set plabel-color black ]

  create-turtles 1 [setxy 16 -20 set shape "sanitisationstation" set color grey set heading 0 ]
  ask patch 24 -20 [set plabel "Sanitisation station" set plabel-color black ]

  create-turtles 1 [setxy 16 -22 set shape "square" set color red  set heading 0 ]
  create-turtles 1 [setxy 15 -22 set shape "square" set color red + 1 set heading 0 ]
  create-turtles 1 [setxy 14 -22 set shape "square" set color red + 2 set heading 0 ]
  create-turtles 1 [setxy 13 -22 set shape "square" set color red + 3 set heading 0 ]
  create-turtles 1 [setxy 12 -22 set shape "square" set color red + 4 set heading 0 ]
  ask patch 28 -22 [set plabel "High number of viral aerosols" set plabel-color black ]
  ask patch 10 -22 [set plabel "Low number of viral aerosols" set plabel-color black ]
end


to go
  waiter-movement
  bartender-movement

  if manual-customer-spawn = false[
    customer-table-assignment
  ]
  customer-movement
  ;chef-movement
  schedule
  infection
  airflow-control
  risk-control
  protection-control
  fomite-control
  mouse-manager

  ask waiters [if infected = true [set infected 0]]

  ifelse toggle-links = false[
    ask links[hide-link]
    ask nodes [ht]
  ]
  [ ask links[show-link]
    ask nodes [st]
  ]

  ifelse toggle-tables = false[
    ask tablesOfTwo [ht]
    ask tablesOfSix [ht]
    ask tablesOfEight [ht]
  ]
  [
    ask tablesOfTwo [st]
    ask tablesOfSix [st]
    ask tablesOfEight [st]
  ]
 ifelse toggle-chairs = false[
    ask chairs[ht]
  ]
  [
    ask chairs[st]
  ]

  ask nodes [
    ifelse occupied = true[set color green]
    [ifelse occupied = 0 [set color 138][set color black]]
  ]

  ask patches with [pxcor < -14][set concentration 0]

  ifelse averageRisk > 150 [set riskReporter "high"][ifelse averageRisk <= 150 and averageRisk > 45[set riskReporter "medium"][set riskReporter "low"]]
  ifelse averageConcentration > 100 [set concentrationReporter "high"][ifelse averageConcentration <= 100 and averageConcentration > 30[set concentrationReporter "medium"][set concentrationReporter "low"]]
  ifelse averageFomiteRisk > 90 [set fomiteReporter "high"][ifelse averageFomiteRisk <= 90 and averageFomiteRisk > 70[set fomiteReporter "medium"][set fomiteReporter "low"]]


  if ticks > length-of-service * 3600 and count customers = 0[stop]

  tick
end


to-report mouse-clicked?
  report (mouse-was-down? = true and not mouse-down?)
end


to mouse-manager
  let mouse-is-down? mouse-down?
  let spawn false
  let no 100
  if mouse-clicked? [
    ask patch mouse-xcor mouse-ycor [
      if any? turtles-here with [(breed = customers or breed = waiters or breed = bartenders)][
        ask turtles-here with [(breed = customers or breed = waiters or breed = bartenders)][set infected true set shape "infectedturtle" ask patches with [patchType = "door"][set fomiteInfectedDoor true]]
      ]
      if any? turtles-here with [breed = tablesOfTwo or breed = tablesOfSix or breed = tablesOfEight][
        ask turtles-here with [breed = tablesOfTwo or breed = tablesOfSix or breed = tablesOfEight][set no number]
        ask one-of nodes with [tableNumber = no][
          if occupied = false[
            set spawn true
          ]
        ]
      ]
    ]
    if spawn = true [

      carefully[

        let sizeT 0
        let tNo 1

        ask one-of nodes with [tableNumber = no] [
            set occupied true
            set entryTick ticks

          show no
            ask link-neighbors[
              if breed = chairs [
                set sizeT [tableSize] of myself
                set tNo [tableNumber] of myself
              ]
            ]
          ]
          spawn-customers sizeT tNo false
      ]
      [
        show "issue"
  ]
    set no 100
    ]

  ]
  set mouse-was-down? mouse-is-down?
end


to spawn-screens

  let numberOfScreens 11
  let screensXCoordsList [-9.5 -9.5 -6.5 -6.5 -9.5 -9.5 -5.5 -3 -3.5 -5.5 -2.5]
  let screensYCoordsList [-7.5 -3.5 -3 1 1.5 5.5 5.5 1.5 -3 -7.5 -7.5]
  create-screens numberOfScreens

  let l 0
  while[l < numberOfScreens][
    ask screen numberOfTablesAndChairs [setxy item l screensXCoordsList item l screensYCoordsList
      set shape "line"
      set size 3
      set color black]

    set l l + 1
    set numberOfTablesAndChairs numberOfTablesAndChairs + 1

  ]

  ask screen 151 [set heading 90]
  ask screen 152 [set heading 100]
  ask screen 153 [set heading 70]
  ask screen 154 [set heading 110]
  ask screen 155 [set heading 80]
  ask screen 156 [set heading 90]
  ask screen 157 [set heading 90]
  ask screen 158 [set heading 90]
  ask screen 159 [set heading 90]
  ask screen 160 [set heading 90]
  ask screen 161 [set heading 90]

end


to fomite-control

  if ticks mod 1800 = 0 [ask patches with [patchType = "door"][set fomiteInfectedDoor false]]

  ask customers with [infected != true] [

    if [fomiteInfected] of one-of nodes with [tableNumber = [assignedTable] of myself] = true and ticks-since-here mod 120 = 0 and handContamination < 5[

      set handContamination handContamination + 1
    ]
    if [fomiteInfected] of one-of nodes with [tableNumber = [assignedTable] of myself] = true and ticks-since-here mod 60 = 0 and handContamination >= 5[

      set handContamination handContamination + 1
    ]
    ifelse masks = true [
      if ticks-since-here mod 667 = 0 and handContamination != 0 [set fomiteRisk fomiteRisk + handContamination] ;5.4 face touches per hour with mask https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7404441/
    ]
    [
      if ticks-since-here mod 180 = 0 and handContamination != 0 [set fomiteRisk fomiteRisk + handContamination];20 pre hour without
    ]

    if sanitiser-on-tables = true and ticks-since-here mod ((diningTime * 60) / 2) = 0[

      set handContamination handContamination * (1 - (handwashing-thoroughness / 100))
    ]
  ]


  ifelse doors-open = true [
    ask patches with [pxcor > 7 and pxcor < 12 and pycor = -14] [set pcolor white]
  ]
  [
    ask patches with [pxcor > 7 and pxcor < 12 and pycor = -14] [set pcolor grey]
  ]

  ask patches with [patchType = "door"][

    if pcolor = grey[
      if fomiteInfectedDoor = true[
        if any? customers-here with [infected != true][

          ask customers-here [set handContamination handContamination + 1]
        ]
      ]

      if any? customers-here with [infected = true][

        set fomiteInfectedDoor true
      ]
    ]
  ]

  set averageFomiteRiskTemp 0
  if count turtles with [(breed = waiters or breed = customers or breed = bartenders) and infected = 0] > 0[

    ask turtles with [(breed = waiters or breed = customers or breed = bartenders) and infected = 0][set averageFomiteRiskTemp averageFomiteRiskTemp + fomiteRisk]


    set averageFomiteRisk averageFomiteRiskTemp / count turtles with [(breed = waiters or breed = customers or breed = bartenders) and infected = 0]
  ]

  set averageHandTemp 0
  if count turtles with [(breed = waiters or breed = customers or breed = bartenders) and infected = 0] > 0[

    ask turtles with [(breed = waiters or breed = customers or breed = bartenders) and infected = 0][set averageHandTemp averageHandTemp + handContamination]


    set averageHand averageHandTemp / count turtles with [(breed = waiters or breed = customers or breed = bartenders) and infected = 0]
  ]


end


to protection-control
  ifelse masks = true[

    ask turtles with [breed = waiters or breed = bartenders][
      set inhalationProtection 100 - mask-effectiveness-inhalation
      set emissionProtection 100 - mask-effectiveness-emission

    ]

    ask customers[

      ifelse ([hasFood] of one-of nodes with [tableNumber = [assignedTable] of myself]) = false[
        set inhalationProtection 100 - mask-effectiveness-inhalation
        set emissionProtection 100 - mask-effectiveness-emission
      ]
      [
        set inhalationProtection 100
        set emissionProtection 100
      ]
    ]

  ]
  [
    ask turtles with [breed = customers or breed = waiters or breed = bartenders][
      set inhalationProtection 100
      set emissionProtection 100
    ]
  ]


end


to risk-control

  ask turtles with [(breed = customers or breed = waiters or breed = bartenders) and infected = 0][

    set risk risk + ((([concentration] of patch-here / 125000) * 100) * (inhalationProtection / 100))

    if risk >= 300 [set color orange + 2 if counted = 0 [set totalPutAtRisk totalPutAtRisk + 1 set counted true]]

  ]
  ask turtles with [(breed = customers or breed = waiters or breed = bartenders) and infected = true][

    if counted = 0 [set total-infectious total-infectious + 1 set counted true]

  ]

  set percentagePutAtRisk (totalPutAtRisk / (total-customers + count waiters + count bartenders)) * 100

end


to airflow-control

  if top-windows-open = false and left-windows-open = false[

    ask patches with [patchType = "topWindow"][set pcolor blue ]
    ask patches with [patchType = "leftWindow"][set pcolor blue ]

    set topWindowOpen false
    set leftWindowOpen false

  ]

  if top-windows-open = true and left-windows-open = false[
    ask patches with [patchType = "topWindow"][set pcolor white ]
    ask patches with [patchType = "leftWindow"][set pcolor blue ]

    if topWindowOpen != true or leftWindowOpen != false[

      top-airpaths
    ]
    ventilation
  ]

  if top-windows-open = false and left-windows-open = true[
    ask patches with [patchType = "topWindow"][set pcolor blue ]
    ask patches with [patchType = "leftWindow"][set pcolor white ]

    if topWindowOpen != false or leftWindowOpen != true[

      left-airpaths

    ]
    ventilation
  ]

  if top-windows-open = true and left-windows-open = true[
    ask patches with [patchType = "topWindow"][set pcolor white ]
    ask patches with [patchType = "leftWindow"][set pcolor white ]

    if topWindowOpen != true or leftWindowOpen != true[

      left-top-airpaths

    ]
    ventilation
  ]

end


to infection

  set averageConcentrationTemp 0
  ask patches with [patchType = 0][set averageConcentrationTemp averageConcentrationTemp + concentration]
  set averageConcentration averageConcentrationTemp / count patches with [patchType = 0]

  set averageSpeedTemp 0
  ask patches with [patchType = 0][set averageSpeedTemp averageSpeedTemp + airTransfer]
  set averageSpeed averageSpeedTemp / count patches with [ patchType = 0]


  set averageRiskTemp 0
  if count turtles with [(breed = waiters or breed = customers or breed = bartenders) and infected = 0] > 0[
    ask turtles with [(breed = waiters or breed = customers or breed = bartenders) and infected = 0][set averageRiskTemp averageRiskTemp + risk]
    set averageRisk averageRiskTemp / count turtles with [(breed = waiters or breed = customers or breed = bartenders) and infected = 0]
  ]

  if recirculation = true[
    if ticks mod 10 = 0 [
      ask acOuts [
        let me self
        ask patches with [distance me <= 4 and patchType != "entry" and patchType != "outside" and patchType != "wall" and patchType != "door" and patchType != "bar" and patchType != "leftWindow" and patchType != "topWindow"][

          if distance me <= 4[
            set concentration concentration + (((averageConcentrationTemp) * ((100 / ((60 / air-refresh-rate) * 60)) / 100)) / 7.7625)
            show averageConcentrationTemp
          ]
        ]
      ]
    ]
  ]



  ask patches with [patchType = 0] [
    if concentration > 0 [set concentration concentration - (concentration * ((100 / (3600 / (air-refresh-rate + noOfPortableHEPA))) / 100))]
    ifelse exaggerated-colouring = true [set colourIntensity 1000][set colourIntensity 2000]
    set pcolor scale-color red concentration colourIntensity 0
    if concentration > 200 and ticks mod 10 = 0 [
      set concentration concentration - 50
      ask patches with [patchType = 0][
        set concentration concentration + (50 / count patches with [patchType != "entry" and patchType != "wall" and patchType != "outside" and patchType != "door" and patchType != "topWindow" and patchType != "leftWindow"])
      ]
    ]
  ]

  ask turtles with [(breed = waiters or breed = bartenders or breed = customers) and infected = true] [
    let me self

    ifelse volume = 50 [set constant-output 135 * 0.269 * (emissionProtection / 100)]
    [
      ifelse volume = 60 [set constant-output 189 * 0.269 * (emissionProtection / 100)]
      [
        if volume = 70[set constant-output 309 * 0.269 * (emissionProtection / 100)]
      ]
    ]

    ask patch-here [
      set concentration concentration + ((constant-output / 4 / 5.4 ))
      ask patches with [distance myself < 2 and distance myself >= 1 and patchType = 0] [
        set concentration concentration + (constant-output / 4 / (count patches with [distance myself < 2 and distance myself >= 1 and patchType = 0]) / 5.4)
      ]
      ask patches with [distance myself >= 2 and distance myself < 3 and patchType = 0][
        set concentration concentration + (constant-output / 4 /  (count patches with [distance myself >= 2 and distance myself < 3 and patchType = 0]) / 5.4)
      ]
      ask patches with [patchType = 0][set concentration concentration + (constant-output / 4) /  (count patches with [distance myself >= 3 and patchType = 0]) / 5.4]
    ]

    if time-in-restaurant mod (cough-frequency * 60) = 0  and coughing = true [
      ;https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7132666/#bib15 3000 40000
      ask patches in-cone 6 45 [if patchType != "outside" and patchType != "wall" and patchType != "leftWindow" and patchtype != "topWindow" and patchType != "door"[set concentration concentration + (((3000 * 0.35) / [count patches with [patchType = 0] in-cone 6 45] of myself) * ((100 - mask-effectiveness-emission) / 100))]]
      set coughQueued false
      show "coughhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh"


      ask other turtles in-cone 4 30 [
        if breed = tablesOfTwo or breed = tablesOfSix or breed = tablesOfEight [set fomiteInfected true set color red]
        if (breed = customers or breed = waiters or breed = bartenders) and ([heading] of self < [heading] of me + 270 and [heading] of self > [heading] of me + 90)[set risk risk + 4 * ((100 - mask-effectiveness-emission) / 100)]
      ]
      ask turtles with [(breed = tablesOfTwo or breed = tablesOfSix or breed = tablesOfEight) and fomiteInfected = true][ask one-of nodes with [tableNumber = [number] of myself][set fomiteInfected true]]

    ]


    if time-in-restaurant mod (sneeze-frequency * 60) = 0 and sneezing = true  [

      ask patches in-cone 12 30 [if patchType != "outside" and patchType != "wall" and patchType != "leftWindow" and patchtype != "topWindow" and patchType != "door" [set concentration concentration + (((40000 * 0.35) / [count patches with [patchType = 0] in-cone 12 30] of myself) * ((100 - mask-effectiveness-emission) / 100))]]
      show "sneeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeze"


      ask turtles in-cone 4 30 [
        if (breed = tablesOfTwo or breed = tablesOfSix or breed = tablesOfEight) [set fomiteInfected true set color red]
        if (breed = customers or breed = waiters or breed = bartenders) and ([heading] of self < [heading] of me + 270 and [heading] of self > [heading] of me + 90)[set risk risk + 48 * ((100 - mask-effectiveness-emission) / 100)]
      ]

      ask turtles with [(breed = tablesOfTwo or breed = tablesOfSix or breed = tablesOfEight) and fomiteInfected = true][ask one-of nodes with [tableNumber = [number] of myself][set fomiteInfected true]]

    ]
  ]



end


to ventilation

  ask patches with [patchType = 0][
    ifelse pushPull = 0[
      ask patch-at-heading-and-distance airDirection 1 [ set concentration concentration + ([concentration] of myself) * airTransfer]
      set concentration concentration * (1 - airTransfer)
    ]
    [
      ask patch-at-heading-and-distance airDirection 1 [ set concentration concentration + ([concentration] of myself ) *  airTransfer]
      set concentration concentration * (1 - airTransfer)

      set concentration concentration + ([concentration] of patch-at-heading-and-distance (pullDir + 180) 1) * airTransfer
      ask patch-at-heading-and-distance (pullDir + 180) 1 [set concentration concentration * (1 - airTransfer)]
    ]
  ]

  ask patches with [patchType = "topWindow" or patchType = "outside" or patchType = "leftWindow"][set concentration 0]

end


to spawn-acOut

  let numberOfAcOuts 4
  create-acOuts numberOfAcOuts
  set numberOfTablesAndChairs numberOfTablesAndChairs + numberOfAcOuts

  ask acOut (numberOfTablesAndChairs - 4) [setxy -12 -1  set shape "square" set color pink set heading 90]
  ask acOut (numberOfTablesAndChairs - 3) [setxy 0 14 set shape "square" set color pink set heading 180]
  ask acOut (numberOfTablesAndChairs - 2) [setxy 12 6 set shape "square" set color pink set heading 270]
  ask acOut (numberOfTablesAndChairs - 1) [setxy 12 -8 set shape "square" set color pink set heading 270]

end


to acOff
  set air-refresh-rate 0.000001
end


to closeWindows
  set left-windows-open false
  set top-windows-open false
end


to grid

  let j 1
  let k -11
  let l 13

  while [l > -14][

    while [k < 12][

      ask patch k l [set gridSquare j ]
      ask patch k (l - 1) [set gridSquare j ]
      ask patch k (l - 2) [set gridSquare j ]

      ask patch (k + 1) l [set gridSquare j ]
      ask patch (k + 1) (l - 1) [set gridSquare j ]
      ask patch (k + 1) (l - 2) [set gridSquare j ]

      ask patch (k + 2) l [set gridSquare j ]
      ask patch (k + 2) (l - 1) [set gridSquare j ]
      ask patch (k + 2) (l - 2) [set gridSquare j]

      set k k + 3
      set j j + 1

    ]

    set l l - 3
    set k -11

  ]
  ask patches with [pxcor = 12][set gridSquare 0]

end


to schedule

  ask nodes with [occupied = true and nodeType = "table"] [

    let timeOccupied ticks - entryTick + 1

    if (diningTime * 60) / timeOccupied < 20 and visits = 0[ ; does the table need a drinks order taken
      set needsDrinksOrder true ; set state to needs drinks order
    ]

    if (diningTime * 60) / timeOccupied < 12 and visits = 1 and needsDrinksOrder = false [
      set needsDrink true
      ;show "needs drink"
    ]

    if (diningTime * 60) / timeOccupied < 6 and visits = 2[
      set needsOrder true
      ;show "needs order"
    ]
    if (diningTime * 60) / timeOccupied < 2.4 and visits = 3[
      set needsFood true
      ;show "needs food"
    ]
    if (diningTime * 60) / timeOccupied < 2.222 and visits = 4[
      set needsCheckback true
      ;show "needs checkback"
    ]
    if (diningTime * 60) / timeOccupied < 1.333333 and visits = 5[
      set needsCleared true
      ;show "needs cleared"
    ]
    if (diningTime * 60) / timeOccupied < 1.15 and visits = 6[
      set needsBill true
      ;show "needs bill"
    ]

    ; schedule calculation
    ; drinks order - 180 - 3 mins drinks order (diningTime)3600/180(time-occupied) = 20
    ; food order - 600 - 10 mins food order 3600/600 = 6
    ; needs food - 1500 - 25 mins get food 3600/1500 = 2.4
    ;checkback - 1620 - 27 mins checkback 3600/1620 = 2.22222222
    ; cleared - 2700 - 45 mins clear plates 3600/2700 = 1.33333333
    ; leave - 3600 - 1 hour leave 3600/3600 = 1

  ]

  ask nodes with [occupied = false and visits = 7][set needsSanitised true] ;show "needs santised"]
  ask nodes with [occupied = false and visits = 8 and needsSanitised = false][set visits 0 ];show "table reset"]

end


to waiter-movement

  ask waiters[

    let local-location location
    let local-next-location next-location
    let local-final-location final-location
    let local-busy busy
    let stay-here-for 30
    let me self

    if [nodeType] of final-location = "table" [set assignedTable [tableNumber] of final-location]
    set time-in-restaurant time-in-restaurant + 1
    ifelse location = final-location [set moving false if [nodeType] of location = "table" [face one-of turtles with [(breed = tablesOfTwo or breed = tablesOfSix or breed = tablesOfEight) and number = [assignedTable] of me]]][set moving true]


    ifelse distance final-location < 1[
      move-to final-location
      set location final-location
      set local-location final-location


      if [ticks-since-here] of me > stay-here-for ; if been here for more than 30 ticks
      [
        set ticks-since-here 0

        ifelse count nodes with [needsOrder = true and beingServed = false] > 0 and busy = false[
          ask one-of nodes with [needsOrder = true][ ; ask all nodes
            set local-final-location self
            set local-busy true
            set beingServed true
            set visits 3
            ;show "getting order"
          ]
        ]
        [
          ifelse count nodes with [needsFood = true and beingServed = false] > 0 and busy = false[
            ask one-of nodes with [needsFood = true][ ; ask all nodes
              set local-final-location self
              set local-busy true
              set beingServed true
              set visits 4
              ;show "getting food"
            ]
          ]
          [
            ifelse count nodes with [needsCheckback = true and beingServed = false] > 0 and busy = false[
              ask one-of nodes with [needsCheckback = true][ ; ask all nodes
                set local-final-location self
                set local-busy true
                set beingServed true
                set visits 5
                ;show "getting checkback"
              ]
            ]
            [
              ifelse count nodes with [needsCleared = true and beingServed = false] > 0 and busy = false[
                ask one-of nodes with [needsCleared = true][ ; ask all nodes
                  set local-final-location self
                  set local-busy true
                  set beingServed true
                  set visits 6
                  ;show "getting cleared"
                ]
              ]
              [
                ifelse count nodes with [needsBill = true and beingServed = false] > 0 and busy = false[
                  ask one-of nodes with [needsBill = true][ ; ask all nodes
                    set local-final-location self
                    set local-busy true
                    set beingServed true
                    set visits 7
                    ;show "getting bill"
                  ]
                ]
                [
                  ifelse count nodes with [needsSanitised = true and beingServed = false] > 0 and busy = false[
                    ask one-of nodes with [needsSanitised = true][ ; ask all nodes
                      set local-final-location self
                      set local-busy true
                      set beingServed true
                      set visits 8



                      ;show "getting sanitised"
                    ]
                  ]
                  [
                    if busy = true[
                      set local-final-location one-of nodes with [nodeType = "waitingNode" and occupied = false]
                    ]
                    set local-busy false
                    face one-of nodes with [nodeType = "centreNode"]

                  ]
                ]
              ]
            ]
          ]
        ]

        ask location [

          ifelse needsOrder = true [
            set needsOrder false
            set beingServed false
            ;show "order taken"
          ]
          [
            ifelse needsFood = true[
              set needsFood false
              set hasFood true
              set beingServed false
              ;show "food arrived"
            ]
            [
              ifelse needsCheckback = true [
                set needsCheckback false
                set beingServed false
                ;show "checkback complete"
              ]
              [
                ifelse needsCleared = true[
                  set needsCleared false
                  set hasFood false
                  set beingServed false
                  ;show "clearing complete"
                ]
                [
                  ifelse needsBill = true[
                    set needsBill false
                    set beingServed false
                    ;show "bill received"
                  ]
                  [
                    if needsSanitised = true[
                      set needsSanitised false
                      set beingServed false

                      set fomiteInfected false
                      ask one-of turtles with [(breed = tablesOfTwo or breed = tablesOfSix or breed = tablesOfEight) and number = [tableNumber] of myself][set fomiteInfected false set color green ]

                      ;show "sanitisation complete"
                    ]
                  ]
                ]
              ]
            ]
          ]
        ]


        set final-location local-final-location
        set busy local-busy
        set local-final-location final-location
        ;set next-location one-of [link-neighbors] of location

        ask location [ ; ask current location for closest neighbor

          let closestDistance 1000.0
          let closestNode one-of link-neighbors

          ask link-neighbors [

            if (distance local-final-location) <= closestDistance and breed = nodes[
              set closestDistance distance local-final-location
              set closestNode self

            ]
          ]

          set local-next-location closestNode

        ]
        set next-location local-next-location
      ]
      set ticks-since-here ticks-since-here + 1

    ]
    [
      ifelse distance next-location < 1
      [
        move-to next-location
        set location next-location
        set local-location next-location
        ;set next-location one-of [link-neighbors] of location
        ask location [

          let closestDistance 1000.0
          let closestNode one-of link-neighbors

          ask link-neighbors [

            if (distance local-final-location) <= closestDistance and breed = nodes[
              set closestDistance distance local-final-location
              set closestNode self

            ]
          ]

          ask closestNode [set color red]
          set local-next-location closestNode
        ]
        set next-location local-next-location
      ]
      [
        face next-location
        fd 1
      ]
    ]

  ]


end


to customer-movement

  ask customers [

    let local-location location
    let local-next-location next-location
    let local-final-location final-location
    let me self

    set time-in-restaurant time-in-restaurant + 1

    set ticks-since-here ticks-since-here + 1


    if atTable = false[

      ifelse distance final-location < 1[
        set atTable true
        move-to final-location
        set location final-location
        set local-location final-location

        set final-location one-of other nodes
        set local-final-location final-location
        ;set next-location one-of [link-neighbors] of location

        set final-location local-final-location

        ask location [

          let closestDistance 1000.0
          let closestNode one-of link-neighbors

          ask link-neighbors [

            if (distance local-final-location) <= closestDistance and breed = nodes[
              set closestDistance distance local-final-location
              set closestNode self

            ]
          ]
          set local-next-location closestNode
        ]
        set next-location local-next-location
      ]
      [
        ifelse distance next-location < 1 and atTable = false
        [
          move-to next-location
          set location next-location
          set local-location next-location
          ;set next-location one-of [link-neighbors] of location
          ask location [

            let closestDistance 1000.0
            let closestNode one-of link-neighbors

            ask link-neighbors [

              if (distance local-final-location) <= closestDistance and breed = nodes[
                set closestDistance distance local-final-location
                set closestNode self

              ]
            ]
            set local-next-location closestNode
            ask closestNode [set color red]
          ]
          set next-location local-next-location
        ]
        [
          face next-location
          fd 1
        ]
      ]
    ]


    ;sitting process
    if atTable = true and sat = false[
      carefully[
        move-to one-of chairs with [tableNo = [assignedTable] of myself and chairTaken = false] ; ask customer to move to one of the empty chairs at assigned table
        set sat true ; set sat true
        ask chairs [if any? turtles-here with [breed = customers][set chairTaken true]] ; if a customers is on a chaiur set chait taken to true
        face one-of turtles with [(breed = tablesOfTwo or breed = tablesOfSix or breed = tablesOfEight) and nodeType = "physicalTable" and number = [assignedTable] of myself] ; face the table
      ]
      [show "error"
        ask chairs [if not any? turtles-here with [breed = customers] [set chairTaken false]]] ; try again if unsuccessful
    ]


    ;leaving process
    let local-visits 0
    ask nodes with [tableNumber = [assignedTable] of myself][set local-visits visits]
    if ticks-since-here > (diningTime * 60) and local-visits >= 7 [ ; if customer has been here for a long time tell them to leave
      set atTable false
      set sat false
      set final-location one-of nodes with [nodeType = "spawnDespawn"]

      ask chairs with [tableNo = [assignedTable] of myself][set chairTaken false] ; set their chair to not taken
      ask nodes with [tableNumber = [assignedTable] of myself][set occupied false] ; set their table to not occupied
      ask location [if nodeType = "spawnDespawn"[ask myself[die]]]

    ]

    ifelse sat = true [set moving false][set moving true]
  ]

end


to bartender-movement

  ask bartenders[

    let local-location location
    let local-next-location next-location
    let local-final-location final-location
    let local-busy busy
    let stay-here-for 30
    let me self


    set time-in-restaurant time-in-restaurant + 1
    if [nodeType] of final-location = "table" [set assignedTable [tableNumber] of final-location]
    ifelse location = final-location [set moving false if [nodeType] of location = "table" [face one-of turtles with [(breed = tablesOfTwo or breed = tablesOfSix or breed = tablesOfEight) and number = [assignedTable] of me]]][set moving true]


    ifelse distance final-location < 1[
      move-to final-location
      set location final-location
      set local-location final-location



      if [ticks-since-here] of me > stay-here-for ; if been ohere for more than 30 ticks
      [
        set ticks-since-here 0

        ifelse count nodes with [needsDrinksOrder = true and beingServed = false] > 0 and busy = false[
          ask one-of nodes with [needsDrinksOrder = true][ ; ask all nodes
            set local-final-location self
            set local-busy true
            set beingServed true
            set visits 1
            ;show "getting drinks order"
          ]
        ]
        [
          ifelse count nodes with [needsDrink = true and beingServed = false] > 0 and busy = false[
            ask one-of nodes with [needsDrink = true][ ; ask all nodes
              set local-final-location self
              set local-busy true
              set beingServed true
              set visits 2
              ;show "getting drinks"
            ]
          ]
          [
            if busy = true[set local-final-location one-of nodes with [nodeType = "barNode"]]
            set local-busy false
            face one-of nodes with [nodeType = "centreNode"]
          ]
        ]

        ask location [

          ifelse needsDrinksOrder = true [
            set needsDrinksOrder false
            set beingServed false
            ;show "drinks order received"
          ]
          [
            if needsDrink = true[
              set needsDrink false
              set beingServed false
              ;show "drinks received"
            ]
          ]
        ]


        set final-location local-final-location
        set busy local-busy
        set local-final-location final-location
        ;set next-location one-of [link-neighbors] of location

        ask location [ ; ask current location for closest neighbor

          let closestDistance 1000.0
          let closestNode one-of link-neighbors

          ask link-neighbors [

            if (distance local-final-location) <= closestDistance and breed = nodes[
              set closestDistance distance local-final-location
              set closestNode self

            ]
          ]

          set local-next-location closestNode

        ]
        set next-location local-next-location
      ]
      set ticks-since-here ticks-since-here + 1

    ]
    [
      ifelse distance next-location < 1
      [
        move-to next-location
        set location next-location
        set local-location next-location
        ;set next-location one-of [link-neighbors] of location
        ask location [

          let closestDistance 1000.0
          let closestNode one-of link-neighbors

          ask link-neighbors [

            if (distance local-final-location) <= closestDistance and breed = nodes[
              set closestDistance distance local-final-location
              set closestNode self

            ]
          ]

          ask closestNode [set color red]
          set local-next-location closestNode
        ]
        set next-location local-next-location
      ]
      [
        face next-location
        fd 1
      ]
    ]
  ]
end


to chef-movement

  ask chefs[

    let local-location location
    let local-next-location next-location
    let local-final-location final-location
    let stay-here-for 60
    let me self


    ifelse distance final-location < 1[
      move-to final-location
      set location final-location
      set local-location final-location


      if [ticks-since-here] of me > stay-here-for ; if been ohere for more than 30 ticks
      [
        set ticks-since-here 0

        ask one-of nodes with [nodeType = "kitchenNode"][ ; ask all nodes
          set local-final-location self
        ]

        set final-location local-final-location
        set local-final-location final-location
        ;set next-location one-of [link-neighbors] of location

        ask location [ ; ask current location for closest neighbor

          let closestDistance 1000.0
          let closestNode one-of link-neighbors

          ask link-neighbors [

            set closestNode self


          ]
          set local-next-location closestNode
        ]
        set next-location local-next-location
      ]
      set ticks-since-here ticks-since-here + 1
    ]
    [
      ifelse distance next-location < 1
      [
        move-to next-location
        set location next-location
        set local-location next-location
        ;set next-location one-of [link-neighbors] of location
        ask location [

          let closestDistance 1000.0
          let closestNode one-of link-neighbors

          ask link-neighbors [
            set closestNode self
          ]
          ask closestNode [set color red]
          set local-next-location closestNode
        ]
        set next-location local-next-location
      ]
      [
        face next-location
        fd 0.5
      ]
    ]
  ]

end


to spawn-waiters

  let numberOfWaiters noOfWaiters
  create-waiters numberOfWaiters [
    move-to one-of nodes with [nodeType = "waitingNode"]
    set location one-of nodes with [nodeType = "waitingNode"]
    set color black
    set busy false
    set final-location one-of nodes with [nodeType = "waitingNode"]
    set next-location one-of [link-neighbors] of location
    set coughQueued false
    set sneezeQueued false

    let infectedChance random 10000
    if infectedChance < (chance-of-being-infected * 100) [set infected true set shape "infectedTurtle"]
  ]

end


to customer-table-assignment

  carefully[
    let sizeT 0
    let tNo 1

    ifelse ticks mod 300 = 0 and any? nodes with [nodeType = "table" and occupied = false and needsSanitised = false] and (count customers + count waiters + count bartenders) < capacity and ticks < length-of-service * 3600[

      ask one-of nodes with [nodeType = "table" and occupied = false and (count customers + count waiters + count bartenders + tableSize) <= capacity] [
        set occupied true
        set entryTick ticks
        set lastTableEntry ticks
        ask link-neighbors[
          if breed = chairs [
            set sizeT [tableSize] of myself
            set tNo [tableNumber] of myself
          ]
        ]
      ]
      spawn-customers sizeT tNo false

    ]
    [

    ]
  ]
  [
    show "issue"
  ]

end


to spawn-customers[num tab queue]

  let numberOfCustomers num
  let holder num
  create-customers numberOfCustomers [

    move-to one-of nodes with [nodeType = "spawnDespawn"]

    set location one-of nodes with [nodeType = "spawnDespawn"]
    set color 83
    set atTable false
    set sat false
    set toiletUse false
    set sinkUse false
    set toiletUsed false
    set sinkUsed false
    set stayLength diningTime * 60
    set assignedTable tab
    set final-location one-of nodes with [tableNumber = tab]
    set next-location one-of [link-neighbors] of location
    set heading 0
    set coughQueued false
    set sneezeQueued false

    set assignedChair holder
    set holder holder - 1

    set total-customers total-customers + 1

    let infectedChance random 10000
    if infectedChance < (chance-of-being-infected * 100) [set infected true set shape "infectedTurtle"]

    set sinkUse true
  ]

end


to spawn-bartenders

  let numberOfBartenders 1
  create-bartenders numberOfBartenders [
    move-to one-of nodes with [nodeType = "barNode"]
    set location one-of nodes with [nodeType = "barNode"]
    set color violet
    set busy false
    set final-location one-of nodes with [nodeType = "barNode"]
    set next-location one-of [link-neighbors] of location
    set coughQueued false
    set sneezeQueued false

    let infectedChance random 10000
    if infectedChance < (chance-of-being-infected * 100) [set infected true set shape "infectedTurtle"]

  ]

end


to spawn-chefs

  let numberOfChefs 2
  create-chefs numberOfChefs [
    move-to one-of nodes with [nodeType = "kitchenNode"]
    set location one-of nodes with [nodeType = "kitchenNode"]
    set color grey
    set final-location one-of nodes with [nodeType = "kitchenNode"]
    set next-location one-of [link-neighbors] of location

    let infectedChance random 100
    if infectedChance < chance-of-being-infected [set infected true]
  ]

end


to spawn-twos

  let numberOfTwos 11
  let tableOfTwoXCoordsList [-9.5 -9.5 -9.5 -9.5 -5.5 -5.5 -3.5 -5.5 -5.5 -2.5 -2.5]
  let tableOfTwoYCoordsList [-9.5 -5.5 3.5 7.5 7.5 3.5 -0.5 -5.5 -9.5 -5.5 -9.5]
  create-tablesOfTwo numberOfTwos

  let i 0
  while[i < numberOfTwos][
    ask tableOfTwo numberOfTablesAndChairs [setxy item i tableOfTwoXCoordsList item i tableOfTwoYCoordsList set shape "tableOfTwo" set size 2 set color green set nodeType "physicalTable"]
    set i i + 1
    set numberOfTablesAndChairs numberOfTablesAndChairs + 1
  ]

  ask tableOfTwo 0 [set number 1 ]
  ask tableOfTwo 1 [set number 2 ]
  ask tableOfTwo 2 [set number 4 ]
  ask tableOfTwo 3 [set number 5]
  ask tableOfTwo 4 [set number 6 ]
  ask tableOfTwo 5 [set number 7 ]
  ask tableOfTwo 6 [set number 8 ]
  ask tableOfTwo 7 [set number 9 ]
  ask tableOfTwo 8 [set number 10 ]
  ask tableOfTwo 9 [set number 12]
  ask tableOfTwo 10 [set number 11]

end


to spawn-twos-2

  let numberOfTwos 10
  let tableOfTwoXCoordsList [-10.5 -10.5 -8.5 -1.5 5.5 -2 -2.5 -2.5 -6.5 -6.5]
  let tableOfTwoYCoordsList [-8.5 -1.5 12.5 12.5 12.5 5.5 -1.5 -8.5 -8.5 -1.5]
  create-tablesOfTwo numberOfTwos

  let i 0
  while[i < numberOfTwos][
    ask tableOfTwo numberOfTablesAndChairs [setxy item i tableOfTwoXCoordsList item i tableOfTwoYCoordsList set shape "tableOfTwo" set size 2 set color green set nodeType "physicalTable"]
    set i i + 1
    set numberOfTablesAndChairs numberOfTablesAndChairs + 1
  ]

  ask tableOfTwo 0 [set number 1 ]
  ask tableOfTwo 1 [set number 2 ]
  ask tableOfTwo 2 [set number 4 ]
  ask tableOfTwo 3 [set number 5 ]
  ask tableOfTwo 4 [set number 6 ]
  ask tableOfTwo 5 [set number 7 ]
  ask tableOfTwo 6 [set number 11 ]
  ask tableOfTwo 7 [set number 10 ]
  ask tableOfTwo 8 [set number 9 ]
  ask tableOfTwo 9 [set number 8 ]

end


to spawn-sixs

  let numberOfSixs 3
  let tableOfSixXCoordsList [1.5 1.5 1.5]
  let tableOfSixYCoordsList [2 -3 -8]
  create-tablesOfSix numberOfSixs

  let j 0
  while[j < numberOfSixs][
    ask tableOfSix numberOfTablesAndChairs [
      setxy item j tableOfSixXCoordsList item j tableOfSixYCoordsList
      set shape "tableOfSix"
      set size 4
      set color green
      set nodeType "physicalTable"
      set heading 0]
    set j j + 1
    set numberOfTablesAndChairs numberOfTablesAndChairs + 1
  ]

  ask tableOfSix 11 [set number 14]
  ask tableOfSix 12 [set number 15]
  ask tableOfSix 13 [set number 16]

end


to spawn-sixs-2

  let numberOfSixs 3
  let tableOfSixXCoordsList [3 2 2]
  let tableOfSixYCoordsList [5.5 -1.5 -8.5]
  create-tablesOfSix numberOfSixs

  let j 0
  while[j < numberOfSixs][
    ask tableOfSix numberOfTablesAndChairs [
      setxy item j tableOfSixXCoordsList item j tableOfSixYCoordsList
      set shape "tableOfSix"
      set size 4
      set color green
      set nodeType "physicalTable"
      set heading 90]
    set j j + 1
    set numberOfTablesAndChairs numberOfTablesAndChairs + 1
  ]

  ask tableOfSix 10 [set number 12 ]
  ask tableOfSix 11 [set number 13 ]
  ask tableOfSix 12 [set number 14 ]

end


to spawn-eights

  let numberOfEights 2
  let tableOfEightXCoordsList [-8.5 -0.5]
  let tableOfEightYCoordsList [-1 7.5]
  create-tablesOfEight numberOfEights

  let k 0
  while[k < numberOfEights][
    ask tableOfEight numberOfTablesAndChairs [
      setxy item k tableOfEightXCoordsList item k tableOfEightYCoordsList
      set shape "tableOfEight"
      set size 4
      set color green
      set nodeType "physicalTable"]
    set k k + 1
    set numberOfTablesAndChairs numberOfTablesAndChairs + 1
  ]

  ask tableOfEight 14 [set number 3 ]
  ask tableOfEight 15 [set number 13]

end


to spawn-eights-2

  let numberOfEights 1
  let tableOfEightXCoordsList [-8.5]
  let tableOfEightYCoordsList [6]
  create-tablesOfEight numberOfEights

  let k 0
  while[k < numberOfEights][
    ask tableOfEight numberOfTablesAndChairs [
      setxy item k tableOfEightXCoordsList item k tableOfEightYCoordsList
      set shape "tableOfEight"
      set size 4
      set color green]
    set k k + 1
    set numberOfTablesAndChairs numberOfTablesAndChairs + 1
  ]

  ask tableOfEight 13 [set number 3 set nodeType "physicalTable"]

end


to spawn-largeTable

  let numberOfLargeTables 2
  let tableOfLargeTableXCoordsList [15.5 8.5]
  let tableOfLargeTableYCoordsList [7.5 -1]
  create-largeTables numberOfLargeTables

  let k 0
  while[k < numberOfLargeTables][
    ask largeTable numberOfTablesAndChairs [
      setxy item k tableOfLargeTableXCoordsList item k tableOfLargeTableYCoordsList
      set shape "largeTable"
      set size 20
      set color green]
    set k k + 1
    set numberOfTablesAndChairs numberOfTablesAndChairs + 1
  ]

end


to spawn-chairs

  let numberOfChairs 56
  let chairsXCoordsList [-9.5 -9.5 -9.5 -9.5 -11 -6 -8.5 -8.5 -10 -10 -7 -7 -9.5 -9.5 -9.5 -9.5 -5.5 -5.5 -5.5 -5.5 -3.5 -3.5 -5.5 -5.5 -5.5 -5.5 -2.5 -2.5 -2.5 -2.5 -0.5 -0.5 -3 2 1 1 -2 -2 0 0 0 3 3 3 0 0 0 3 3 3 0 0 0 3 3 3 0 0 ]
  let chairsYCoordsList [-11 -8 -7 -4 -1 -1 -3.5 1.5 -3 1 1 -3 2 5 6 9 6 9 2 5 1 -2 -4 -7 -8 -11 -4 -7 -8 -11 5 10 7.5 7.5 9.5 5.5 9.5 5.5 3 2 1 3 2 1 -2 -3 -4 -2 -3 -4 -7 -8 -9 -7 -8 -9]
  create-chairs numberOfChairs

  let l 0
  while[l < numberOfChairs][
    ask chair numberOfTablesAndChairs [
      setxy item l chairsXCoordsList item l chairsYCoordsList
      set shape "square 2"
      set color yellow
      set chairTaken false
      set clean true
    set heading 0]

    if l > 3 and l < 12 [ask chair numberOfTablesAndChairs [face tableOfEight 14]]
    if l > 30 and l < 39 [ask chair numberOfTablesAndChairs [face tableOfEight 15]]
    set l l + 1
    set numberOfTablesAndChairs numberOfTablesAndChairs + 1
  ]

end


to spawn-chairs-2

  let numberOfChairs 46
  let chairsXCoordsList [-10.5 -10.5 -10.5 -10.5 -8.5 -10 -11 -10 -8.5 -7 -6 -7 -10 -7 -3 4 7 0 -2 -2 -6.5 -6.5 -6.5 -6.5 -2.5 -2.5 -2.5 -2.5 2 3 4 2 3 4 1 2 3 1 2 3 1 2 3 1 2 3]
  let chairsYCoordsList [-10 -7 -3 0 3.5 4 6 8 8.5 8 6 4 12.5 12.5 12.5 12.5 12.5 12.5 7 4 -3 -7 -10 0 -10 -7 -3 0 7 7 7 4 4 4 0 0 0 -3 -3 -3 -7 -7 -7 -10 -10 -10]
  create-chairs numberOfChairs

  let l 0
  while[l < numberOfChairs][
    ask chair numberOfTablesAndChairs [
      setxy item l chairsXCoordsList item l chairsYCoordsList
      set shape "square 2"
      set color cyan
      set chairTaken false
      set clean true
      set heading 0]

    if l > 4 and l < 12 [ask chair numberOfTablesAndChairs [face tableOfEight 13]]

    set l l + 1
    set numberOfTablesAndChairs numberOfTablesAndChairs + 1
  ]

end


to spawn-sinks

  let numberOfSinks 3
  create-sinks numberOfSinks
  set numberOfTablesAndChairs numberOfTablesAndChairs + numberOfSinks

  ask sink (numberOfTablesAndChairs - 3) [setxy -11 -18 set size 2 set shape "sink" set color grey set heading 270]
  ask sink (numberOfTablesAndChairs - 2) [setxy -4 -18 set size 2 set shape "sink" set color grey set heading 270]
  ask sink (numberOfTablesAndChairs - 1) [setxy 10 -5 set size 2 set shape "sink" set color grey set heading 270]

end


to spawn-toilets

  let numberOfToilets 2
  create-toilets numberOfToilets
  set numberOfTablesAndChairs numberOfTablesAndChairs + numberOfToilets

  ask toilet (numberOfTablesAndChairs - 2) [setxy -7 -18 set size 3 set shape "toilet" set color grey set heading 0]
  ask toilet (numberOfTablesAndChairs - 1) [setxy 0 -18 set size 3 set shape "toilet" set color grey set heading 0]

end


to spawn-sanitisation-stations

  let numberOfSanitisationStations 2
  create-sanitisationStations numberOfSanitisationStations
  set numberOfTablesAndChairs numberOfTablesAndChairs + numberOfSanitisationStations

  ask sanitisationStation (numberOfTablesAndChairs - 2) [setxy 10 -15 set size 1 set shape "sanitisationStation" set color grey set heading 0]
  ask sanitisationStation (numberOfTablesAndChairs - 1) [setxy 10 7 set size 1 set shape "sanitisationStation" set color grey set heading 0]

end


to spawn-nodes

  let numberOfNodes 68
  let nodesXCoordsList [-8 -8 -5.5 -5.5 -8 -8 -7 -7 -5 -7 -7 -1 -1 -1.5 -3 3 2 1.5 1.5 1.5 1.5 1.5 1.5 11 22 1.5 4 4 4 4 -2.5 -6 -2 -3.5 -1 4 -1.5 -6 -7 5.5 5.5 5.5 9 9 9 6 11 9 11 -10 -7.5 -7.5 -3 0 -2.5 9 11 10.5 8.5 13 17 14 17 14 14 17 17 2]
  let nodesYCoordsList [-9.5 -5.5 -2.5 0.5 3.5 7.5 3.5 7.5 -0.5 -9.5 -5.5 -9.5 -5.5 4.5 9 9 6 4 0 -1 -5 -6 -10 12.25 12.5 0 -10 -5 0 5.5 3 11 -2.5 6 11 4 -12 -12 5.2 2 -3.5 -8 -10 -11 -16 7 11.5 -12 13 -18 -18 -14 -18 -18 -14 5 -5 3 -8 12 12 2 2 9 5 9 5 -12]
  create-nodes numberOfNodes

  let m 0
  while[m < numberOfNodes][
    ask node numberOfTablesAndChairs [setxy item m nodesXCoordsList item m nodesYCoordsList set size 0.35 set shape "circle" set color black]
    set m m + 1
    set numberOfTablesAndChairs numberOfTablesAndChairs + 1
  ]

  ask node 72 [ set nodeType "table" set tableNumber 1 set tableSize 2 create-link-with node 73 create-link-with node 82]
  ask node 73 [ set nodeType "table" set tableNumber 2 set tableSize 2 create-link-with node 74]
  ask node 74 [ set nodeType "table"set tableNumber 3 set tableSize 8 create-link-with node 80 create-link-with node 82 create-link-with node 104]
  ask node 75 [ create-link-with node 76 create-link-with node 78 create-link-with node 102 create-link-with node 80]
  ask node 76 [ set nodeType "table" set tableNumber 4 set tableSize 2 ]
  ask node 77 [ set nodeType "table"set tableNumber 5 set tableSize 2 create-link-with node 103 ]
  ask node 78 [ set nodeType "table" set tableNumber 7 set tableSize 2 ]
  ask node 79 [ set nodeType "table" set tableNumber 6 set tableSize 2 create-link-with node 103]
  ask node 80 [ set nodeType "table" set tableNumber 8 set tableSize 2]
  ask node 81 [ set nodeType "table" set tableNumber 10 set tableSize 2 create-link-with node 82]
  ask node 82 [ set nodeType "table" set tableNumber 9 set tableSize 2]
  ask node 83 [ set nodeType "table" set tableNumber 11 set tableSize 2 create-link-with node 94 create-link-with node 84]
  ask node 84 [ set nodeType "table"  set tableNumber 12 set tableSize 2 create-link-with node 104]
  ask node 85 [ create-link-with node 89 create-link-with node 105]
  ask node 86 [ create-link-with node 105  create-link-with node 106]
  ask node 87 [ create-link-with node 88 create-link-with node 106  create-link-with node 117]
  ask node 88 [ set nodeType "table"  set tableNumber 13  set tableSize 8 create-link-with node 89 create-link-with node 101 create-link-with node 117]
  ask node 89 [ create-link-with node 101  create-link-with node 107]
  ask node 91 [ create-link-with node 104]
  ask node 92 [ set nodeType "table" set tableNumber 15 set tableSize 6 create-link-with node 99 create-link-with node 84]
  ask node 93 [ create-link-with node 99 create-link-with node 84]
  ask node 94 [set nodeType "table" set tableNumber 16 set tableSize 6]
  ask node 95 [ create-link-with node 87 create-link-with node 106 set nodeType "waitingNode" set occupied false]
  ask node 97 [ set nodeType "table" set tableNumber 14  set tableSize 6 create-link-with node 104]
  ask node 98 [  create-link-with node 99 create-link-with node 94 create-link-with node 119 ]
  ask node 99 [ create-link-with node 100]
  ask node 100 [ create-link-with node 107 create-link-with node 97 create-link-with node 91]
  ask node 101 [ create-link-with node 117 create-link-with node 107 create-link-with node 127]
  ask node 102 [ create-link-with node 104 create-link-with node 85 create-link-with node 85 create-link-with node 89 create-link-with node 105 set nodeType "centreNode"]
  ask node 103 [ create-link-with node 86 create-link-with node 106]
  ask node 104 [ ]
  ask node 105 [ ]
  ask node 106 [ ]
  ask node 107 [ create-link-with node 127]
  ask node 108 [ create-link-with node 83 create-link-with node 94]
  ask node 109 [ create-link-with node 72 create-link-with node 81 create-link-with node 108 ]
  ask node 110 [ create-link-with node 77 create-link-with node 78  create-link-with node 76 create-link-with node 79 create-link-with node 105]
  ask node 111 [ create-link-with node 107  create-link-with node 100]
  ask node 112 [ create-link-with node 111 create-link-with node 99 create-link-with node 100]
  ask node 113 [ create-link-with node 112 create-link-with node 98 create-link-with node 99]
  ask node 114 [ create-link-with node 113 create-link-with node 98 set nodeType "queue"]
  ask node 115 [ create-link-with node 114 set nodeType "queue"]
  ask node 116 [ set nodeType "spawnDespawn"]
  ask node 117 [  create-link-with node 111 create-link-with node 95]
  ask node 118 [ create-link-with node 87 create-link-with node 106 create-link-with node 117 create-link-with node 95 set nodeType "waitingNode" set occupied false]
  ask node 119 [ create-link-with node 116 create-link-with node 115 create-link-with node 108 set nodeType "queue"]
  ask node 120 [ create-link-with node 87 create-link-with node 106  create-link-with node 117  create-link-with node 95 set nodeType "waitingNode" set occupied false]
  ask node 121 [ create-link-with node 122 set nodeType "sink"  set occupied false]
  ask node 122 [ create-link-with node 124]
  ask node 123 [ create-link-with node 121 create-link-with node 122 create-link-with node 72 create-link-with node 109 create-link-with node 108 ]
  ask node 124 [ create-link-with node 125 set nodeType "sink" set occupied false]
  ask node 125 []
  ask node 126 [ create-link-with node 124 create-link-with node 125 create-link-with node 108 create-link-with node 109]
  ask node 127 [ create-link-with node 118 create-link-with node 117 create-link-with node 111]
  ask node 129 [ create-link-with node 128 create-link-with node 127  set nodeType "barNode"]
  ask node 130 [create-link-with node 128 create-link-with node 113  create-link-with node 112 create-link-with node 114 ]
  ask node 131 [ create-link-with node 132 set nodeType "kitchenNode"]
  ask node 132 [create-link-with node 131 create-link-with node 137]
  ask node 133 [create-link-with node 134 ]
  ask node 135 [create-link-with node 131 create-link-with node 136 set nodeType "kitchenNode"]
  ask node 136 [create-link-with node 133 set nodeType "kitchenNode"]
  ask node 137 [create-link-with node 138 set nodeType "kitchenNode"]
  ask node 138 [create-link-with node 134 set nodeType "kitchenNode"]
  ask node 139 [create-link-with node 119 create-link-with node 109 create-link-with node 119 create-link-with node 83]
  ask node 90 [die]
  ask node 96 [die]

  ask nodes [

    if nodeType = "table"[
      set occupied false
      set needsOrder false
      set needsFood false
      set needsDrinksOrder false
      set needsDrink false
      set hasFood false
      set needsCheckback false
      set needsCleared false
      set needsBill false
      set needsSanitised false
      set beingServed false
      set visits 0
    ]
  ]

end


to spawn-nodes-2

  let numberOfNodes 68
  let nodesXCoordsList [-9 -9 -6 -6 -4 -8.5 -1.5 5.5 5 4 4 -0.5 -1 -1 -5 -5 11 11 11 1 7 6 5 0 -4 -8 -2.5 0 0 -4 -8 6 1 -3 -7 5 -4 5 -5 10.5 9 11 8 9 9 9 9 5 0 5 4 13 14 14 14 17 17 17 17 -8 -4 -1 6 -5 0 0 0 0]
  let nodesYCoordsList [-8.5 -1.5 2 4.5 8 11 11 11 5.5 -1.5 -8.5 5.5 -1.5 -8.5 -1.5 -8.5 13 11 9 9 9 3 -5 -6 -6 -6 2 2 -11 -11 -11 -7 -5 -5 -5 1 3 8 8 3 7 -5 -8 -10 -11 -12 -16 -11 0 3 -4 12 9 5 2 2 5 9 12 -3 -3 8 -8 -6 0 0 0 0]
  create-nodes numberOfNodes

  let m 0
  while[m < numberOfNodes][
    ask node numberOfTablesAndChairs [setxy item m nodesXCoordsList item m nodesYCoordsList set size 0.35 set shape "circle" set color black]
    set m m + 1
    set numberOfTablesAndChairs numberOfTablesAndChairs + 1
  ]


  ask node 60[create-link-with node 61 create-link-with node 85 create-link-with node 90 set nodeType "table" set tableSize 2 set tableNumber 1]
  ask node 61[create-link-with node 62 create-link-with node 94 set nodeType "table" set tableSize 2 set tableNumber 2]
  ask node 62[create-link-with node 63 create-link-with node 86 create-link-with node 109 create-link-with node 74]
  ask node 63[create-link-with node 74 create-link-with node 64 set nodeType "table" set tableSize 8  set tableNumber 3 ]
  ask node 64[create-link-with node 98 create-link-with node 121]
  ask node 65[create-link-with node 66 create-link-with node 98 set nodeType "table" set tableSize 2  set tableNumber 4]
  ask node 66[create-link-with node 67 create-link-with node 79 set nodeType "table" set tableSize 2  set tableNumber 5]
  ask node 67[create-link-with node 79 create-link-with node 80 create-link-with node 97 create-link-with node 68 create-link-with node 121 set nodeType "table" set tableSize 2 set tableNumber 6]
  ask node 68[create-link-with node 97 set nodeType "table" set tableSize 6  set tableNumber 12]
  ask node 69[create-link-with node 82 set nodeType "table" set tableSize 6  set tableNumber 13]
  ask node 70[create-link-with node 107 set nodeType "table" set tableSize 6  set tableNumber 14]
  ask node 71[create-link-with node 86 set nodeType "table" set tableSize 2  set tableNumber 7]
  ask node 72[create-link-with node 92 create-link-with node 93 create-link-with node 108 create-link-with node 86 set nodeType "table" set tableSize 2  set tableNumber 11]
  ask node 73[create-link-with node 83 set nodeType "table" set tableSize 2 set tableNumber 10 create-link-with node 72]
  ask node 74[create-link-with node 93 create-link-with node 94 set nodeType "table" set tableSize 2  set tableNumber 8]
  ask node 75[create-link-with node 94 set nodeType "table" set tableSize 2  set tableNumber 9 create-link-with node 72]
  ask node 76[create-link-with node 67 create-link-with node 77 set nodeType "waitingNode" set occupied false]
  ask node 77[create-link-with node 80 create-link-with node 67 create-link-with node 78 set nodeType "waitingNode" set occupied false]
  ask node 78[create-link-with node 80 create-link-with node 100 set nodeType "waitingNode" set occupied false]
  ask node 79[create-link-with node 64 create-link-with node 71]
  ask node 80[create-link-with node 79 create-link-with node 68  create-link-with node 109]
  ask node 81[create-link-with node 95 create-link-with node 108  create-link-with node 80 create-link-with node 99 create-link-with node 109]
  ask node 82[create-link-with node 70 create-link-with node 95 create-link-with node 92 create-link-with node 107 create-link-with node 102 create-link-with node 109]
  ask node 83[create-link-with node 85 create-link-with node 82 create-link-with node 120]
  ask node 84[create-link-with node 75 create-link-with node 93]
  ask node 85[create-link-with node 84]
  ask node 86[create-link-with node 74]
  ask node 87[create-link-with node 95 create-link-with node 86 create-link-with node 71  create-link-with node 81 create-link-with node 108 set nodeType "centreNode"]
  ask node 88[create-link-with node 89 create-link-with node 73 create-link-with node 107]
  ask node 89[create-link-with node 90 create-link-with node 75]
  ask node 90[]
  ask node 91[]
  ask node 92[create-link-with node 91 create-link-with node 83 create-link-with node 93 create-link-with node 102]
  ask node 93[create-link-with node 73 create-link-with node 94 ]
  ask node 94[create-link-with node 85]
  ask node 95[create-link-with node 69 create-link-with node 71  create-link-with node 96]
  ask node 96[create-link-with node 62 create-link-with node 87 create-link-with node 86  create-link-with node 63 create-link-with node 109]
  ask node 97[create-link-with node 79 create-link-with node 121]
  ask node 98[create-link-with node 96]
  ask node 99[set nodeType "barNode" create-link-with node 97]
  ask node 100[create-link-with node 99 create-link-with node 81 create-link-with node 68  create-link-with node 80  create-link-with node 97 create-link-with node 67]
  ask node 101[create-link-with node 99]
  ask node 102[create-link-with node 101 create-link-with node 91 create-link-with node 95 create-link-with node 105]
  ask node 103[create-link-with node 102 create-link-with node 70 set nodeType "queue"]
  ask node 104[create-link-with node 103 set nodeType "queue"]
  ask node 105[create-link-with node 104 create-link-with node 88 create-link-with node 107  create-link-with node 82 create-link-with node 70 set nodeType "queue"]
  ask node 106[create-link-with node 105  set nodeType "spawnDespawn"]
  ask node 107[create-link-with node 102]
  ask node 108[create-link-with node 109]
  ask node 109[create-link-with node 68 create-link-with node 87 create-link-with node 95 create-link-with node 99 create-link-with node 100 create-link-with node 86]
  ask node 110[create-link-with node 69 create-link-with node 92]
  ask node 111[create-link-with node 112 set nodeType "kitchenNode"]
  ask node 112[create-link-with node 113 set nodeType "kitchenNode"]
  ask node 113[create-link-with node 114 set nodeType "kitchenNode"]
  ask node 114[ create-link-with node 115 set nodeType "kitchenNode"]
  ask node 115[create-link-with node 116 set nodeType "kitchenNode"]
  ask node 116[create-link-with node 117 set nodeType "kitchenNode"]
  ask node 117[create-link-with node 118 set nodeType "kitchenNode"]
  ask node 118[create-link-with node 111 set nodeType "kitchenNode"]
  ask node 119[ create-link-with node 93  create-link-with node 61]
  ask node 120[ create-link-with node 92  create-link-with node 74]
  ask node 121[ create-link-with node 71  create-link-with node 66  create-link-with node 65 create-link-with node 79]
  ask node 122[create-link-with node 102 create-link-with node 70]
  ask node 123[create-link-with node 74 create-link-with node 75 create-link-with node 85]
  ask node 124[]
  ask node 91[die]
  ask node 104[die]
  ask node 103[die]
  ask node 81[die]

  ask nodes [

    if nodeType = "table"[
      set occupied false
      set needsOrder false
      set needsFood false
      set needsDrinksOrder false
      set needsDrink false
      set hasFood false
      set needsCheckback false
      set needsCleared false
      set needsBill false
      set needsSanitised false
      set beingServed false
      set visits 0
    ]
  ]

end


to setup-chair-links

  ask chair 16 [create-link-with node 72 set tableNo 1 set chairNo 1]
  ask chair 17 [create-link-with node 72 set tableNo 1 set chairNo 2]
  ask chair 18 [create-link-with node 73 set tableNo 2 set chairNo 1]
  ask chair 19 [create-link-with node 73 set tableNo 2 set chairNo 2]
  ask chair 20 [create-link-with node 73 set tableNo 3 set chairNo 3]
  ask chair 21 [create-link-with node 74 set tableNo 3 set chairNo 7]
  ask chair 22 [create-link-with node 74 set tableNo 3 set chairNo 1]
  ask chair 23 [create-link-with node 75 set tableNo 3 set chairNo 5]
  ask chair 24 [create-link-with node 73 set tableNo 3 set chairNo 2]
  ask chair 25 [create-link-with node 76 set tableNo 3 set chairNo 4]
  ask chair 26 [create-link-with node 75 set tableNo 3  set chairNo 6]
  ask chair 27 [create-link-with node 73 set tableNo 3 set chairNo 8]
  ask chair 28 [create-link-with node 76 set tableNo 4 set chairNo 1]
  ask chair 29 [create-link-with node 76 set tableNo 4 set chairNo 2]
  ask chair 30 [create-link-with node 77 set tableNo 5 set chairNo 1]
  ask chair 31 [create-link-with node 77 set tableNo 5 set chairNo 2]
  ask chair 32 [create-link-with node 79 set tableNo 6 set chairNo 1]
  ask chair 33 [create-link-with node 79 set tableNo 6 set chairNo 2]
  ask chair 34 [create-link-with node 78 set tableNo 7 set chairNo 1]
  ask chair 35 [create-link-with node 78 set tableNo 7 set chairNo 2]
  ask chair 36 [create-link-with node 80 set tableNo 8 set chairNo 1]
  ask chair 37 [create-link-with node 80 set tableNo 8 set chairNo 2]
  ask chair 38 [create-link-with node 82 set tableNo 9 set chairNo 1]
  ask chair 39 [create-link-with node 82 set tableNo 9 set chairNo 2]
  ask chair 40 [create-link-with node 81 set tableNo 10 set chairNo 1]
  ask chair 41 [create-link-with node 81 set tableNo 10 set chairNo 2]
  ask chair 42 [create-link-with node 84 set tableNo 12 set chairNo 1]
  ask chair 43 [create-link-with node 84 set tableNo 12 set chairNo 2]
  ask chair 44 [create-link-with node 83 set tableNo 11 set chairNo 1]
  ask chair 45 [create-link-with node 83 set tableNo 11 set chairNo 2]
  ask chair 46 [create-link-with node 85 set tableNo 13 set chairNo 1]
  ask chair 47 [create-link-with node 106 set tableNo 13 set chairNo 5]
  ask chair 48 [create-link-with node 105 set tableNo 13 set chairNo 3]
  ask chair 49 [create-link-with node 88 set tableNo 13 set chairNo 7]
  ask chair 50 [create-link-with node 106 set tableNo 13 set chairNo 6]
  ask chair 51 [create-link-with node 88 set tableNo 13 set chairNo 8]
  ask chair 52 [create-link-with node 106 set tableNo 13 set chairNo 4]
  ask chair 53 [create-link-with node 85 set tableNo 13 set chairNo 2]
  ask chair 54 [create-link-with node 97 set tableNo 14 set chairNo 1]
  ask chair 55 [create-link-with node 97 set tableNo 14 set chairNo 2]
  ask chair 56 [create-link-with node 97 set tableNo 14 set chairNo 3]
  ask chair 57 [create-link-with node 97 set tableNo 14 set chairNo 4]
  ask chair 58 [create-link-with node 97 set tableNo 14 set chairNo 5]
  ask chair 59 [create-link-with node 97 set tableNo 14 set chairNo 6]
  ask chair 60 [create-link-with node 92 set tableNo 15 set chairNo 1]
  ask chair 61 [create-link-with node 92 set tableNo 15 set chairNo 2]
  ask chair 62 [create-link-with node 92 set tableNo 15 set chairNo 3]
  ask chair 63 [create-link-with node 92 set tableNo 15 set chairNo 4]
  ask chair 64 [create-link-with node 92 set tableNo 15 set chairNo 5]
  ask chair 65 [create-link-with node 92 set tableNo 15 set chairNo 6]
  ask chair 66 [create-link-with node 94 set tableNo 16 set chairNo 1]
  ask chair 67 [create-link-with node 94 set tableNo 16 set chairNo 2]
  ask chair 68 [create-link-with node 94 set tableNo 16 set chairNo 3]
  ask chair 69 [create-link-with node 94 set tableNo 16 set chairNo 4]
  ask chair 70 [create-link-with node 94 set tableNo 16 set chairNo 5]
  ask chair 71 [create-link-with node 94 set tableNo 16 set chairNo 6]

end


to setup-chair-links-2

  ask chair 14 [create-link-with node 60 set tableNo 1 set chairNo 1]
  ask chair 15 [create-link-with node 60 set tableNo 1 set chairNo 2]
  ask chair 16 [create-link-with node 61 set tableNo 2 set chairNo 1]
  ask chair 17 [create-link-with node 61 set tableNo 2 set chairNo 2]
  ask chair 18 [create-link-with node 63 set tableNo 3 set chairNo 1]
  ask chair 19 [create-link-with node 63 set tableNo 3 set chairNo 2]
  ask chair 20 [create-link-with node 63 set tableNo 3 set chairNo 3]
  ask chair 21 [create-link-with node 63 set tableNo 3 set chairNo 4]
  ask chair 22 [create-link-with node 63 set tableNo 3 set chairNo 5]
  ask chair 23 [create-link-with node 63 set tableNo 3 set chairNo 6]
  ask chair 24 [create-link-with node 63 set tableNo 3 set chairNo 7]
  ask chair 25 [create-link-with node 63 set tableNo 3 set chairNo 8]
  ask chair 26 [create-link-with node 65 set tableNo 4 set chairNo 1]
  ask chair 27 [create-link-with node 65 set tableNo 4 set chairNo 2]
  ask chair 28 [create-link-with node 66 set tableNo 5 set chairNo 1]
  ask chair 29 [create-link-with node 67 set tableNo 6 set chairNo 2]
  ask chair 30 [create-link-with node 67 set tableNo 6 set chairNo 1]
  ask chair 31 [create-link-with node 66 set tableNo 5 set chairNo 2]
  ask chair 32 [create-link-with node 71 set tableNo 7 set chairNo 1]
  ask chair 33 [create-link-with node 71 set tableNo 7 set chairNo 2]
  ask chair 34 [create-link-with node 74 set tableNo 8 set chairNo 1]
  ask chair 35 [create-link-with node 75 set tableNo 9 set chairNo 2]
  ask chair 36 [create-link-with node 75 set tableNo 9 set chairNo 1]
  ask chair 37 [create-link-with node 74 set tableNo 8 set chairNo 2]
  ask chair 38 [create-link-with node 73 set tableNo 10 set chairNo 1]
  ask chair 39 [create-link-with node 73 set tableNo 10 set chairNo 2]
  ask chair 40 [create-link-with node 72 set tableNo 11 set chairNo 1]
  ask chair 41 [create-link-with node 72 set tableNo 11 set chairNo 2]
  ask chair 42 [create-link-with node 68 set tableNo 12 set chairNo 1]
  ask chair 43 [create-link-with node 68 set tableNo 12 set chairNo 2]
  ask chair 44 [create-link-with node 68 set tableNo 12 set chairNo 3]
  ask chair 45 [create-link-with node 68 set tableNo 12 set chairNo 4]
  ask chair 46 [create-link-with node 68 set tableNo 12 set chairNo 5]
  ask chair 47 [create-link-with node 68 set tableNo 12 set chairNo 6]
  ask chair 48 [create-link-with node 69 set tableNo 13 set chairNo 1]
  ask chair 49 [create-link-with node 69 set tableNo 13 set chairNo 2]
  ask chair 50 [create-link-with node 69 set tableNo 13 set chairNo 3]
  ask chair 51 [create-link-with node 69 set tableNo 13 set chairNo 4]
  ask chair 52 [create-link-with node 69 set tableNo 13 set chairNo 5]
  ask chair 53 [create-link-with node 69 set tableNo 13 set chairNo 6]
  ask chair 54 [create-link-with node 70 set tableNo 14 set chairNo 1]
  ask chair 55 [create-link-with node 70 set tableNo 14 set chairNo 2]
  ask chair 56 [create-link-with node 70 set tableNo 14 set chairNo 3]
  ask chair 57 [create-link-with node 70 set tableNo 14 set chairNo 4]
  ask chair 58 [create-link-with node 70 set tableNo 14 set chairNo 5]
  ask chair 59 [create-link-with node 70 set tableNo 14 set chairNo 6]

end


to setup-patches

  ca
  ask patches [ set pcolor white]

  ;;main walls patches
  ask patches [if pxcor = -12 AND pycor > -22 AND pycor < 15[set pcolor black]]
  ask patches [if pxcor = 12 AND pycor > -15 AND pycor < 15[set pcolor black]]
  ask patches [if pxcor > -13 AND pxcor < 13 AND pycor = 14 [set pcolor black]]
  ask patches [if pxcor > -13 AND pxcor < 13 AND pycor = -14 [set pcolor black]]

  ;;bathroom walls patches
  ask patches [if pxcor > -13 AND pxcor < 2 AND pycor = -21 [set pcolor black]]
  ask patches [if pxcor = 2 AND pycor > -22 AND pycor < -14[set pcolor black]]
  ask patches [if pxcor = -5 AND pycor > -22 AND pycor < -14[set pcolor black]]

  ;;doors patches
  ask patches [if pxcor > -9 AND pxcor < -6 AND pycor = -14 [set pcolor grey]]
  ask patches [if pxcor > -4 AND pxcor < -1 AND pycor = -14 [set pcolor grey]]
  ask patches [if pxcor > 7 AND pxcor < 12 AND pycor = -14 [set pcolor grey]]

  ;;bar
  ask patches [if pxcor = 12 AND pycor > 11 AND pycor < 14[set pcolor grey]]

  ;;kitchen
  ask patches [if pxcor > 12 AND pxcor < 20 AND pycor = 14 [set pcolor black]]
  ask patches [if pxcor > 12 AND pxcor < 20 AND pycor = 0 [set pcolor black]]
  ask patches [if pxcor = 19 AND pycor < 15 AND pycor > -1[set pcolor black]]
  ask patches [if pxcor > 14 AND pxcor < 17 AND pycor > 2 AND pycor < 12[set pcolor black]]

  ask patch -12 -8 [set pcolor blue]
  ask patch -12 -7 [set pcolor blue]
  ask patch -12 5 [set pcolor blue]
  ask patch -12 6 [set pcolor blue]
  ask patch 6 14 [set pcolor blue]
  ask patch 5 14 [set pcolor blue]
  ask patch -5 14 [set pcolor blue]
  ask patch -6 14 [set pcolor blue]

  ask patches [if pxcor < -12[set patchType "outside"]]
  ask patches [if pycor > 14[set patchType "outside"]]
  ask patches [if pxcor > 19[set patchType "outside"]]
  ask patches [if pxcor > 12 and pycor < 0[set patchType "outside"]]
  ask patches [if pxcor > 12 and pxcor < 19 and pycor < 14 and pycor > 0[set patchType "outside"]]
  ask patches [if pxcor > 2 and pycor < -14[set patchType "outside"]]
  ask patches [if pycor < -21[set patchType "outside"]]
  ask patches [if pxcor > -12 and pxcor < -5 and pycor < -14 and pycor > -21[set patchType "outside"]]
  ask patches [if pxcor > -5 and pxcor < 2 and pycor < -14 and pycor > -21[set patchType "outside"]]

  ask patches [if pcolor = black [set patchType "wall"]]
  ask patches [if pcolor = green [set patchType "bar"]]
  ask patches [if pcolor = grey [set patchType "door"]]
  ask patches [if pcolor = blue and pxcor = -12[set patchType "leftWindow"]]
  ask patches [if pcolor = blue and pycor = 14[set patchType "topWindow" ]]
  ask patches [if pxcor > 7 and pxcor < 12 and pycor < -14 and pycor > -21[set patchType 0]]

end


to top-airpaths

  set leftWindowOpen false
  set topWindowOpen true
  show "top"

  ask patches with [gridSquare = 1][set airDirection 135]
  ask patches with [gridSquare = 2][set airDirection 180] ask patch -8 13 [set airDirection 135]
  ask patches with [gridSquare = 3][set airDirection 180] ask patch -3 11 [set airDirection 135]
  ask patches with [gridSquare = 4][set airDirection 270] ask patch 0 11 [set airDirection 0] ask patch -3 13 [set airDirection 225] ask patch -3 12 [set airDirection 225]
  ask patches with [gridSquare = 5][set airDirection 90] ask patch 1 11 [set airDirection 0] ask patch 1 12 [set airDirection 45] ask patch 2 11 [set airDirection 45]ask patch 0 12 [set airDirection 315]
  ask patches with [gridSquare = 6][set airDirection 180] ask patch 4 11 [set airDirection 225 set pushPull true set pullDir 225] ask patch -1 11 [set airDirection 315] ask patch 4 13 [set airDirection 135] ask patch 4 12 [set airDirection 135]
  ask patches with [gridSquare = 7][set airDirection 180] ask patch 9 13 [set airDirection 225] ask patch 8 13 [set airDirection 225] ask patch 9 12 [set airDirection 225]
  ask patches with [gridSquare = 8][set airDirection 225]


  ask patches with [gridSquare = 9][set airDirection 180]
  ask patches with [gridSquare = 10][set airDirection 180]
  ask patches with [gridSquare = 11][set airDirection 180]
  ask patches with [gridSquare = 12][set airDirection 180] ask patch 0 10 [set airDirection 0] ask patch -1 10 [set airDirection 0] ask patch 0 9 [set airDirection 0]
                                                            ask patch -2 10 [set airDirection 90] ask patch -1 9 [set airDirection 90] ask patch -2 9 [set airDirection 135 set pushPull true set pullDir 135]
                                                            ask patch -1 12 [set airDirection 90 set pushPull true set pullDir 315]
  ask patches with [gridSquare = 13][set airDirection 180] ask patch 1 10 [set airDirection 0] ask patch 2 10 [set airDirection 0] ask patch 1 9 [set airDirection 0]
                                                            ask patch 3 10 [set airDirection 270] ask patch 2 9 [set airDirection 270] ask patch 3 9 [set airDirection 225 set pushPull true set pullDir 225]
                                                            ask patch 2 12 [set airDirection 90 set pushPull true set pullDir 45]ask patch 3 11 [set airDirection 90 set pushPull true set pullDir 270]
                                                            ask patch 4 10 [set airDirection 0 set pushPull true set pullDir 225]
  ask patches with [gridSquare = 14][set airDirection 180]
  ask patches with [gridSquare = 15][set airDirection 180]
  ask patches with [gridSquare = 16][set airDirection 180]


  ask patches with [gridSquare = 17][set airDirection 135]
  ask patches with [gridSquare = 18][set airDirection 180]
  ask patches with [gridSquare = 19][set airDirection 180]
  ask patches with [gridSquare = 20][set airDirection 180]
  ask patches with [gridSquare = 21][set airDirection 180]
  ask patches with [gridSquare = 22][set airDirection 180]
  ask patches with [gridSquare = 23][set airDirection 180]
  ask patches with [gridSquare = 24][set airDirection 225]



  ask patches with [gridSquare = 25][set airDirection 180]
  ask patches with [gridSquare = 26][set airDirection 180]
  ask patches with [gridSquare = 27][set airDirection 180]
  ask patches with [gridSquare = 28][set airDirection 180]
  ask patches with [gridSquare = 29][set airDirection 180]
  ask patches with [gridSquare = 30][set airDirection 180]
  ask patches with [gridSquare = 31][set airDirection 180]
  ask patches with [gridSquare = 32][set airDirection 180]



  ask patches with [gridSquare = 33][set airDirection 135]
  ask patches with [gridSquare = 34][set airDirection 180]
  ask patches with [gridSquare = 35][set airDirection 180]
  ask patches with [gridSquare = 36][set airDirection 180]
  ask patches with [gridSquare = 37][set airDirection 180]
  ask patches with [gridSquare = 38][set airDirection 180]
  ask patches with [gridSquare = 39][set airDirection 180]
  ask patches with [gridSquare = 40][set airDirection 225]



  ask patches with [gridSquare = 41][set airDirection 180]
  ask patches with [gridSquare = 42][set airDirection 180]
  ask patches with [gridSquare = 43][set airDirection 180]
  ask patches with [gridSquare = 44][set airDirection 180]
  ask patches with [gridSquare = 45][set airDirection 180]
  ask patches with [gridSquare = 46][set airDirection 180]
  ask patches with [gridSquare = 47][set airDirection 180]
  ask patches with [gridSquare = 48][set airDirection 180]



  ask patches with [gridSquare = 49][set airDirection 135]
  ask patches with [gridSquare = 50][set airDirection 180]
  ask patches with [gridSquare = 51][set airDirection 180]
  ask patches with [gridSquare = 52][set airDirection 180]
  ask patches with [gridSquare = 53][set airDirection 180]
  ask patches with [gridSquare = 54][set airDirection 180]
  ask patches with [gridSquare = 55][set airDirection 180]
  ask patches with [gridSquare = 56][set airDirection 225]



  ask patches with [gridSquare = 57][set airDirection 180]
  ask patches with [gridSquare = 58][set airDirection 180]
  ask patches with [gridSquare = 59][set airDirection 180]
  ask patches with [gridSquare = 60][set airDirection 180]
  ask patches with [gridSquare = 61][set airDirection 180]
  ask patches with [gridSquare = 62][set airDirection 180]
  ask patches with [gridSquare = 63][set airDirection 180]
  ask patches with [gridSquare = 64][set airDirection 180]



  ask patches with [gridSquare = 65][set airDirection 135]
  ask patches with [gridSquare = 66][set airDirection 180]
  ask patches with [gridSquare = 67][set airDirection 180]
  ask patches with [gridSquare = 68][set airDirection 180]
  ask patches with [gridSquare = 69][set airDirection 180]
  ask patches with [gridSquare = 70][set airDirection 180]
  ask patches with [gridSquare = 71][set airDirection 180]
  ask patches with [gridSquare = 72][set airDirection 225]


  ask patch 5 14[ set airDirection 0 set pushPull true set pullDir 45]
  ask patches with [gridSquare != 0][set airTransfer 0.0093]

  ask patches with [pycor = -13][set concentration concentration * 0.5]
  ask patches with [pycor = -12][set concentration concentration * 0.7]
  ask patches with [pycor = -11][set concentration concentration * 0.9]

end


to left-airpaths

  set leftWindowOpen true
  set topWindowOpen false
  show "left"

  ask patches with [gridSquare = 1][set airDirection 135]
  ask patches with [gridSquare = 2][set airDirection 90]
  ask patches with [gridSquare = 3][set airDirection 90]
  ask patches with [gridSquare = 4][set airDirection 90]
  ask patches with [gridSquare = 5][set airDirection 90]
  ask patches with [gridSquare = 6][set airDirection 90]
  ask patches with [gridSquare = 7][set airDirection 90]
  ask patches with [gridSquare = 8][set airDirection 90]


  ask patches with [gridSquare = 9][set airDirection 135]
  ask patches with [gridSquare = 10][set airDirection 90]
  ask patches with [gridSquare = 11][set airDirection 90]
  ask patches with [gridSquare = 12][set airDirection 90]
  ask patches with [gridSquare = 13][set airDirection 90]
  ask patches with [gridSquare = 14][set airDirection 90]
  ask patches with [gridSquare = 15][set airDirection 90]
  ask patches with [gridSquare = 16][set airDirection 90]


  ask patches with [gridSquare = 17][set airDirection 90]
  ask patches with [gridSquare = 18][set airDirection 90]
  ask patches with [gridSquare = 19][set airDirection 90]
  ask patches with [gridSquare = 20][set airDirection 90]
  ask patches with [gridSquare = 21][set airDirection 90]
  ask patches with [gridSquare = 22][set airDirection 90]
  ask patches with [gridSquare = 23][set airDirection 90]
  ask patches with [gridSquare = 24][set airDirection 90]


  ask patches with [gridSquare = 25][set airDirection 45]
  ask patches with [gridSquare = 26][set airDirection 45] ask patch -6 3[ set airDirection 45 set pushPull true set pullDir 45] ask patch -6 2[ set airDirection 0 set pushPull true set pullDir 0]
  ask patches with [gridSquare = 27][set airDirection 45] ask patches with [pycor = 2 and pxcor < -2 and pxcor > -12] [ set airDirection 0] ask patch -4 2[ set airDirection 0 set pushPull true set pullDir 0]
  ask patches with [gridSquare = 28][set airDirection 45] ask patch -2 3[ set airDirection 45 set pushPull true set pullDir 45]
  ask patches with [gridSquare = 29][set airDirection 45] ask patch 1 2[ set airDirection 45 set pushPull true set pullDir 90]
  ask patches with [gridSquare = 30][set airDirection 90] ask patch 5 2 [ set airDirection 45] ask patch 4 2 [ set airDirection 45] ask patch 4 3 [ set airDirection 45]
  ask patches with [gridSquare = 31][set airDirection 90]
  ask patches with [gridSquare = 32][set airDirection 90]


  ask patches with [gridSquare = 33][set airDirection 225]ask patch -11 1 [ set airDirection 0] ask patch -9 1 [ set airDirection 225]  ask patch -11 0 [ set airDirection 0]
  ask patches with [gridSquare = 34][set airDirection 315]
  ask patches with [gridSquare = 35][set airDirection 315]ask patch -11 1 [ set airDirection 0] ask patch -3 0 [ set airDirection 0 set pushPull true set pullDir 0] ask patch -3 -1[ set airDirection 0 set pushPull true set pullDir 45]
                                                          ask patch -4 0[ set airDirection 45 set pushPull true set pullDir 90] ask patch -4 1[ set airDirection 0 set pushPull true set pullDir 0]
                                                          ask patch -5 1[ set airDirection 0 set pushPull true set pullDir 0]
  ask patches with [gridSquare = 36][set airDirection 0]  ask patch 0 -1 [ set airDirection 45 set pushPull true set pullDir 90] ask patch 0 0 [ set airDirection 45] ask patch -1 0 [ set airDirection 45 set pushPull true set pullDir 0]
                                                          ask patch -1 -1 [ set airDirection 45 set pushPull true set pullDir 45]
                                                          ask patch -2 0 [ set airDirection 45] ask patch -2 1 [ set airDirection 45] ask patch -1 1 [ set airDirection 45]
  ask patches with [gridSquare = 37][set airDirection 45] ask patch 1 -1[ set airDirection 45] ask patch 2 -1[ set airDirection 45] ask patch 1 0[ set airDirection 45]
                                                          ask patch 1 1[ set airDirection 45 set pushPull true set pullDir 0]
  ask patches with [gridSquare = 38][set airDirection 45]
  ask patches with [gridSquare = 39][set airDirection 90]
  ask patches with [gridSquare = 40][set airDirection 90]


  ask patches with [gridSquare = 41][set airDirection 135]ask patches with [pxcor = -11 and pycor < 0 and pycor > -5] [ set airDirection 180] ask patch -10 -2 [ set airDirection 180]
                                                          ask patch -9 -2 [ set airDirection 225]  ask patch -10 -3 [ set airDirection 180]  ask patch -9 -4 [ set airDirection 225]
                                                          ask patch -3 1 [ set airDirection 45] ask patch -4 1 [ set airDirection 45] ask patch -3 0 [ set airDirection 45]
  ask patches with [gridSquare = 42][set airDirection 315]ask patch -6 -4 [ set airDirection 90] ask patch -7 -4 [ set airDirection 90] ask patch -8 -4 [ set airDirection 90]
  ask patches with [gridSquare = 43][set airDirection 315]ask patch -5 -4 [ set airDirection 90] ask patch -4 -4 [ set airDirection 90] ask patches with [pycor = -3 and pxcor < -3 and pxcor > -9] [ set airDirection 0]
                                                          ask patch -8 -3 [ set airDirection 225] ask patch -3 -3 [ set airDirection 315 set pushPull true set pullDir 0] ask patch -5 -3[ set airDirection 0 set pushPull true set pullDir 45]
                                                          ask patch -3 -4[ set airDirection 0 set pushPull true set pullDir 45] ask patch -4 -3[ set airDirection 45 set pushPull true set pullDir 45]
  ask patches with [gridSquare = 44][set airDirection 315]ask patch 0 -2 [ set airDirection 45 set pushPull true set pullDir 45] ask patch 0 -4 [ set airDirection 45] ask patch 0 -3 [ set airDirection 45 set pushPull true set pullDir 0]
                                                          ask patch -1 -4 [ set airDirection 0] ask patch -2 -4 [ set airDirection 0]
                                                          ask patch -1 -2[ set airDirection 315 set pushPull true set pullDir 0] ask patch -2 -2[ set airDirection 45 set pushPull true set pullDir 0]
  ask patches with [gridSquare = 45][set airDirection 45]
  ask patches with [gridSquare = 46][set airDirection 45] ask patch 4 -4 [ set airDirection 45] ask patch 4 -3 [ set airDirection 45] ask patch 5 -4 [ set airDirection 45]
  ask patches with [gridSquare = 47][set airDirection 45]
  ask patches with [gridSquare = 48][set airDirection 90] ask patch 10 -4 [ set airDirection 45] ask patch 10 -3 [ set airDirection 45]



  ask patches with [gridSquare = 49][set airDirection 90] ask patch -11 -5 [ set airDirection 135] ask patch -11 -6 [ set airDirection 135 set pushPull true set pullDir 180]
                                                          ask patch -10 -5[ set airDirection 135 set pushPull true set pullDir 135] ask patch -7 -8[ set airDirection 0 set pushPull true set pullDir 315]
  ask patches with [gridSquare = 50][set airDirection 90] ask patch -8 -7[ set airDirection 90 set pushPull true set pullDir 315]
                                                          ask patch -8 -5[ set airDirection 90 set pushPull true set pullDir 90]
  ask patches with [gridSquare = 51][set airDirection 90]
  ask patches with [gridSquare = 52][set airDirection 90] ask patch -2 -5 [ set airDirection 45] ask patch -1 -5 [ set airDirection 45] ask patch 0 -5 [ set airDirection 45]
                                                          ask patch -1 -6 [ set airDirection 45 set pushPull true set pullDir 45]ask patch 0 -6 [ set airDirection 45] ask patch 0 -7 [ set airDirection 45 set pushPull true set pullDir 45]
                                                          ask patch -1 -7 [ set airDirection 45] ask patch -2 -6 [ set airDirection 45] ask patch -3 -5 [ set airDirection 45]
                                                          ask patch -2 -5[ set airDirection 45 set pushPull true set pullDir 0]

  ask patches with [gridSquare = 53][set airDirection 45]
  ask patches with [gridSquare = 54][set airDirection 45] ask patch 4 -7 [ set airDirection 45] ask patch 4 -6 [ set airDirection 45] ask patch 5 -7 [ set airDirection 45]
  ask patches with [gridSquare = 55][set airDirection 45]
  ask patches with [gridSquare = 56][set airDirection 0]  ask patch 10 -7 [ set airDirection 45] ask patch 10 -6 [ set airDirection 45]



  ask patches with [gridSquare = 57][set airDirection 90] ask patch -9 -8[ set airDirection 90 set pushPull true set pullDir 135]
  ask patches with [gridSquare = 58][set airDirection 90]
  ask patches with [gridSquare = 59][set airDirection 90]
  ask patches with [gridSquare = 60][set airDirection 90]
  ask patches with [gridSquare = 61][set airDirection 45] ask patch 0 -8 [ set airDirection 45] ask patch 1 -8 [ set airDirection 45 set pushPull true set pullDir 45] ask patch 2 -10[ set airDirection 45 set pushPull true set pullDir 90]
  ask patches with [gridSquare = 62][set airDirection 45] ask patch 4 -10 [ set airDirection 45] ask patch 4 -9 [ set airDirection 45] ask patch 5 -10 [ set airDirection 45]
  ask patches with [gridSquare = 63][set airDirection 45]
  ask patches with [gridSquare = 64][set airDirection 0]  ask patch 10 -10 [ set airDirection 45] ask patch 10 -9 [ set airDirection 45]



  ask patches with [gridSquare = 65][set airDirection 45]
  ask patches with [gridSquare = 66][set airDirection 90]
  ask patches with [gridSquare = 67][set airDirection 90]
  ask patches with [gridSquare = 68][set airDirection 90]
  ask patches with [gridSquare = 69][set airDirection 45] ask patch 1 -13 [ set airDirection 90] ask patch 2 -13 [ set airDirection 90] ask patch 1 -12 [ set airDirection 90]
                                                          ask patch 1 -13 [ set airDirection 90]  ask patch 3 -12 [ set airDirection 45 set pushPull true set pullDir 90] ask patch 2 -11 [ set airDirection 45 set pushPull true set pullDir 90]
  ask patches with [gridSquare = 70][set airDirection 45] ask patch 4 -13 [ set airDirection 45 set pushPull true set pullDir 90] ask patch 4 -12 [ set airDirection 45] ask patch 5 -13 [ set airDirection 45]
  ask patches with [gridSquare = 71][set airDirection 45]
  ask patches with [gridSquare = 72][set airDirection 0]  ask patch 10 -13 [ set airDirection 45] ask patch 10 -12 [ set airDirection 45]


  ask patch 5 14[ set airDirection 0 set pushPull true set pullDir 45]

  ask patches with [gridSquare != 0][set airTransfer 0.01]

  ask patches with [pxcor = 11][set concentration concentration * 0.5]
  ask patches with [pxcor = 10][set concentration concentration * 0.7]
  ask patches with [pxcor = 9][set concentration concentration * 0.9]
  ask patches with [pxcor = 11][set concentration concentration * 0.5]
  ask patches with [pxcor = 10][set concentration concentration * 0.7]
  ask patches with [pxcor = 9][set concentration concentration * 0.9]

end


to left-top-airpaths

  set leftWindowOpen true
  set topWindowOpen true

  show "both"
  ask patches with [gridSquare = 1][set airDirection 45]  ask patch -11 13 [ set airDirection 90]ask patch -10 13 [ set airDirection 90]ask patch -9 13 [ set airDirection 90]
                                                          ask patch -11 12 [ set airDirection 90] ask patch -10 12 [ set airDirection 90] ask patch -11 11 [ set airDirection 90]
  ask patches with [gridSquare = 2][set airDirection 45]  ask patch -8 13 [ set airDirection 90]
  ask patches with [gridSquare = 3][set airDirection 315]
  ask patches with [gridSquare = 4][set airDirection 315] ask patch 0 13 [ set airDirection 270] ask patch -1 13 [ set airDirection 270] ask patch -2 13 [ set airDirection 270]  ask patch -3 13 [ set airDirection 270]
  ask patches with [gridSquare = 5][set airDirection 45]  ask patch 3 13 [ set airDirection 90] ask patch 1 13 [ set airDirection 90] ask patch 2 13 [ set airDirection 90]
                                                                              ask patch 2 11[ set airDirection 45 set pushPull true set pullDir 45]
  ask patches with [gridSquare = 6][set airDirection 0]   ask patch 4 12 [ set airDirection 45] ask patch 4 13 [ set airDirection 45]
  ask patches with [gridSquare = 7][set airDirection 270] ask patch 7 13 [ set airDirection 315 set pushPull true set pullDir 0]ask patch 7 12 [ set airDirection 315]ask patch 7 11 [ set airDirection 315] ask patch 8 11 [ set airDirection 315]
                                                          ask patch 8 12 [ set airDirection 315] ask patch 9 11 [ set airDirection 315] ask patch 7 12[ set airDirection 315 set pushPull true set pullDir 90]
                                                          ask patch 8 13[ set airDirection 270 set pushPull true set pullDir 0] ask patch 9 13[ set airDirection 270 set pushPull true set pullDir 0]
  ask patches with [gridSquare = 8][set airDirection 270] ask patch 11 11 [ set airDirection 0]


  ask patches with [gridSquare = 9][set airDirection 45]  ask patch -9 8[ set airDirection 45 set pushPull true set pullDir 45]
  ask patches with [gridSquare = 10][set airDirection 0]  ask patch -8 8[ set airDirection 0 set pushPull true set pullDir 45] ask patch -7 10[ set airDirection 45 set pushPull true set pullDir 45]
                                                                             ask patch 3 10[ set airDirection 0 set pushPull true set pullDir 45] ask patch -7 8[ set airDirection 0 set pushPull true set pullDir 0]
  ask patches with [gridSquare = 11][set airDirection 0]  ask patch -4 8[ set airDirection 0 set pushPull true set pullDir 0]
  ask patches with [gridSquare = 12][set airDirection 0]  ask patch 0 8 [ set airDirection 45] ask patch 0 9 [ set airDirection 45] ask patch 0 10 [ set airDirection 45]
                                                                            ask patch -1 8 [ set airDirection 45] ask patch -1 7 [ set airDirection 45] ask patch -2 8 [ set airDirection 45]
                                                                            ask patch -2 9[ set airDirection 0 set pushPull true set pullDir 0]
  ask patches with [gridSquare = 13][set airDirection 0]  ask patch 3 10[ set airDirection 45] ask patch 3 9[ set airDirection 45] ask patch 2 10[ set airDirection 45]
  ask patches with [gridSquare = 14][set airDirection 0]  ask patch 6 10[ set airDirection 0 set pushPull true set pullDir 315] ask patch 5 8[ set airDirection 45 set pushPull true set pullDir 45]
                                                                              ask patch 5 9[ set airDirection 0 set pushPull true set pullDir 0]  ask patch 6 10[ set airDirection 0 set pushPull true set pullDir 315]
                                                                             ask patch 2 9[ set airDirection 45 set pushPull true set pullDir 45] ask patch 2 10[ set airDirection 45 set pushPull true set pullDir 45]
  ask patches with [gridSquare = 15][set airDirection 315]ask patch 9 8 [ set airDirection 0] ask patch 8 9 [ set airDirection 315 set pushPull true set pullDir 0] ask patch 7 9[ set airDirection 0 set pushPull true set pullDir 0]
                                                          ask patch 9 10[ set airDirection 315 set pushPull true set pullDir 0] ask patch 10 11[ set airDirection 315 set pushPull true set pullDir 0]
  ask patches with [gridSquare = 16][set airDirection 315]ask patch 11 8 [ set airDirection 0] ask patch 10 8 [ set airDirection 0] ask patch 11 9 [ set airDirection 0] ask patch 11 10 [ set airDirection 0]
                                                          ask patch 10 9 [ set airDirection 0]



  ask patches with [gridSquare = 17][set airDirection 90] ask patch 3 10[ set airDirection 90 set pushPull true set pullDir 45]
  ask patches with [gridSquare = 18][set airDirection 45] ask patch -8 5 [ set airDirection 90] ask patch -7 5 [ set airDirection 90] ask patch -6 5 [ set airDirection 90]
                                                                            ask patch -8 6 [ set airDirection 90] ask patch -7 6 [ set airDirection 90 set pushPull true set pullDir 45] ask patch -8 7 [ set airDirection 45]
                                                                            ask patch -6 6[ set airDirection 90 set pushPull true set pullDir 45] ask patch -7 7[ set airDirection 45 set pushPull true set pullDir 45]
  ask patches with [gridSquare = 19][set airDirection 45] ask patch -5 6[ set airDirection 45 set pushPull true set pullDir 90] ask patch -6 7[ set airDirection 45 set pushPull true set pullDir 45]
                                                                              ask patch -5 7[ set airDirection 45 set pushPull true set pullDir 45]
  ask patches with [gridSquare = 20][set airDirection 45]
  ask patches with [gridSquare = 21][set airDirection 45]
  ask patches with [gridSquare = 22][set airDirection 0]  ask patch 4 6 [ set airDirection 45] ask patch 5 5 [ set airDirection 0 set pushPull true set pullDir 45] ask patch 4 5 [ set airDirection 45]
                                                          ask patch 6 5[ set airDirection 0 set pushPull true set pullDir 45] ask patch 6 7[ set airDirection 0 set pushPull true set pullDir 45]
                                                          ask patch 4 7[ set airDirection 0 set pushPull true set pullDir 315]
  ask patches with [gridSquare = 23][set airDirection 0]  ask patch 7 7 [ set airDirection 0 set pushPull true set pullDir 0] ask patch 8 7 [ set airDirection 315] ask patch 8 7 [ set airDirection 0]
                                                          ask patch 7 6[ set airDirection 0 set pushPull true set pullDir 45]
  ask patches with [gridSquare = 24][set airDirection 0]



  ask patches with [gridSquare = 25][set airDirection 45] ask patch -10 2[ set airDirection 0 set pushPull true set pullDir 315] ask patch -9 2[ set airDirection 45 set pushPull true set pullDir 0]
  ask patches with [gridSquare = 26][set airDirection 45] ask patch -6 3[ set airDirection 45 set pushPull true set pullDir 90] ask patch -6 2[ set airDirection 0 set pushPull true set pullDir 0]
                                                                               ask patch -7 2[ set airDirection 0 set pushPull true set pullDir 0] ask patch -8 2[ set airDirection 45 set pushPull true set pullDir 0]
                                                                               ask patch -7 3[ set airDirection 45 set pushPull true set pullDir 45]
  ask patches with [gridSquare = 27][set airDirection 45] ask patches with [pycor = 2 and pxcor < -2 and pxcor > -12] [ set airDirection 0] ask patch -4 2[ set airDirection 0 set pushPull true set pullDir 0]
                                                                               ask patch -4 4[ set airDirection 45 set pushPull true set pullDir 315]
  ask patches with [gridSquare = 28][set airDirection 45] ask patch -2 3[ set airDirection 45 set pushPull true set pullDir 45]
  ask patches with [gridSquare = 29][set airDirection 45] ask patch 1 2[ set airDirection 45 set pushPull true set pullDir 90]
  ask patches with [gridSquare = 30][set airDirection 0]  ask patch 5 2 [ set airDirection 45] ask patch 4 2 [ set airDirection 45] ask patch 4 3 [ set airDirection 45] ask patch 5 4 [ set airDirection 0 set pushPull true set pullDir 315]
                                                          ask patch 5 3 [ set airDirection 0 set pushPull true set pullDir 0]
                                                          ask patch 6 4[ set airDirection 0 set pushPull true set pullDir 45]
  ask patches with [gridSquare = 31][set airDirection 0]  ask patch 7 2[ set airDirection 0 set pushPull true set pullDir 45]
  ask patches with [gridSquare = 32][set airDirection 0]  ask patch 10 -13 [ set airDirection 45] ask patch 10 -12 [ set airDirection 45]



  ask patches with [gridSquare = 33][set airDirection 225]ask patch -11 1 [ set airDirection 0] ask patch -9 1 [ set airDirection 0 set pushPull true set pullDir 0]  ask patch -11 0 [ set airDirection 0]
  ask patches with [gridSquare = 34][set airDirection 315]ask patch -10 2[ set airDirection 0 set pushPull true set pullDir 0] ask patch -8 1[ set airDirection 0 set pushPull true set pullDir 0]
  ask patches with [gridSquare = 35][set airDirection 315]ask patch -11 1 [ set airDirection 0] ask patch -3 0 [ set airDirection 0 set pushPull true set pullDir 0] ask patch -3 -1[ set airDirection 0 set pushPull true set pullDir 45]
                                                          ask patch -4 0[ set airDirection 45 set pushPull true set pullDir 0] ask patch -4 1[ set airDirection 0 set pushPull true set pullDir 0]
                                                          ask patch -5 1[ set airDirection 0 set pushPull true set pullDir 0]
  ask patches with [gridSquare = 36][set airDirection 0]  ask patch 0 -1 [ set airDirection 45 set pushPull true set pullDir 90] ask patch 0 0 [ set airDirection 45] ask patch -1 0 [ set airDirection 45 set pushPull true set pullDir 0]
                                                          ask patch -1 -1 [ set airDirection 45 set pushPull true set pullDir 45]
                                                          ask patch -2 0 [ set airDirection 45] ask patch -2 1 [ set airDirection 45] ask patch -1 1 [ set airDirection 45]
  ask patches with [gridSquare = 37][set airDirection 45] ask patch 1 -1[ set airDirection 45] ask patch 2 -1[ set airDirection 45] ask patch 1 0[ set airDirection 45]
                                                          ask patch 1 1[ set airDirection 45 set pushPull true set pullDir 0]
  ask patches with [gridSquare = 38][set airDirection 45] ask patch 6 1 [ set airDirection 0] ask patch 5 1 [ set airDirection 0 set pushPull true set pullDir 0] ask patch 6 0 [ set airDirection 0] ask patch 4 1 [ set airDirection 45]
                                                          ask patch 4 1[ set airDirection 0 set pushPull true set pullDir 0]
  ask patches with [gridSquare = 39][set airDirection 0]  ask patch 8 0 [ set airDirection 0 set pushPull true set pullDir 45] ask patch 9 1[ set airDirection 0 set pushPull true set pullDir 45]
                                                          ask patch 8 1[ set airDirection 0 set pushPull true set pullDir 45]
  ask patches with [gridSquare = 40][set airDirection 0]


  ask patches with [gridSquare = 41][set airDirection 135]ask patches with [pxcor = -11 and pycor < 0 and pycor > -5] [ set airDirection 180] ask patch -10 -2 [ set airDirection 180]
                                                          ask patch -9 -2 [ set airDirection 225]  ask patch -10 -3 [ set airDirection 180]  ask patch -9 -4 [ set airDirection 225]
                                                          ask patch -3 1 [ set airDirection 45] ask patch -4 1 [ set airDirection 45] ask patch -3 0 [ set airDirection 45]
  ask patches with [gridSquare = 42][set airDirection 315]ask patch -6 -4 [ set airDirection 90] ask patch -7 -4 [ set airDirection 90] ask patch -8 -4 [ set airDirection 90]
  ask patches with [gridSquare = 43][set airDirection 315]ask patch -5 -4 [ set airDirection 90] ask patch -4 -4 [ set airDirection 90] ask patches with [pycor = -3 and pxcor < -3 and pxcor > -9] [ set airDirection 0]
                                                          ask patch -8 -3 [ set airDirection 225] ask patch -3 -3 [ set airDirection 315 set pushPull true set pullDir 0] ask patch -5 -3[ set airDirection 0 set pushPull true set pullDir 45]
                                                          ask patch -3 -4[ set airDirection 0 set pushPull true set pullDir 45] ask patch -4 -3[ set airDirection 45 set pushPull true set pullDir 45]
  ask patches with [gridSquare = 44][set airDirection 315]ask patch 0 -2 [ set airDirection 45 set pushPull true set pullDir 45] ask patch 0 -4 [ set airDirection 45] ask patch 0 -3 [ set airDirection 45 set pushPull true set pullDir 0]
                                                          ask patch -1 -4 [ set airDirection 0] ask patch -2 -4 [ set airDirection 0]
                                                          ask patch -1 -2[ set airDirection 315 set pushPull true set pullDir 0] ask patch -2 -2[ set airDirection 45 set pushPull true set pullDir 0]
  ask patches with [gridSquare = 45][set airDirection 45] ask patch -7 11[ set airDirection 0 set pushPull true set pullDir 0]
  ask patches with [gridSquare = 46][set airDirection 45] ask patch 4 -4 [ set airDirection 45] ask patch 4 -3 [ set airDirection 45] ask patch 5 -4 [ set airDirection 45]
  ask patches with [gridSquare = 47][set airDirection 45] ask patch 9 -2[ set airDirection 0 set pushPull true set pullDir 0] ask patch 8 -1[ set airDirection 0 set pushPull true set pullDir 0]
                                                          ask patch 8 0[ set airDirection 0 set pushPull true set pullDir 0]
                                                          ask patch 10 -1[ set airDirection 0 set pushPull true set pullDir 45]
  ask patches with [gridSquare = 48][set airDirection 0]  ask patch 10 -4 [ set airDirection 45] ask patch 10 -3 [ set airDirection 0]


  ask patches with [gridSquare = 49][set airDirection 90] ask patch -11 -5 [ set airDirection 135] ask patch -11 -6 [ set airDirection 135 set pushPull true set pullDir 180]
                                                          ask patch -10 -5[ set airDirection 135 set pushPull true set pullDir 135] ask patch -7 -8[ set airDirection 0 set pushPull true set pullDir 315]
  ask patches with [gridSquare = 50][set airDirection 90] ask patch -8 -7[ set airDirection 90 set pushPull true set pullDir 135]
                                                          ask patch -8 -5[ set airDirection 90 set pushPull true set pullDir 90]
  ask patches with [gridSquare = 51][set airDirection 90]
  ask patches with [gridSquare = 52][set airDirection 90] ask patch -2 -5 [ set airDirection 45] ask patch -1 -5 [ set airDirection 45] ask patch 0 -5 [ set airDirection 45]
                                                          ask patch -1 -6 [ set airDirection 45 set pushPull true set pullDir 45]ask patch 0 -6 [ set airDirection 45] ask patch 0 -7 [ set airDirection 45 set pushPull true set pullDir 45]
                                                          ask patch -1 -7 [ set airDirection 45] ask patch -2 -6 [ set airDirection 45] ask patch -3 -5 [ set airDirection 45]
                                                          ask patch -2 -5[ set airDirection 45 set pushPull true set pullDir 0]

  ask patches with [gridSquare = 53][set airDirection 45]
  ask patches with [gridSquare = 54][set airDirection 45] ask patch 4 -7 [ set airDirection 45] ask patch 4 -6 [ set airDirection 45] ask patch 5 -7 [ set airDirection 45]
  ask patches with [gridSquare = 55][set airDirection 45]
  ask patches with [gridSquare = 56][set airDirection 0]  ask patch 10 -7 [ set airDirection 45] ask patch 10 -6 [ set airDirection 45]


  ask patches with [gridSquare = 57][set airDirection 90] ask patch -9 -8[ set airDirection 90 set pushPull true set pullDir 135]
  ask patches with [gridSquare = 58][set airDirection 90]
  ask patches with [gridSquare = 59][set airDirection 90]
  ask patches with [gridSquare = 60][set airDirection 90] ask patch 0 -9[ set airDirection 45 set pushPull true set pullDir 90] ask patch -1 -8[ set airDirection 45 set pushPull true set pullDir 90]
                                                                                ask patch -1 -9[ set airDirection 45 set pushPull true set pullDir 900]
  ask patches with [gridSquare = 61][set airDirection 45] ask patch 0 -8 [ set airDirection 45] ask patch 1 -8 [ set airDirection 45 set pushPull true set pullDir 45]
                                                                                 ask patch 2 -10[ set airDirection 45 set pushPull true set pullDir 90] ask patch 1 -10[ set airDirection 45 set pushPull true set pullDir 45]
                                                                                 ask patch 1 -9[ set airDirection 45 set pushPull true set pullDir 45]
  ask patches with [gridSquare = 62][set airDirection 45] ask patch 4 -10 [ set airDirection 45] ask patch 4 -9 [ set airDirection 45] ask patch 5 -10 [ set airDirection 45]
  ask patches with [gridSquare = 63][set airDirection 45]
  ask patches with [gridSquare = 64][set airDirection 0]  ask patch 10 -10 [ set airDirection 45] ask patch 10 -9 [ set airDirection 45]


  ask patches with [gridSquare = 65][set airDirection 45]
  ask patches with [gridSquare = 66][set airDirection 90]
  ask patches with [gridSquare = 67][set airDirection 90]
  ask patches with [gridSquare = 68][set airDirection 90]
  ask patches with [gridSquare = 69][set airDirection 45] ask patch 1 -13 [ set airDirection 90] ask patch 2 -13 [ set airDirection 90] ask patch 1 -12 [ set airDirection 90]
                                                          ask patch 1 -13 [ set airDirection 90]  ask patch 3 -12 [ set airDirection 45 set pushPull true set pullDir 90] ask patch 2 -11 [ set airDirection 45 set pushPull true set pullDir 90]
  ask patches with [gridSquare = 70][set airDirection 45] ask patch 4 -13 [ set airDirection 45 set pushPull true set pullDir 90] ask patch 4 -12 [ set airDirection 45] ask patch 5 -13 [ set airDirection 45]
  ask patches with [gridSquare = 71][set airDirection 45]
  ask patches with [gridSquare = 72][set airDirection 0]  ask patch 10 -13 [ set airDirection 45] ask patch 10 -12 [ set airDirection 45]


  ask patch 5 14[ set airDirection 0 set pushPull true set pullDir 45]
  ask patches with [gridSquare != 0][set airTransfer 0.031]

  ask patches with [pxcor = 11][set concentration concentration * 0.5]
  ask patches with [pxcor = 10][set concentration concentration * 0.7]
  ask patches with [pxcor = 9][set concentration concentration * 0.9]

end
@#$#@#$#@
GRAPHICS-WINDOW
19
68
640
590
-1
-1
12.522
1
10
1
1
1
0
0
0
1
-18
30
-23
17
0
0
1
ticks
30.0

BUTTON
22
12
88
45
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
103
13
215
46
Run Simulation
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
652
98
837
131
noOfWaiters
noOfWaiters
1
4
3.0
1
1
waiters
HORIZONTAL

SLIDER
654
192
839
225
capacity
capacity
30
count chairs + count waiters + count bartenders
30.0
10
1
people
HORIZONTAL

SLIDER
653
236
840
269
diningTime
diningTime
30
90
60.0
15
1
mins
HORIZONTAL

SLIDER
883
440
1085
473
mask-effectiveness-inhalation
mask-effectiveness-inhalation
1
100
39.0
1
1
%
HORIZONTAL

SWITCH
653
422
818
455
toggle-links
toggle-links
0
1
-1000

SWITCH
1125
92
1350
125
left-windows-open
left-windows-open
1
1
-1000

SWITCH
886
400
1084
433
masks
masks
1
1
-1000

SLIDER
878
779
1088
812
handwashing-thoroughness
handwashing-thoroughness
1
100
0.0
1
1
%
HORIZONTAL

MONITOR
369
1017
563
1070
CurrentSeating Area Occupancy
count waiters + count customers + count bartenders
17
1
13

MONITOR
570
1017
647
1070
Floor Staff
count waiters + count bartenders
17
1
13

SLIDER
885
68
1090
101
chance-of-being-infected
chance-of-being-infected
0
100
1.0
0.01
1
%
HORIZONTAL

SLIDER
1127
261
1354
294
air-refresh-rate
air-refresh-rate
0.0000001
15.0000001
1.0E-6
1
1
ACH
HORIZONTAL

SWITCH
879
819
1086
852
doors-open
doors-open
1
1
-1000

TEXTBOX
22
52
334
90
V = L x W x H = 14 x 12 x 2.7 = 453.6m^3
15
0.0
1

SWITCH
1130
360
1354
393
recirculation
recirculation
1
1
-1000

TEXTBOX
1131
297
1286
315
Air changes per hour from AC
11
0.0
1

MONITOR
4
1006
352
1059
average aerosol particles per patch (0.5m3)
averageConcentration
2
1
13

MONITOR
639
1076
760
1129
infectious currently
count waiters with [infected = true] + count customers with [infected = true] + count bartenders with [infected = true]
0
1
13

SWITCH
653
465
820
498
toggle-tables
toggle-tables
0
1
-1000

MONITOR
8
624
353
677
Aerosol concentration severity
concentrationReporter
4
1
13

SWITCH
1125
134
1352
167
top-windows-open
top-windows-open
1
1
-1000

PLOT
3
721
349
999
Viral aerosols per 0.125m3
seconds
Average number of viral aerosols
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -2674135 true "" "plot averageConcentration"

SWITCH
886
180
1081
213
coughing
coughing
0
1
-1000

SWITCH
886
258
1081
291
sneezing
sneezing
0
1
-1000

MONITOR
654
1017
801
1070
total customers served
total-customers
1
1
13

SWITCH
654
509
820
542
toggle-chairs
toggle-chairs
0
1
-1000

SLIDER
886
108
1092
141
volume
volume
50
70
60.0
10
1
db
HORIZONTAL

MONITOR
874
872
1076
925
Average Risk 
averageRisk
3
1
13

TEXTBOX
889
142
1080
160
silent - normal talking - loud talking
12
0.0
1

PLOT
628
720
865
931
Average risk of infection
seconds
Average infection risk
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -2674135 true "" "plot averageRisk"

TEXTBOX
888
478
1090
574
Mask - Inhalation effectiveness\nN95 - 90%, \nSurgical - 65%\nCloth - 40%, \nFace sheild - 23%\n\n
13
0.0
1

SLIDER
883
566
1080
599
mask-effectiveness-emission
mask-effectiveness-emission
1
100
17.0
1
1
%
HORIZONTAL

TEXTBOX
884
605
1073
704
Mask - Emission effectiveness\nN95 - 90%, \nSurgical - 65%\nCloth - 40%, \nFace sheild - 23%,\nMask with exhaust value - 0%\n\n
13
0.0
1

BUTTON
1129
317
1353
350
AC Off
acOff
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1125
172
1353
205
close windows
closeWindows
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SWITCH
653
47
836
80
manual-customer-spawn
manual-customer-spawn
1
1
-1000

TEXTBOX
660
80
813
98
Click centre of table to fill table
11
0.0
1

SLIDER
885
219
1081
252
cough-frequency
cough-frequency
1
diningTime
1.0
1
1
mins
HORIZONTAL

SLIDER
886
295
1082
328
sneeze-frequency
sneeze-frequency
1
diningTime
8.0
1
1
mins
HORIZONTAL

MONITOR
364
936
489
989
Average fomite risk
averageFomiteRisk
2
1
13

BUTTON
224
13
313
46
Step 1 tick
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
1131
399
1355
432
noOfPortableHEPA
noOfPortableHEPA
0
4
0.0
1
1
portable HEPA filters
HORIZONTAL

SWITCH
654
315
839
348
twoM-distanced-seating
twoM-distanced-seating
1
1
-1000

PLOT
363
720
618
932
Average Fomite Risk
seconds
Average fomite risk
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot averageFomiteRisk"

SWITCH
877
740
1085
773
sanitiser-on-tables
sanitiser-on-tables
1
1
-1000

TEXTBOX
1122
15
1309
37
3. Ventilation controls
18
0.0
1

TEXTBOX
656
15
834
37
1. General controls
18
0.0
1

TEXTBOX
888
377
1055
397
Mask Controls
15
0.0
1

TEXTBOX
881
717
1048
737
Fomite Controls
15
0.0
1

TEXTBOX
8
607
175
627
Aerosol output data
13
0.0
1

TEXTBOX
373
602
540
622
Fomite output data
13
0.0
1

MONITOR
368
622
616
675
Fomite risk severity
fomiteReporter
17
1
13

TEXTBOX
635
603
802
623
Infection risk data
13
0.0
1

TEXTBOX
373
996
517
1016
General output data
15
0.0
1

MONITOR
627
938
789
991
No. of probable infections
totalPutAtRisk
0
1
13

MONITOR
794
937
948
990
% of probable infections 
percentagePutAtRisk
2
1
13

SLIDER
654
278
841
311
length-of-service
length-of-service
1
5
4.0
1
1
hours
HORIZONTAL

SWITCH
654
545
819
578
exaggerated-colouring
exaggerated-colouring
1
1
-1000

TEXTBOX
654
145
828
188
1.1. General Safety Measures
18
0.0
1

MONITOR
370
1075
635
1128
Total of infectious people throughout service
total-infectious
17
1
13

TEXTBOX
7
586
74
611
Output
20
0.0
1

TEXTBOX
9
682
294
710
Graph showing an average of the number of viral aerosols across all patches in the restaurant, at a given tick.
11
0.0
1

TEXTBOX
369
678
566
720
Graph showing an average of fomite risk across all susceptible agents
11
0.0
1

TEXTBOX
352
613
367
1059
||||||||||||
30
0.0
1

TEXTBOX
615
612
630
989
||||||||||
30
0.0
1

TEXTBOX
632
678
847
720
Graph showing an average of the infection risk of all suceptible agents from aerosols and droplets.
11
0.0
1

TEXTBOX
654
397
804
419
View Controls
18
0.0
1

TEXTBOX
1101
13
1116
1160
|||||||||||||||||||||||||||||||
30
0.0
1

TEXTBOX
891
14
1055
33
2. Infection Controls
18
0.0
1

TEXTBOX
890
40
1040
62
2.1. Virus emission
18
0.0
1

TEXTBOX
888
159
1046
177
Symptom severity:
15
0.0
1

TEXTBOX
889
333
1074
375
2.2 Personal protective measures
18
0.0
1

TEXTBOX
864
10
879
935
|||||||||||||||||||||||
30
0.0
1

TEXTBOX
1123
41
1302
62
3.1 Natural ventilation
18
0.0
1

TEXTBOX
1126
69
1276
88
Windows
15
0.0
1

TEXTBOX
1128
211
1343
240
3.2 Mechanical ventilation
18
0.0
1

TEXTBOX
1129
236
1279
255
Air conditioning
15
0.0
1

TEXTBOX
364
975
933
1012
---------------------------------------------------
30
0.0
1

TEXTBOX
16
567
864
601
------------------------------------------------------------------------------
30
0.0
1

TEXTBOX
1121
430
1381
467
-----------------------
30
0.0
1

TEXTBOX
872
835
1128
861
---------------------
30
0.0
1

TEXTBOX
1129
493
1324
518
0.1 Setup Instructions
18
0.0
1

TEXTBOX
1127
525
1394
829
1. Following the numbering of the sections, enter the values that you wish to test, starting with setting the general controls, then infection controls, and lastly the ventilation controls (numbered)\n\n2. Click the setup button at the top left of the screen to setup a restaurant with the values you have entered.\n\n3. Familiarise yourself with what the agents are using the legend.\n\n4. To begin the simulation, click the 'Run Simulation' button 
15
0.0
1

TEXTBOX
1124
818
1329
844
0.2 Running Instructions
18
0.0
1

TEXTBOX
1128
464
1278
486
0.0 READ ME
18
0.0
1

TEXTBOX
1124
843
1421
1204
1. depending on the experiment, you may wish to alter parameters during the simulation. It is possible to alter parameters like view controls, personal protective measures and ventilation controls during the simulation.\n\n2. if manual-customer-spawn is on, to seat customers at the selected table, click the middle of the table. It may help to click several times. \n\n3. To infect a customer, waiter, or bartender, it is advisable to slow the simulation down using the slider in the interface heading tab. This will slow the movement of the agents to help you target them. To infected them you must click on them/the patch that they are on. \n
15
0.0
1

MONITOR
492
936
616
989
Hand contamination
averageHand
2
1
13

TEXTBOX
508
65
589
88
Legend:
18
0.0
1

TEXTBOX
649
361
865
390
-------------------
30
0.0
1

TEXTBOX
322
10
643
50
Further information available in the 'Info tab', top left of the screen
18
0.0
1

MONITOR
631
622
859
675
Risk Severity
riskReporter
17
1
13

@#$#@#$#@
## WHAT IS IT?

This project's objectives were achieved successfully by creating a simulation that captures how COVID-19 is transmitted from person to person in a restaurant setting. This includes transmission through viral aerosol particles, respiratory droplets, and fomites. The simulation also allows for COVID-19 safety measures such as physically distanced tables and face masks to be implemented. The output data can be analysed to gauge how effective a safety measure was, based on how significantly it reduced probable infections and infection risk. A combination of safety measure can also be tested to create the greatest reduction in infection risk. 

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)
customers will enter the restaurant and take a seat, and waiters will served them by periodically approaching their table to simulate a real life restaurant service such as taking orderrs, clearing plates ect. A table of customers will enter the restaurant every 300 ticks and sit at an empty tasble. they will remain in the restaurant for the duratino of booking time. when the service lim,it is exceeded, the customers will stop spawning and will begin to filter out of the restaurant. 

all mobile agents have the chance of being infectious, set but the slider in the virus emission controls section. infectious agents will output aerosol particles into the air within the boundaries of the restaurant. 

the higher the volume, the greater the number of particles produced. 

symptom severity can be altered through the adjustment of coughing and sneezing frequency. a large number of aerosols are produced by these events, expecially sneezing. 

sucsepitble agents will inhale the aerosol particles and their infection risk will be increased. the infectious code of covid is unknown but is estimate to be roughly 300 particles. once the agents infectious risk reaches over 300, they are likely to develop an infections

## HOW TO USE IT

setup
1. Following the numbering of the sections, enter the values that you wish to test, starting with setting the general controls, then infection controls, and lastly the ventilation controls (numbered)

2. Click the setup button at the top left of the screen to setup a restaurant with the values you have entered.

3. Familiarise yourself with what the agents are using the legend.

4. To begin the simulation, click the 'Run Simulation' button 


runtime
1. depending on the experiment, you may wish to alter parameters during the simulation. It is possible to alter parameters like view controls, personal protective measures and ventilation controls during the simulation.

2. if manual-customer-spawn is on, to seat customers at the selected table, click the middle of the table. It may help to click several times. 

3. To infect a customer, waiter, or bartender, it is advisable to slow the simulation down using the slider in the interface heading tab. This will slow the movement of the agents to help you target them. To infected them you must click on them/the patch that they are on. 

description of components

General controls:

- manual-customer-spawn: 
On: manually clicking tables to seat customers
Off: Automatic seating of customers

- noOfWaiters: Set the number of waiters 

- capacity: Set the occupancy limit of the restaurant

- diningTime: Set the length of a booking

- length-of-service: Set the length of time the restaurant is open for

- twoM-distanced-seating: 
On: Physically distanced seating configuration 
Off: Non-physically distanced seating configuration

Infection Controls:

- chance-of-being-infected: percentage of infections in the local community/chance customer is infectious.

- volume: volume of the restaurant

- coughing: coughing on/off

- cough-frequency: time between coughs

- sneezing: sneezing on/off

- sneeze-frequency: time between sneezes

- masks: people wear masks/not wearing masks

- mask-effectiveness-inhalation: percentage of particles blocked by mask inhaling

- mask-effectiveness-emission: percentage of particles blocked by mask exhaling

- sanitiser-on-tables: customers use sanitiser on table

- handwashing-thoroughness: percentage of contaminants removed from hand

- doors-open: front door open/closed

Ventilation controls:

- left-windows-open: left windows open/closed

- top-windows-open:top windows open/closed

- close windows: close all windows

- air-refresh-rate: air changes per hour from the AC

- AC off: turn AC off

- recirculation: AC recirculates the restaurants air

- noOfPortableHEPA: number of portable HEPA filters placed in the restaurant


Output:

- Aerosol output data:

- Aerosol concentration severity: low medium high of how high the concentration levels are
- Viral aerosols per 0.125m3 graph: graph showing an avergae of the number of viral aerosols across all patches in the restaurant, at a given tick. 
- average aerosol particles per patch: the current average viural aerosols at each patch

Fomite Output data:

- Fomite risk severity: low, medium, high risk of fomites. 

- average fomite risk graph: graph showing the averahe fomite risk of all agents at a given tick

- Average fomite risk: the current average fomite risk value

- Hand contamination: the average contamination of agents hands

Infection risk data:

- risk severity: low medium high rating of current risk

- Average risk of infection graph: show the average risk of infection of all aagents at a given tick

- no.of probable infections: the number of probabl infections produced so far into the simulation

- % of probable infection: the percentage of people in the restaurant who have been infected

General output data:

- Current Seating Area Occupancy: total count of everyone currently in the restaurant

- Floor staff: the number watiers and bartenders

- total customers served: the total number of customers served so far

- total of infectious peoplle through service: the total number of infectious people who have been in the restaurant

- infectious currently: the number of currently infectious people in the restaurant



## THINGS TO NOTICE



## THINGS TO TRY

if you want to, you can click on a table and customers will sit there, or you can click a mobile agent and they will becom infected

try opening the windows and observe the flow of aerosol particles 

trying using the view controls

## EXTENDING THE MODEL

- load in restaurant from file
- click to create restaurant by placing tables etc manually
- save a specific configuration
- save a specific ordering of customers for re-testing
- further physicaly distancing, customers choose a seat far away from other tables
- wind directions and wind speed
- one-way system
- use of washroom
- portable fans to accelerate air flow
- adjust booking arrival intervals
- queue system
- reduced waiter contact
- more realistic dissipation of virus particles from breathing coughing etc

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

infectedturtle
true
14
Polygon -16777216 true true 150 5 40 250 150 205 260 250
Polygon -2674135 true false 150 45 75 210 150 180 225 210

largetable
false
0
Rectangle -7500403 true true 135 90 165 225

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sanitisationstation
false
0
Circle -7500403 true true 0 0 300
Rectangle -16777216 true false 75 45 210 75
Rectangle -16777216 true false 75 75 105 165
Rectangle -16777216 true false 105 135 210 165
Rectangle -16777216 true false 180 165 210 255
Rectangle -16777216 true false 75 225 180 255

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

sink
true
0
Polygon -7500403 true true 150 225 210 225 240 210 255 180 255 105 45 105 45 180 60 210 90 225 150 225 180 195
Circle -16777216 true false 90 105 30
Circle -16777216 true false 180 105 30
Circle -16777216 true false 135 165 30
Rectangle -16777216 true false 105 120 120 150
Rectangle -16777216 true false 180 120 195 150
Rectangle -7500403 true true 45 90 255 105

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
true
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240
Rectangle -1 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

tableofeight
false
0
Circle -7500403 true true 0 0 300

tableofsix
true
0
Rectangle -7500403 true true 75 45 210 255

tableoftwo
false
0
Rectangle -7500403 true true 30 30 270 270

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

toilet
true
0
Rectangle -7500403 true true 270 90 300 210
Circle -7500403 true true 148 88 124
Circle -7500403 false true 176 116 67
Circle -1 true false 178 118 62
Rectangle -16777216 true false 285 180 300 195

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.2.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="test" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <metric>averageConcentration</metric>
    <enumeratedValueSet variable="air-refresh-rate">
      <value value="2"/>
      <value value="4"/>
      <value value="6"/>
      <value value="8"/>
      <value value="10"/>
      <value value="12"/>
      <value value="14"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="physically distanced tables" repetitions="40" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>ticks = 18000</exitCondition>
    <metric>averageRisk</metric>
    <metric>totalPutAtRisk</metric>
    <metric>percentagePutAtRisk</metric>
    <enumeratedValueSet variable="manual-customer-spawn">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfWaiters">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="capacity">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="diningTime">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="twoM-distanced-seating">
      <value value="true"/>
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-of-being-infected">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="volume">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="coughing">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cough-frequency">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneezing">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneeze-frequency">
      <value value="45"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="left-windows-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="top-windows-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="air-refresh-rate">
      <value value="7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="recirculation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfPortableHEPA">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="masks">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-inhalation">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-emission">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="handwashing-thoroughness">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitiser-on-tables">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="doors-open">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="chance of being infectious test" repetitions="40" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>ticks = 13000</exitCondition>
    <metric>total-infectious</metric>
    <metric>total-customers</metric>
    <enumeratedValueSet variable="manual-customer-spawn">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfWaiters">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="capacity">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="diningTime">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="twoM-distanced-seating">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-of-being-infected">
      <value value="0"/>
      <value value="0.1"/>
      <value value="1"/>
      <value value="20"/>
      <value value="40"/>
      <value value="60"/>
      <value value="80"/>
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="volume">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="coughing">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cough-frequency">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneezing">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneeze-frequency">
      <value value="45"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="left-windows-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="top-windows-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="air-refresh-rate">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="recirculation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfPortableHEPA">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="masks">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-inhalation">
      <value value="99"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-emission">
      <value value="99"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sink-hand-washing">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="handwashing-thoroughness">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="doors-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitiser-use">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitiser-on-tables">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="vocalisation test" repetitions="40" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>ticks = 13000</exitCondition>
    <metric>averageConcentration</metric>
    <enumeratedValueSet variable="manual-customer-spawn">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfWaiters">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="capacity">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="diningTime">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="length-of-service">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="twoM-distanced-seating">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-of-being-infected">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="volume">
      <value value="50"/>
      <value value="60"/>
      <value value="70"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="coughing">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cough-frequency">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneezing">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneeze-frequency">
      <value value="45"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="left-windows-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="top-windows-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="air-refresh-rate">
      <value value="1.0E-4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="recirculation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfPortableHEPA">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="masks">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-inhalation">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-emission">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sink-hand-washing">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="handwashing-thoroughness">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="doors-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitiser-use">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitiser-on-tables">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="coughing and sneezing test" repetitions="40" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>ticks = 13000</exitCondition>
    <metric>averageConcentration</metric>
    <enumeratedValueSet variable="manual-customer-spawn">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfWaiters">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="capacity">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="diningTime">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="twoM-distanced-seating">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="length-of-service">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-of-being-infected">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="volume">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="coughing">
      <value value="true"/>
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cough-frequency">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneezing">
      <value value="true"/>
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneeze-frequency">
      <value value="45"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="left-windows-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="top-windows-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="air-refresh-rate">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="recirculation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfPortableHEPA">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="masks">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-inhalation">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-emission">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sink-hand-washing">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="handwashing-thoroughness">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="doors-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitiser-use">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitiser-on-tables">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="coughing frequency test" repetitions="40" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>ticks = 13000</exitCondition>
    <metric>averageConcentration</metric>
    <enumeratedValueSet variable="manual-customer-spawn">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfWaiters">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="capacity">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="diningTime">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="twoM-distanced-seating">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="length-of-service">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-of-being-infected">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="volume">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="coughing">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cough-frequency">
      <value value="1"/>
      <value value="5"/>
      <value value="10"/>
      <value value="15"/>
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneezing">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneeze-frequency">
      <value value="45"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="left-windows-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="top-windows-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="air-refresh-rate">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="recirculation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfPortableHEPA">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="masks">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-inhalation">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-emission">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sink-hand-washing">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="handwashing-thoroughness">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="doors-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitiser-use">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitiser-on-tables">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="hand cont test" repetitions="2" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>ticks = 13000</exitCondition>
    <metric>averageHand</metric>
    <enumeratedValueSet variable="manual-customer-spawn">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfWaiters">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="capacity">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="diningTime">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="twoM-distanced-seating">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-of-being-infected">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="volume">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="coughing">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cough-frequency">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneezing">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneeze-frequency">
      <value value="45"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="left-windows-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="top-windows-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="air-refresh-rate">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="recirculation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfPortableHEPA">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="masks">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-inhalation">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-emission">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sink-hand-washing">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="handwashing-thoroughness">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="doors-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitiser-use">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitiser-on-tables">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="inhalation test" repetitions="2" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>ticks = 13000</exitCondition>
    <metric>averageConcentration</metric>
    <metric>averageRisk</metric>
    <enumeratedValueSet variable="manual-customer-spawn">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfWaiters">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="capacity">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="diningTime">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="twoM-distanced-seating">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-of-being-infected">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="volume">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="coughing">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cough-frequency">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneezing">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneeze-frequency">
      <value value="45"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="left-windows-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="top-windows-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="air-refresh-rate">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="recirculation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfPortableHEPA">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="masks">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-inhalation">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-emission">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sink-hand-washing">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="handwashing-thoroughness">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="doors-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitiser-use">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitiser-on-tables">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="booking time test" repetitions="40" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>ticks = 20000</exitCondition>
    <metric>percentagePutAtRisk</metric>
    <enumeratedValueSet variable="manual-customer-spawn">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfWaiters">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="capacity">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="diningTime">
      <value value="30"/>
      <value value="45"/>
      <value value="60"/>
      <value value="75"/>
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="length-of-service">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="twoM-distanced-seating">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-of-being-infected">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="volume">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="coughing">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cough-frequency">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneezing">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneeze-frequency">
      <value value="45"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="left-windows-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="top-windows-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="air-refresh-rate">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="recirculation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfPortableHEPA">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="masks">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-inhalation">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-emission">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sink-hand-washing">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="handwashing-thoroughness">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="doors-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitiser-use">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitiser-on-tables">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="service time test" repetitions="40" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>ticks = 25000</exitCondition>
    <metric>totalPutAtRisk</metric>
    <enumeratedValueSet variable="manual-customer-spawn">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfWaiters">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="capacity">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="diningTime">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="length-of-service">
      <value value="1"/>
      <value value="2"/>
      <value value="3"/>
      <value value="4"/>
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="twoM-distanced-seating">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-of-being-infected">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="volume">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="coughing">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cough-frequency">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneezing">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneeze-frequency">
      <value value="45"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="left-windows-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="top-windows-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="air-refresh-rate">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="recirculation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfPortableHEPA">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="masks">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-inhalation">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-emission">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sink-hand-washing">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="handwashing-thoroughness">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="doors-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitiser-use">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitiser-on-tables">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="service and booking time test" repetitions="40" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>ticks = 12000</exitCondition>
    <metric>totalPutAtRisk</metric>
    <metric>percentagePutAtRisk</metric>
    <enumeratedValueSet variable="manual-customer-spawn">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfWaiters">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="capacity">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="diningTime">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="length-of-service">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="twoM-distanced-seating">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-of-being-infected">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="volume">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="coughing">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cough-frequency">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneezing">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneeze-frequency">
      <value value="45"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="left-windows-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="top-windows-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="air-refresh-rate">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="recirculation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfPortableHEPA">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="masks">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-inhalation">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-emission">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sink-hand-washing">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="handwashing-thoroughness">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="doors-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitiser-use">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitiser-on-tables">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="masks test" repetitions="40" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>ticks = 12000</exitCondition>
    <metric>totalPutAtRisk</metric>
    <metric>averageConcentration</metric>
    <metric>averageRisk</metric>
    <enumeratedValueSet variable="manual-customer-spawn">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfWaiters">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="capacity">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="diningTime">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="length-of-service">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="twoM-distanced-seating">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-of-being-infected">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="volume">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="coughing">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cough-frequency">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneezing">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneeze-frequency">
      <value value="45"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="left-windows-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="top-windows-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="air-refresh-rate">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="recirculation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfPortableHEPA">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="masks">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-inhalation">
      <value value="0"/>
      <value value="50"/>
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-emission">
      <value value="0"/>
      <value value="50"/>
      <value value="90"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sink-hand-washing">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="handwashing-thoroughness">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="doors-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitiser-use">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitiser-on-tables">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="hand washing thoroughness test" repetitions="40" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>ticks = 13000</exitCondition>
    <metric>averageFomiteRisk</metric>
    <metric>averageHand</metric>
    <enumeratedValueSet variable="manual-customer-spawn">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfWaiters">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="capacity">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="diningTime">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="length-of-service">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="twoM-distanced-seating">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-of-being-infected">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="volume">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="coughing">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cough-frequency">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneezing">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneeze-frequency">
      <value value="45"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="left-windows-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="top-windows-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="air-refresh-rate">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="recirculation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfPortableHEPA">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="masks">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-inhalation">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-emission">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sink-hand-washing">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="handwashing-thoroughness">
      <value value="0"/>
      <value value="25"/>
      <value value="50"/>
      <value value="75"/>
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="doors-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitiser-use">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitiser-on-tables">
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="capcaity test" repetitions="40" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>ticks = 15000</exitCondition>
    <metric>averageRisk</metric>
    <metric>totalPutAtRisk</metric>
    <metric>percentagePutAtRisk</metric>
    <enumeratedValueSet variable="manual-customer-spawn">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfWaiters">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="capacity">
      <value value="30"/>
      <value value="40"/>
      <value value="50"/>
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="diningTime">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="length-of-service">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="twoM-distanced-seating">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-of-being-infected">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="volume">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="coughing">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cough-frequency">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneezing">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneeze-frequency">
      <value value="45"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="left-windows-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="top-windows-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="air-refresh-rate">
      <value value="7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="recirculation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfPortableHEPA">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="masks">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-inhalation">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-emission">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="handwashing-thoroughness">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitiser-on-tables">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="doors-open">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="air refresh rate test" repetitions="20" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>ticks = 13000</exitCondition>
    <metric>averageConcentration</metric>
    <metric>totalPutAtRisk</metric>
    <metric>averageRisk</metric>
    <enumeratedValueSet variable="manual-customer-spawn">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfWaiters">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="capacity">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="diningTime">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="length-of-service">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="twoM-distanced-seating">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-of-being-infected">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="volume">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="coughing">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cough-frequency">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneezing">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneeze-frequency">
      <value value="45"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="left-windows-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="top-windows-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="air-refresh-rate">
      <value value="1.0E-7"/>
      <value value="2"/>
      <value value="4"/>
      <value value="6"/>
      <value value="8"/>
      <value value="10"/>
      <value value="12"/>
      <value value="14"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="recirculation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfPortableHEPA">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="masks">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-inhalation">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-emission">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sink-hand-washing">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="handwashing-thoroughness">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="doors-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitiser-use">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitiser-on-tables">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="hepa test" repetitions="20" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>ticks = 13000</exitCondition>
    <metric>averageConcentration</metric>
    <metric>totalPutAtRisk</metric>
    <metric>averageRisk</metric>
    <enumeratedValueSet variable="manual-customer-spawn">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfWaiters">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="capacity">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="diningTime">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="length-of-service">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="twoM-distanced-seating">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-of-being-infected">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="volume">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="coughing">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cough-frequency">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneezing">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneeze-frequency">
      <value value="45"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="left-windows-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="top-windows-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="air-refresh-rate">
      <value value="1.0E-7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="recirculation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfPortableHEPA">
      <value value="0"/>
      <value value="1"/>
      <value value="2"/>
      <value value="3"/>
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="masks">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-inhalation">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-emission">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sink-hand-washing">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="handwashing-thoroughness">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="doors-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitiser-use">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitiser-on-tables">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="both open test" repetitions="40" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>ticks = 13000</exitCondition>
    <metric>averageConcentration</metric>
    <metric>totalPutAtRisk</metric>
    <metric>averageRisk</metric>
    <enumeratedValueSet variable="manual-customer-spawn">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfWaiters">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="capacity">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="diningTime">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="length-of-service">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="twoM-distanced-seating">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-of-being-infected">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="volume">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="coughing">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cough-frequency">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneezing">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneeze-frequency">
      <value value="45"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="left-windows-open">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="top-windows-open">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="air-refresh-rate">
      <value value="1.0E-8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="recirculation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfPortableHEPA">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="masks">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-inhalation">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-emission">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sink-hand-washing">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="handwashing-thoroughness">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="doors-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitiser-use">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitiser-on-tables">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="ac 5 test" repetitions="40" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>ticks = 13000</exitCondition>
    <metric>averageConcentration</metric>
    <metric>totalPutAtRisk</metric>
    <metric>averageRisk</metric>
    <enumeratedValueSet variable="manual-customer-spawn">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfWaiters">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="capacity">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="diningTime">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="length-of-service">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="twoM-distanced-seating">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-of-being-infected">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="volume">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="coughing">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cough-frequency">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneezing">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneeze-frequency">
      <value value="45"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="left-windows-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="top-windows-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="air-refresh-rate">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="recirculation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfPortableHEPA">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="masks">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-inhalation">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-emission">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sink-hand-washing">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="handwashing-thoroughness">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="doors-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitiser-use">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitiser-on-tables">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="capacity validation" repetitions="4" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>ticks = 13000</exitCondition>
    <metric>count customers</metric>
    <enumeratedValueSet variable="manual-customer-spawn">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfWaiters">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="capacity">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="diningTime">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="length-of-service">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="twoM-distanced-seating">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-of-being-infected">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="volume">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="coughing">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cough-frequency">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneezing">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneeze-frequency">
      <value value="45"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="left-windows-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="top-windows-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="air-refresh-rate">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="recirculation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfPortableHEPA">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="masks">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-inhalation">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-emission">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sink-hand-washing">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="handwashing-thoroughness">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="doors-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitiser-use">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitiser-on-tables">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="booking length validation" repetitions="4" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>ticks = 13000</exitCondition>
    <metric>count customers</metric>
    <enumeratedValueSet variable="manual-customer-spawn">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfWaiters">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="capacity">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="diningTime">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="length-of-service">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="twoM-distanced-seating">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-of-being-infected">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="volume">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="coughing">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cough-frequency">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneezing">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneeze-frequency">
      <value value="45"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="left-windows-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="top-windows-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="air-refresh-rate">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="recirculation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfPortableHEPA">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="masks">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-inhalation">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-emission">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sink-hand-washing">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="handwashing-thoroughness">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="doors-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitiser-use">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitiser-on-tables">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="chance of infectious test" repetitions="4" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>ticks = 13000</exitCondition>
    <metric>count customers</metric>
    <enumeratedValueSet variable="manual-customer-spawn">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfWaiters">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="capacity">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="diningTime">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="length-of-service">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="twoM-distanced-seating">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-of-being-infected">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="volume">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="coughing">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cough-frequency">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneezing">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneeze-frequency">
      <value value="45"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="left-windows-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="top-windows-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="air-refresh-rate">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="recirculation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfPortableHEPA">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="masks">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-inhalation">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-emission">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sink-hand-washing">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="handwashing-thoroughness">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="doors-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitiser-use">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitiser-on-tables">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="masks emissions test" repetitions="30" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>ticks = 12000</exitCondition>
    <metric>averageConcentration</metric>
    <enumeratedValueSet variable="manual-customer-spawn">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfWaiters">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="capacity">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="diningTime">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="length-of-service">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="twoM-distanced-seating">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-of-being-infected">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="volume">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="coughing">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cough-frequency">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneezing">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneeze-frequency">
      <value value="45"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="left-windows-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="top-windows-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="air-refresh-rate">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="recirculation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfPortableHEPA">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="masks">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-inhalation">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-emission">
      <value value="0"/>
      <value value="20"/>
      <value value="40"/>
      <value value="60"/>
      <value value="80"/>
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sink-hand-washing">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="handwashing-thoroughness">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="doors-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitiser-use">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitiser-on-tables">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="unsafe restaurant" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>ticks = 19000</exitCondition>
    <metric>totalPutAtRisk</metric>
    <metric>percentagePutAtRisk</metric>
    <metric>averageRisk</metric>
    <metric>averageConcentration</metric>
    <enumeratedValueSet variable="manual-customer-spawn">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfWaiters">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="capacity">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="diningTime">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="length-of-service">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="twoM-distanced-seating">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-of-being-infected">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="volume">
      <value value="70"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="coughing">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cough-frequency">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneezing">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneeze-frequency">
      <value value="45"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="left-windows-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="top-windows-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="air-refresh-rate">
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="recirculation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfPortableHEPA">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="masks">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-inhalation">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-emission">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sink-hand-washing">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="handwashing-thoroughness">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="doors-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitiser-use">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitiser-on-tables">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="safe restaurant" repetitions="100" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>ticks = 13500</exitCondition>
    <metric>totalPutAtRisk</metric>
    <metric>percentagePutAtRisk</metric>
    <metric>averageRisk</metric>
    <metric>averageConcentration</metric>
    <enumeratedValueSet variable="manual-customer-spawn">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfWaiters">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="capacity">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="diningTime">
      <value value="45"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="length-of-service">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="twoM-distanced-seating">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-of-being-infected">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="volume">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="coughing">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cough-frequency">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneezing">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneeze-frequency">
      <value value="45"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="left-windows-open">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="top-windows-open">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="air-refresh-rate">
      <value value="7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="recirculation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfPortableHEPA">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="masks">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-inhalation">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-emission">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitiser-on-tables">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="handwashing-thoroughness">
      <value value="70"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="doors-open">
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="2 reduced booking time" repetitions="20" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>ticks = 20000</exitCondition>
    <metric>averageRisk</metric>
    <metric>totalPutAtRisk</metric>
    <metric>percentagePutAtRisk</metric>
    <enumeratedValueSet variable="manual-customer-spawn">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfWaiters">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="capacity">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="length-of-service">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="diningTime">
      <value value="90"/>
      <value value="75"/>
      <value value="60"/>
      <value value="45"/>
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="twoM-distanced-seating">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-of-being-infected">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="volume">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="coughing">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cough-frequency">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneezing">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneeze-frequency">
      <value value="45"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="left-windows-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="top-windows-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="air-refresh-rate">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="recirculation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfPortableHEPA">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="masks">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-inhalation">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-emission">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="handwashing-thoroughness">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitiser-on-tables">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="doors-open">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="1 phys dist" repetitions="40" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>ticks = 20000</exitCondition>
    <metric>averageRisk</metric>
    <metric>totalPutAtRisk</metric>
    <metric>percentagePutAtRisk</metric>
    <enumeratedValueSet variable="manual-customer-spawn">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfWaiters">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="capacity">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="length-of-service">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="diningTime">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="twoM-distanced-seating">
      <value value="true"/>
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-of-being-infected">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="volume">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="coughing">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cough-frequency">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneezing">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneeze-frequency">
      <value value="45"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="left-windows-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="top-windows-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="air-refresh-rate">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="recirculation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfPortableHEPA">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="masks">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-inhalation">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-emission">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="handwashing-thoroughness">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitiser-on-tables">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="doors-open">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="2 capacity t" repetitions="20" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>ticks = 20000</exitCondition>
    <metric>averageRisk</metric>
    <metric>totalPutAtRisk</metric>
    <metric>percentagePutAtRisk</metric>
    <enumeratedValueSet variable="manual-customer-spawn">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfWaiters">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="capacity">
      <value value="30"/>
      <value value="40"/>
      <value value="50"/>
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="length-of-service">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="diningTime">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="twoM-distanced-seating">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-of-being-infected">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="volume">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="coughing">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cough-frequency">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneezing">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneeze-frequency">
      <value value="45"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="left-windows-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="top-windows-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="air-refresh-rate">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="recirculation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfPortableHEPA">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="masks">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-inhalation">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-emission">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="handwashing-thoroughness">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitiser-on-tables">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="doors-open">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="3 service length t" repetitions="4" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>ticks = 21000</exitCondition>
    <metric>averageRisk</metric>
    <metric>totalPutAtRisk</metric>
    <metric>percentagePutAtRisk</metric>
    <enumeratedValueSet variable="manual-customer-spawn">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfWaiters">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="capacity">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="length-of-service">
      <value value="1"/>
      <value value="2"/>
      <value value="3"/>
      <value value="4"/>
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="diningTime">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="twoM-distanced-seating">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-of-being-infected">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="volume">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="coughing">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cough-frequency">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneezing">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneeze-frequency">
      <value value="45"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="left-windows-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="top-windows-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="air-refresh-rate">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="recirculation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfPortableHEPA">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="masks">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-inhalation">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-emission">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="handwashing-thoroughness">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitiser-on-tables">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="doors-open">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="4 volume" repetitions="40" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>ticks = 18000</exitCondition>
    <metric>averageRisk</metric>
    <metric>totalPutAtRisk</metric>
    <metric>percentagePutAtRisk</metric>
    <enumeratedValueSet variable="manual-customer-spawn">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfWaiters">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="capacity">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="length-of-service">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="diningTime">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="twoM-distanced-seating">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-of-being-infected">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="volume">
      <value value="50"/>
      <value value="60"/>
      <value value="70"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="coughing">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cough-frequency">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneezing">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneeze-frequency">
      <value value="45"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="left-windows-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="top-windows-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="air-refresh-rate">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="recirculation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfPortableHEPA">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="masks">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-inhalation">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-emission">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="handwashing-thoroughness">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitiser-on-tables">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="doors-open">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="5 masks" repetitions="20" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>ticks = 18000</exitCondition>
    <metric>averageRisk</metric>
    <metric>totalPutAtRisk</metric>
    <metric>percentagePutAtRisk</metric>
    <enumeratedValueSet variable="manual-customer-spawn">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfWaiters">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="capacity">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="length-of-service">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="diningTime">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="twoM-distanced-seating">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-of-being-infected">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="volume">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="coughing">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cough-frequency">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneezing">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneeze-frequency">
      <value value="45"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="left-windows-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="top-windows-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="air-refresh-rate">
      <value value="7.0E-7"/>
      <value value="2"/>
      <value value="4"/>
      <value value="6"/>
      <value value="8"/>
      <value value="10"/>
      <value value="12"/>
      <value value="14"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="recirculation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfPortableHEPA">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="masks">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-inhalation">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-emission">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="handwashing-thoroughness">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitiser-on-tables">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="doors-open">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="6 mech ach" repetitions="40" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>ticks = 18000</exitCondition>
    <metric>averageRisk</metric>
    <metric>totalPutAtRisk</metric>
    <metric>percentagePutAtRisk</metric>
    <enumeratedValueSet variable="manual-customer-spawn">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfWaiters">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="capacity">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="length-of-service">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="diningTime">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="twoM-distanced-seating">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-of-being-infected">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="volume">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="coughing">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cough-frequency">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneezing">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneeze-frequency">
      <value value="45"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="left-windows-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="top-windows-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="air-refresh-rate">
      <value value="7.0E-7"/>
      <value value="2"/>
      <value value="4"/>
      <value value="6"/>
      <value value="8"/>
      <value value="10"/>
      <value value="12"/>
      <value value="14"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="recirculation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfPortableHEPA">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="masks">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-inhalation">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-emission">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="handwashing-thoroughness">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitiser-on-tables">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="doors-open">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="7 windows vs mch" repetitions="20" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>ticks = 18000</exitCondition>
    <metric>averageConcentration</metric>
    <metric>totalPutAtRisk</metric>
    <metric>percentagePutAtRisk</metric>
    <enumeratedValueSet variable="manual-customer-spawn">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfWaiters">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="capacity">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="length-of-service">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="diningTime">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="twoM-distanced-seating">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-of-being-infected">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="volume">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="coughing">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cough-frequency">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneezing">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneeze-frequency">
      <value value="45"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="left-windows-open">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="top-windows-open">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="air-refresh-rate">
      <value value="7.0E-7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="recirculation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfPortableHEPA">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="masks">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-inhalation">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-emission">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="handwashing-thoroughness">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitiser-on-tables">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="doors-open">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="7 windows vs mch 2" repetitions="20" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>ticks = 18000</exitCondition>
    <metric>averageConcentration</metric>
    <metric>totalPutAtRisk</metric>
    <metric>percentagePutAtRisk</metric>
    <enumeratedValueSet variable="manual-customer-spawn">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfWaiters">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="capacity">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="length-of-service">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="diningTime">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="twoM-distanced-seating">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-of-being-infected">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="volume">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="coughing">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cough-frequency">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneezing">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneeze-frequency">
      <value value="45"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="left-windows-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="top-windows-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="air-refresh-rate">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="recirculation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfPortableHEPA">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="masks">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-inhalation">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-emission">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="handwashing-thoroughness">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitiser-on-tables">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="doors-open">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="8 booking ans service" repetitions="20" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>ticks = 18000</exitCondition>
    <metric>averageConcentration</metric>
    <metric>totalPutAtRisk</metric>
    <metric>percentagePutAtRisk</metric>
    <enumeratedValueSet variable="manual-customer-spawn">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfWaiters">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="capacity">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="length-of-service">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="diningTime">
      <value value="45"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="twoM-distanced-seating">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="chance-of-being-infected">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="volume">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="coughing">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cough-frequency">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneezing">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sneeze-frequency">
      <value value="45"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="left-windows-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="top-windows-open">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="air-refresh-rate">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="recirculation">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="noOfPortableHEPA">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="masks">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-inhalation">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="mask-effectiveness-emission">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="handwashing-thoroughness">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sanitiser-on-tables">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="doors-open">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
