//
// ViewModel.swift
// Mastermind!
//
// VIEW MODEL
//
// Created by Keaton Goebel on 1/22/24.
//
// Map Function to convert a String to a tuple https://www.hackingwithswift.com/example-code/language/how-to-use-map-to-transform-an-array
// April 7th

import Foundation
import SwiftUI

class ViewModel: ObservableObject{
    
    @Published var m = Model(numberOfButtonOptions: 6)
    @AppStorage("tempData") var playerNames: String = ""
    @AppStorage("backgroundMusicOn") var backgroundMusicOn: Bool = true
    @AppStorage("timerOn") var timerOn: Bool = false
    @AppStorage("timerDuration") var timerDuration: Double = 15
    @AppStorage("winSounds") var winSounds: Bool = true
    @AppStorage("alternateColors") var alternateColors: Bool = false
    @AppStorage("tappingSounds") var tappingSounds: Bool = true
    @AppStorage("remainingTime") var remainingTime: Double = 15
    
    
    // Adds player name to playerNames if it is not already in there
    func addPlayerName(playerName: String){
        if !playerNames.contains(playerName) {
            // the lowest score is set to a high number by default so that it can be reset to the lowest score
            playerNames += "( \(playerName), 0 , 100 ) "
        }
    }
    
    // incrementing the Win Count
    func incrementWinCount(playerName: String){
    
        if let playerNameRange = playerNames.range(of: playerName) {
            let playerNameEnd = playerNameRange.upperBound
            
            if let firstSeparator = playerNames[playerNameEnd...].firstIndex(of: ",") {
                if let secondSeparator = playerNames[firstSeparator...].dropFirst().firstIndex(of: ",") {
                    
                    let winCountStart = playerNames.index(after: firstSeparator)
                    let winCountEnd = playerNames.index(before: secondSeparator)
                    var winCountRange = String(playerNames[winCountStart..<winCountEnd])
                    if var count = Int(winCountRange.trimmingCharacters(in: .whitespaces)) {
                        count += 1
                        winCountRange = String(count)
                        playerNames.replaceSubrange(winCountStart..<winCountEnd, with: winCountRange)
                    }
                }
            }
        }
        
    }
    
    // Changing the High Score if it needs to be changed
    func newHighScore(playerName: String, newScore: Int){
        
        if let playerNameRange = playerNames.range(of: playerName) {
            let playerNameEnd = playerNameRange.upperBound
                
            if let firstSeparator = playerNames[playerNameEnd...].firstIndex(of: ",") {
                if let secondSeparator = playerNames[firstSeparator...].dropFirst().firstIndex(of: ",") {
                    if let tupleEnder = playerNames[secondSeparator...].dropFirst().firstIndex(of: ")"){
                            
                        let lowestScoreStart = playerNames.index(after: secondSeparator)
                        let lowestScoreEnd = playerNames.index(before: tupleEnder)
                
                        let lowestScoreRange = String(playerNames[lowestScoreStart..<lowestScoreEnd])
                        if let oldScore = Int(lowestScoreRange.trimmingCharacters(in: .whitespaces)) {
                            if  newScore + 1 < oldScore{
                                let newLowestScoreString = String(newScore + 1)
                                playerNames.replaceSubrange(lowestScoreStart..<lowestScoreEnd, with: newLowestScoreString)
                                }
                            }
                        }
                    }
            }
        }
    }
    
    // get all of the button options / keyboard key labels
    var buttonOptions: Array<ButtonOption> {
        return m.buttonOptions
    }
    
    // get all of the user guesses
    var userGuesses: Array<Guess>{
        return m.userGuesses
    }
    
    // choose choose a button from the model
    func chooseButton(buttonNumber: Int) {
        m.chooseButton(buttonNumber: buttonNumber)
    }
    
    // choose a row from the model
    func chooseRow(rowNumber: Int){
        m.chooseRow(rowNumber: rowNumber)
    }
    
    // swaps row numbers, swaps 0 for 5 and 5 for 0 
    func reverseRow(oldRow: Int) -> Int {
        return MAX_GUESSES - 1 - oldRow
    }
    
    // chooose a button in a guess row
    func setGuessButton(rowe: Int, col: Int) {
        m.setGuessButton(row: m.reverseRow(oldRow: rowe), column: col)
    }
    
    // checking if the row is full
    func rowIsFull(_ thisRow: Int) -> Bool {
        
        // if a loser has been found, short-circuit and end the game
        if getLoser() {
            return false
        }
        else {
            return m.rowIsFull(row: thisRow)
        }
    }
    
    // calls nextRow to move to next row in the model
    func nextRow() {
         //   print("ViewModel: Moving to the next row")
            m.nextRow()
    }
    
    // function to change the color of the secret code beads saved in the model given a bead index and a color index 
    func changeBeadColor(IndexOfBead: Int, IndexOfNewColor: Int){
        if IndexOfBead == 1 {
            for i in 0..<BUTTON_OPTIONS_NAMES.count {
                if i == IndexOfNewColor {
                    m.b1 = BUTTON_OPTIONS_NAMES[i]
                    m.secretCodeIndex1 = i
                }
            }
        }
        if IndexOfBead == 2 {
            for i in 0..<BUTTON_OPTIONS_NAMES.count {
                if i == IndexOfNewColor {
                    m.b2 = BUTTON_OPTIONS_NAMES[i]
                    m.secretCodeIndex2 = i
                }
            }
        }
        
        if IndexOfBead == 3 {
            for i in 0..<BUTTON_OPTIONS_NAMES.count {
                if i == IndexOfNewColor {
                    m.b3 = BUTTON_OPTIONS_NAMES[i]
                    m.secretCodeIndex3 = i
                }
            }
        }
        
        if IndexOfBead == 4 {
            for i in 0..<BUTTON_OPTIONS_NAMES.count {
                if i == IndexOfNewColor {
                    m.b4 = BUTTON_OPTIONS_NAMES[i]
                    m.secretCodeIndex4 = i
                }
            }
        }
        m.fullCode = [m.b1,m.b2,m.b3,m.b4]
    }
    
    // saving the number of white and red beads from the model
    func countRedBeads() -> Int {
        return m.countRedBeads()
    }
    
    func countWhiteBeads() -> Int {
        return m.countWhiteBeads()
    }
    
    // retrieve the current row number from the model
    var currentRowNumber: Int {
        return m.currentRowNumber
    }
    
    // seeing if we have a winner based on the red bead count in the model
    func getWinner() -> Bool {
        return m.declareWinner(redBeadCount: m.redCountList[m.currentRowNumber])
    }
    
    // seeing if we have a loser based on the currentRowNumber in the model
    func getLoser() -> Bool {
        return m.declareLoser(row: m.currentRowNumber)
    }
    
    // translating the secret code from an array of strings representing colors back to an array of colors
    var secretCode: [Color] {
        let codeString = [m.b1,m.b2,m.b3,m.b4]
        var secretColors: [Color] = [.white, .white, .white, .white]
        for i in 0..<codeString.count {
            for j in 0..<BUTTON_OPTIONS_NAMES.count {
                if codeString[i] == BUTTON_OPTIONS_NAMES[j] {
                    secretColors[i] = BUTTON_OPTIONS[j]
                }
            }
        }
        return secretColors
    }
    
    // starting a new game
    func startNewGameSinglePlayer() {
       // print("VIEW MODEL: starting a new Game one player")
        m = Model(numberOfButtonOptions: BUTTON_OPTIONS.count)
    }
    
    func startNewGameTwoPlayer(savedPlayer1Name: String, savedPlayer2Name: String, savedPlayer1Score: Int, savedPlayer2Score: Int, resetCode: Bool) {
        
        var newB1 = 0
        var newB2 = 0
        var newB3 = 0
        var newB4 = 0
        
        if resetCode{
            newB1 = m.secretCodeIndex1
            newB2 = m.secretCodeIndex2
            newB3 = m.secretCodeIndex3
            newB4 = m.secretCodeIndex4
        }
        
        m = Model(numberOfButtonOptions: BUTTON_OPTIONS.count)
        if !savedPlayer1Name.isEmpty{
            m.player1Name = savedPlayer1Name
        }
        if !savedPlayer2Name.isEmpty{
            m.player2Name = savedPlayer2Name
        }
        
        m.player1Score = savedPlayer1Score
        m.player2Score = savedPlayer2Score
        
        if resetCode {
            changeBeadColor(IndexOfBead: 1, IndexOfNewColor: newB1)
            changeBeadColor(IndexOfBead: 2, IndexOfNewColor: newB2)
            changeBeadColor(IndexOfBead: 3, IndexOfNewColor: newB3)
            changeBeadColor(IndexOfBead: 4, IndexOfNewColor: newB4)
        }
    }
    
    func getPlayer1Name() -> String {
        return m.player1Name
    }
    
    func changePlayer1Name(PlayerName: String) {
        m.player1Name = PlayerName
    }
    
    func getPlayer2Name() -> String {
        return m.player2Name
    }

    func changePlayer2Name(PlayerName: String) {
        m.player2Name = PlayerName
    }
    
    func setGuessSecretCode(row: Int) {
        m.setGuessSecretCode(row: row)
    }
    
    func getPlayer1Score() -> Int {
        return m.player1Score
    }
    
    func getPlayer2Score() -> Int {
        return m.player2Score
    }
    
    func changePlayer1Score(score: Int) {
        m.player1Score = score
    }

    func changePlayer2Score(score: Int) {
        m.player2Score = score
    }
    
    func getShowPlayer1Name() -> Bool {
        return m.showPlayer1Name
    }
    
    func getBackgroundColor(alternateColor: Bool) -> Color {
        
        if alternateColor == false {
            return BACKGROUND_COLOR
        }
        else {
            return BACKGROUND_COLOR2
        }
    }
    
    func getSideButtonColor(alternateColor: Bool) -> Color {
        
        if alternateColor == false {
            return SIDE_BUTTON_COLOR
        }
        else {
            return SIDE_BUTTON_COLOR2
        }
    }
    
    func getOverviewColor(alternateColor: Bool) -> Color {
        
        if alternateColor == false {
            return OVERVIEW_COLOR
        }
        else {
            return OVERVIEW_COLOR2
        }
    }
    
    // is true or false if the timer is halfway done
    var isThird: Bool {
        return remainingTime <= timerDuration / 3
    }
    
    // returns true if the game is over and the player has won or lose
    var selectionOn: Bool {
        if getLoser()  == false && getWinner() == false && remainingTime != 0 {
            return true
        }
        else {
            return false
        }
    }
    
    // subtracts 1 from remaining time every second, if remaining is 0, ends
    func startTimer() {
        
        m.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            print("TEST1", self.timerDuration)
            print("TEST2", self.remainingTime)
            print(self.isThird)
            if self.remainingTime > 0 {
                self.remainingTime -= 1
            } else {
                timer.invalidate()
            }
        }
    }
    
    func restartTimer() {
        remainingTime = timerDuration
    }
    
    func stopTimer() {
        m.timer.invalidate()
    }
}
