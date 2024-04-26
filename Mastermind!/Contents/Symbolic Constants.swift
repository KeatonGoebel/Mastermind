//
// Symbolic Constants.swift
// Mastermind!
//
// Created by Keaton Goebel on 1/24/24.
//
//
import SwiftUI

// enter key and feedback bead size and color
let CORNER_RADIUS = 25.0
let BUTTON_OPTION_SIZE = 60.0
let SIDE_BUTTON_COLOR = Color.blue
let SIDE_BUTTON_COLOR2 = Color.teal
// possible colors for the guess beads, the color order is the same so indexing can be matched up
// changed .red to soft_red to match the enter key button
let BUTTON_OPTIONS: [Color] = [SOFT_RED, .orange, .yellow, .green, .cyan, .purple]
let BUTTON_OPTIONS_NAMES: [String] = ["Red", "Orange", "Yellow", "Green", "Blue", "Purple"]

// number of buttons in a row, this represents one guess at the code
let BUTTON_GUESS_COUNT = 4

// number of guesses of the secret code the user gets 
let MAX_GUESSES = 6

// MIN_ROW is -1 because the user can guess on row 0 then the model checks if they are on row MIN_ROW
let MAX_ROW = 5
let MIN_ROW = -1

// debuging mode, allows for manual selection of the beads 
let TEST_MODE = false

// additional colors
let BACKGROUND_COLOR = Color.teal
let BACKGROUND_COLOR2 = DARK_BLUE
let SOFT_RED = Color(red: 0.86, green: 0.07, blue: 0.23)
let OFF_BLACK = Color(red: 0.15, green: 0.15, blue: 0.15)
let OFF_WHITE = Color(red: 0.85, green: 0.85, blue: 0.85)
let OVERVIEW_COLOR = Color.blue
let OVERVIEW_COLOR2 = Color.teal
let OVERVIEW_STROKE = Color.black
let DARK_BLUE = Color(red:0, green: 0, blue: 1)

// feedback bead sizes
let BEAD_WIDTH : CGFloat = 15
let BEAD_HEIGHT : CGFloat = 8

// Home button on the single and two player screen sizes
let HOME_BUTTON_WIDTH : CGFloat = 70
let MAIN_GAME_BUTTON_HEIGHT : CGFloat = 50

// Next Game button on the single and two player screen sizes
let NEXT_GAME_BUTTON_WIDTH : CGFloat = 120

// Next Game button on the single and two player screen sizes
let GAME_STATS_GAME_BUTTON_WIDTH : CGFloat = 150

// Home buttons on the home button page screen sizes
let HOME_BUTTONS_WIDTH : CGFloat = 320
let HOME_BUTTONS_HEIGHT : CGFloat = 80
let HOME_BUTTONS_TEXT_SIZE : CGFloat = 40
let HOME_BUTTONS_SIZE : CGFloat = 60
let HOME_BUTTON_ON_X_SPEAKER_OFFSET : CGFloat = 85
let HOME_BUTTON_OFF_X_SPEAKER_OFFSET : CGFloat = 66
let HOME_BUTTON_Y_SPEAKER_OFFSET : CGFloat = 150
let HOME_BUTTON_Y_OFFSET : CGFloat = 100
let HOME_BUTTON_TOGGLE_OFFSET : CGFloat = -110 // -40
let HOME_BUTTON_TOGGLE_TEXT_SIZE : CGFloat = 17
let HOME_BUTTON_ON_TOGGLE_SPEAKER_OFFSET : CGFloat = 30
let TOGGLE_SPACING: CGFloat = 20
let TIMER_OFFSET : CGFloat = -30
let TOGGLE_X_OFFSET : CGFloat = -55

// Two player overlay window sizes
let TWO_PLAYER_OVERLAY_WINDOW_WIDTH : CGFloat = 280
let TWO_PLAYER_OVERLAY_WINDOW_HEIGHT : CGFloat = 300
let TEXT_BOX_WIDTH : CGFloat = 250
let CODE_CIRCLE_WIDTH : CGFloat = 55
let CODE_CIRCLE_HEIGHT : CGFloat = 55
let HOME_BUTTON_OFFSET : CGFloat = -38
let RESET_BUTTON_OFFSET : CGFloat = 38

let TWO_PLAYER_WIN_OR_LOSE_WIDTH : CGFloat = 300
let TWO_PLAYER_WIN_OR_LOSE_HEIGHT : CGFloat = 200

let WIN_OR_LOSE_FONT_SIZE : CGFloat = 30

// default values for full reset from the homescreen
let DEFAULT_PLAYER1_NAME : String = "Player 1"
let DEFAULT_PLAYER2_NAME : String = "Player 2"
let DEFAULT_PLAYER_SCORE : Int = -1

// confetting configuration
let CONFETTI_NUM : Int = 100
let CONFETTI_RAIN_HEIGHT : CGFloat = 800
let CONFETTI_RAIN_OPENING_ANGLE : Double = 50
let CONFETTI_RAIN_CLOSING_ANGLE : Double = 130

// Game Stats constants
let GAMESTATS_Y_OFFSET : CGFloat = -100
let COLUMN_Y_OFFSET : CGFloat = -30
let GAMESTATS_HOME_X_OFFSET : CGFloat = 170
let COLUMN_SPACING : CGFloat = 20
let HOME_STATS_BUTTONS_WIDTH : CGFloat = 200
let HOME_STATS_BUTTONS_HEIGHT : CGFloat = 60
let HOME_STATS_BUTTONS_TEXT_SIZE : CGFloat = 40
let RESET_STATS_BUTTONS_TEXT_SIZE : CGFloat = 25
let GAME_STATS_TEXT_SIZE : CGFloat = 50
let COLUMN_X_OFFSET : CGFloat = -175
let USERNAME_OFFSET : CGFloat = 100
let WIN_OFFSET : CGFloat = 100
let HIGHSCORE_OFFSET : CGFloat = 200
let COLUMN_TEXT_SIZE : CGFloat = 15
let COLUMN_DATA_TEXT_SIZE : CGFloat = 20

let SETTINGS_TEXT_OFFSET : CGFloat = 30
let SETTINGS_TOGGLE_OFFSET : CGFloat = -30
