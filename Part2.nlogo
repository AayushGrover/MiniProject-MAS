globals [
  ;;score of all turtles
  red-score
  blue-score

  blue-h-line?
  red-h-line?
  blue-v-line?
  red-v-line?
  two-lines?
]

turtles-own [
  score     ;;is 0 if not in a line, 1 if in a h-line & 2 if in a v-line (not to be confused with payoff)
  partner
  color-t
  in-v-line?
  in-h-line?
]


;;;;;;;;;;;;;;;;;;;;;;
;;;Setup Procedures;;;
;;;;;;;;;;;;;;;;;;;;;;

to setup
  clear-all
  setup-turtles ;;setup the turtles and distribute them randomly
  set red-v-line? false
  set red-h-line? false
  set blue-v-line? false
  set blue-h-line? false
  set two-lines? false
  set red-score 0
  set blue-score 0
  reset-ticks
end


;;setup the turtles and distribute them randomly
to setup-turtles
  clear-all
  make-turtles ;;create the appropriate number of turtles of each color
  setup-common-variables ;;sets the variables that all turtles share
  reset-ticks
end

;;create the appropriate number of turtles playing each strategy
to make-turtles
  create-turtles 10 [ set color red set color-t "red"]
  create-turtles 10 [ set color blue set color-t "blue"]
end

;;set the variables that all turtles share
to setup-common-variables
  ask turtles [
    set score 0
    set partner nobody
    set in-h-line? false
    set in-v-line? false
    setxy random-xcor random-ycor
  ]
end


;;;;;;;;;;;;;;;;;;;;;;;;
;;;Runtime Procedures;;;
;;;;;;;;;;;;;;;;;;;;;;;;

to go
  let moving-turtles turtles with [ score = 0 ]
  ifelse (red-v-line? or red-h-line? or blue-v-line? or blue-h-line?) [
      ask moving-turtles [ form-line ]
  ][
    ifelse (random-float 1 < 0.5) [
      let moving-turtles-red turtles with [ score = 0 and color-t = "red"]
      ask moving-turtles-red [ form-v-line ]
;      if (v-line?) [
        let moving-turtles-blue turtles with [ score = 0 and color-t = "blue"]
        ask moving-turtles-blue [ form-v-line ]
;      ]
    ][
      let moving-turtles-red turtles with [ score = 0 and color-t = "red"]
      ask moving-turtles-red [ form-h-line ]
;      if (h-line?) [
        let moving-turtles-blue turtles with [ score = 0 and color-t = "blue"]
        ask moving-turtles-blue [ form-h-line ]
;      ]
    ]
  ]
  get-scores
  tick
end

;;have turtles try to find a partner
;;Since other turtles that have already executed partner-up may have
;;caused the turtle executing partner-up to be partnered,
;;a check is needed to make sure the calling turtle isn't partnered.

to form-line ;;turtle procedure
    set heading (45 * random 8)
    ;;rt (random-float 90 - random-float 90)
    ifelse any? turtles-on patch-ahead 1
    [ ]
    [ fd 1 ]     ;;move around randomly

    ifelse (two-lines?)[
    ifelse (color-t = "red") [
    set partner one-of (turtles-at -1 0) with [ in-h-line? and color-t = "red" ]
    ifelse partner != nobody [
      set heading 90
      set score 1
      set in-h-line? true
        ask partner [
          set heading 90
          set score 1
          set in-h-line? true
        ]
      set ycor ([ycor] of partner)
      set xcor ([xcor + 1] of partner)
    ][
      set partner one-of (turtles-at 1 0) with [ in-h-line? and color-t = "red" ]
      ifelse partner != nobody [
        set heading 90
        set score 1
        set in-h-line? true
          ask partner [
            set heading 90
            set score 1
            set in-h-line? true
        ]
        set ycor ([ycor] of partner)
        set xcor ([xcor - 1] of partner)
      ]
   [
   set partner one-of (turtles-at 0 1) with [ in-v-line? and color-t = "red" ]
        ifelse partner != nobody [
          set heading 0
          set score 1
          set in-v-line? true
            ask partner [
              set heading 0
              set score 1
              set in-v-line? true
            ]
          set xcor ([xcor] of partner)
          set ycor ([ycor - 1] of partner)
        ][
          set partner one-of (turtles-at 0 -1) with [ in-v-line? and color-t = "red" ]
          if partner != nobody [
            set heading 0
            set score 1
            set in-v-line? true
              ask partner [
                set heading 0
                set score 1
                set in-v-line? true
              ]
            set xcor ([xcor] of partner)
            set ycor ([ycor + 1] of partner)
          ]
        ]
      ]
  ]
  ][
    set partner one-of (turtles-at -1 0) with [ in-h-line? and color-t = "blue" ]
    ifelse partner != nobody [
      set heading 90
      set score 1
      set in-h-line? true
        ask partner [
          set heading 90
          set score 1
          set in-h-line? true
        ]
      set ycor ([ycor] of partner)
      set xcor ([xcor + 1] of partner)
    ][
      set partner one-of (turtles-at 1 0) with [ in-h-line? and color-t = "blue" ]
      ifelse partner != nobody [
        set heading 90
        set score 1
        set in-h-line? true
          ask partner [
            set heading 90
            set score 1
            set in-h-line? true
          ]
        set ycor ([ycor] of partner)
        set xcor ([xcor - 1] of partner)

      ]
   [
   set partner one-of (turtles-at 0 1) with [ in-v-line? and color-t = "blue" ]
        ifelse partner != nobody [
          set heading 0
          set score 1
          set in-v-line? true
            ask partner [
              set heading 0
              set score 1
              set in-v-line? true
            ]
          set xcor ([xcor] of partner)
          set ycor ([ycor - 1] of partner)
        ][
          set partner one-of (turtles-at 0 -1) with [ in-v-line? and color-t = "blue" ]
          if partner != nobody [
            set heading 0
            set score 1
            set in-v-line? true
              ask partner [
                set heading 0
                set score 1
                set in-v-line? true
              ]
            set xcor ([xcor] of partner)
            set ycor ([ycor + 1] of partner)
          ]
        ]
      ]
  ]
  ]
  ]
  [
    ifelse (red-h-line?)
    [
      let still-moving-turtles turtles with [score = 0 and color-t = "blue"]
      ask still-moving-turtles [form-h-line]
    ]
    [
      ifelse (red-v-line?)
      [
        let still-moving-turtles turtles with [score = 0 and color-t = "blue"]
        ask still-moving-turtles [form-v-line]
      ]
      [
        ifelse (blue-h-line?)
        [
          let still-moving-turtles turtles with [score = 0 and color-t = "red"]
          ask still-moving-turtles [form-h-line]
        ]
        [
          let still-moving-turtles turtles with [score = 0 and color-t = "red"]
          ask still-moving-turtles [form-v-line]
        ]
      ]
    ]
  ]
end

to form-v-line ;;turtle procedure
    if (not two-lines?) [
    set heading (45 * random 8)
    ;;rt (random-float 90 - random-float 90)
    ifelse any? turtles-on patch-ahead 1
    [ ]
    [ fd 1 ]     ;;move around randomly

    ifelse (color-t = "blue") [
    set partner one-of (turtles-at 0 1) with [color-t = "blue"]
    ifelse partner != nobody [
      set heading 0
      set score 1
      set in-v-line? true
      ask partner [
        set heading 0
        set score 1
        set in-v-line? true
      ]
      set xcor ([xcor] of partner)
      set ycor ([ycor - 1] of partner)
      if (red-v-line?) [ set two-lines? true ]
      set blue-v-line? true
    ][
      set partner one-of (turtles-at 0 -1) with [color-t = "blue"]
      if partner != nobody [
        set heading 0
        set score 1
        set in-v-line? true
        ask partner [
          set heading 0
          set score 1
          set in-v-line? true
        ]
        set xcor ([xcor] of partner)
        set ycor ([ycor + 1] of partner)
          if (red-v-line?) [ set two-lines? true ]
        set blue-v-line? true
      ]
    ]
    ][
      set partner one-of (turtles-at 0 1) with [color-t = "red"]
    ifelse partner != nobody [
      set heading 0
      set score 1
      set in-v-line? true
      ask partner [
        set heading 0
        set score 1
        set in-v-line? true
      ]
      set xcor ([xcor] of partner)
      set ycor ([ycor - 1] of partner)
      if (blue-v-line?) [ set two-lines? true ]
      set red-v-line? true
    ][
      set partner one-of (turtles-at 0 -1) with [color-t = "red"]
      if partner != nobody [
        set heading 0
        set score 1
        set in-v-line? true
        ask partner [
          set heading 0
          set score 1
          set in-v-line? true
        ]
        set xcor ([xcor] of partner)
        set ycor ([ycor + 1] of partner)
        if (blue-v-line?) [ set two-lines? true ]
        set red-v-line? true
      ]
    ]
    ]
    ]
end

to form-h-line ;;turtle procedure
    if (not two-lines?) [
    set heading (45 * random 8)
    ;;rt (random-float 90 - random-float 90)
    ifelse any? turtles-on patch-ahead 1
    [ ]
    [ fd 1 ]     ;;move around randomly

    ifelse (color-t = "blue")[
      set partner one-of (turtles-at -1 0) with [color-t = "blue"]
    ifelse partner != nobody [
      set score 1
      set heading 90
      set in-h-line? true
      ask partner [
        set heading 90
        set score 1
        set in-h-line? true
      ]
      set ycor ([ycor] of partner)
      set xcor ([xcor + 1] of partner)
        if (red-h-line?) [ set two-lines? true ]
      set blue-h-line? true
    ][
      set partner one-of (turtles-at 1 0) with [color-t = "blue"]
      if partner != nobody [
        set heading 90
        set score 1
        set in-h-line? true
        ask partner [
          set heading 90
          set score 1
          set in-h-line? true
        ]
        set ycor ([ycor] of partner)
        set xcor ([xcor - 1] of partner)
          if (red-h-line?) [ set two-lines? true ]
        set blue-h-line? true
      ]
  ]
    ][
    set partner one-of (turtles-at -1 0) with [color-t = "red"]
    ifelse partner != nobody [
      set score 1
      set heading 90
      set in-h-line? true
      ask partner [
        set heading 90
        set score 1
        set in-h-line? true
      ]
      set ycor ([ycor] of partner)
      set xcor ([xcor + 1] of partner)
        if (blue-h-line?) [ set two-lines? true ]
      set red-h-line? true
    ][
      set partner one-of (turtles-at 1 0) with [color-t = "red"]
      if partner != nobody [
        set heading 90
        set score 1
        set in-h-line? true
        ask partner [
          set heading 90
          set score 1
          set in-h-line? true
        ]
        set ycor ([ycor] of partner)
        set xcor ([xcor - 1] of partner)
          if (blue-h-line?) [ set two-lines? true ]
        set red-h-line? true
      ]
  ]
  ]]
end

;;;;;;;;;;;;;;;;;;;;;;;;;
;;;Plotting Procedures;;;
;;;;;;;;;;;;;;;;;;;;;;;;;

to get-scores
  set blue-score (calc-score-blue)
  set red-score (calc-score-red)
end

to-report calc-score-blue
  report (sum [ score ] of (turtles with [color-t = "blue"]))
end

to-report calc-score-red
  report (sum [ score ] of (turtles with [color-t = "red"]))
end
@#$#@#$#@
GRAPHICS-WINDOW
210
10
647
448
-1
-1
13.0
1
10
1
1
1
0
1
1
1
-16
16
-16
16
0
0
1
ticks
30.0

BUTTON
56
34
129
67
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
64
110
127
143
NIL
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

PLOT
712
115
1128
395
Scores
Iterations
Score
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Blue" 1.0 0 -13345367 true "" "plot blue-score"
"Red" 1.0 0 -2674135 true "" "plot red-score"

@#$#@#$#@
## TASK

There are 10 red turtles and 10 blue turtles in the 100x100 grid. Get the turtles to form either two vertical lines or two horizontal lines, where each line comprises of agents of the same colour while maintaining their autonomy.


## APPROACH

The turtles move around randomly (in one of the 8 possible directions). They make sure that they only take one step forward if there is no turtle in that position. The moving turtles have a score of 0.

We have five global flags to check if a horizantal or vertical line of a particular color exists (one flag for each kind of line) and one flag to know if two lines exist or no. As soon as a turtle finds another turtle (of the same colour) in its immediate left or right or top or bottom, it formes a horizontal or vertical line respectively with it and sets the flag of that particular line to be true. As soon as a turtle find its partner, both the turtle and partner stop moving and get a score of 1 each.

Without loss of generality, let's assume that the red horizontal line was formed first. Now the red turtles can only partner up with other red turtles on their left or right if the partner turtle is part of this horizontal line. Now, the blue turtles will only get a reward of 1 (each) if they form a horizontal line. The blue turtles can partner up with any other blue turtle that is seen in its immediate right or left. 

Once this happens, the two-lines flag is set true and the turtles can now only partner up with turtles with same colours that are already members of the lines. In this way, all turtles will try to maximize their individual payoffs by becoming member of a line and getting a higher payoff of 1 and hence, showing autonomous behavior.

The model proposed above works on the principle that every turtle has its maximum expected payoff as 1 and tries to maximize it. Initially, there emerges a turtle who partners up with another turtle of the same colour to form a line. Following this, the turtles adopt a strategy to move around randomly until they find a line of their color and subsequently, join the already formed line as it gives them their maximum expected payoff which is 1. As soon as the turtles get their maximum expected payoff, they stop moving. Also, we note here that whichever is the direction chosen by the turtle who initiated the formation of the line, all the turtles have to follow the direction specification.

## A REAL WORLD ANALOGY

The approach proposed above is analogous to the emergence of a school of thought, where the turtle who initiated the formation of the line can be mapped to the proposer of the school of thought. Here, the formation of another line of a different colour but of the same orientation can be mapped to the emergence of variation in the initially proposed school of thought and the initiater turtle of that line being the proposer of the variation. Subsequently, the turtles of similar colour joining the line of their colour can be mapped to followers of a school of thought coming together.
  

## UNDERSTANDING THE INTERFACE

Click on Setup button first to setup the environment. Once all the turtles are in random places with random directions, press the Go button. This is a forever button and will ensure that turtles are moving and forming lines.

The Score plot gives the variation of the total score of all the turtles of a particular color with respect to iterations (number of ticks). 

## THINGS TO NOTICE

It is important to note that as the length of line increases, so does the value of total scores in our plot. This is in agreement with each turtle trying to get a score of 1. Also, if the agents are allowed to run for sufficient number of ticks, we can see that the plot converges to the value of 10 meaning that each turtle has obtained the maximum score of 1 by being a member of a line of its colour.

## EXTENDING THE MODEL

We propose another model design for the above task. We assume the maximum expected payoff that a turtle can get at all times is, one more than the length of the current longest line of its own colour formed in the environment. In this way, the turtles forming smaller lines of the same colour have the incentive to join a rather longer line of its colour as it gives them a better payoff. This makes the smaller lines unstable and hence depicts chaotic behaviour which is in compliance with the models found in nature. When we allow the agents to run for sufficient number of ticks, we can imagine them forming only two lines, one of each colour.

## AUTHORS

Swasti Shreya Mishra (IMT2017043)
Aayush Grover (IMT2016005)
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

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

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
NetLogo 6.1.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
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
