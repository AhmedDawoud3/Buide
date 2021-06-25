-- Libiraries

-- https://github.com/Ulydev/push
push = require 'lib/push'

-- the "Class" library we're using will allow us to represent anything in
-- our game as code, rather than keeping track of many disparate variables and
-- methods
-- https://github.com/vrld/hump/blob/master/class.lua
Class = require 'lib/class'

-- Vector Libirary Will Enable us to use 2d vectors
Vector = require 'lib/vector'

-- Suit Libirary (UI)
Suit = require 'lib/suit'

-- Constants (eg. Window Width and Height)
require 'src/CONSTANTS'

-- State Machine Will Handle Changes in States
require 'src/StateMachine'

require 'src/EffectManager'

require 'src/MouseHandler'

-- State
require 'src/States/BaseState'
require 'src/States/PlayState'
require 'src/States/StartState'
require 'src/States/AboutState'