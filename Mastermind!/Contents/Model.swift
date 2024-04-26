//
// Model.swift
// Mastermind!
//
// MODEl
//
// Created by Keaton Goebel on 1/22/24.
//
//
import Foundation
import SwiftUI

struct Model {
    var buttonOptions: Array<ButtonOption>
    var currentButton: Int?
    var currentRowNumber: Int = MAX_ROW
    var code = Guess(id:-1)
    var secretCodeIndex1: Int
    var b1: String
    var secretCodeIndex2: Int
    var b2: String
    var secretCodeIndex3: Int
    var b3: String
    var secretCodeIndex4: Int
    var b4: String
    var fullCode = [String?]()
    var redCountList: [Int]
    var whiteCountList: [Int]
    var player1Name: String
    var player2Name: String
    var player1Score: Int
    var player2Score: Int
    var showPlayer1Name: Bool
    var timer: Timer
    
    // array of all user guesses
    var userGuesses: Array<Guess>
    
    init(numberOfButtonOptions: Int) {
        
        buttonOptions = Array<ButtonOption>()
        for buttonIndex in 0..<numberOfButtonOptions {
            buttonOptions.append(ButtonOption(id: buttonIndex, isSelected: false))
        }
        
        // initalize the set of all user guesses
        userGuesses = Array<Guess>()
        for i in 0..<MAX_GUESSES {
            userGuesses.append(Guess(id: i))
        }
        
        // Initialize the secret code the user will try to guess
        self.secretCodeIndex1 = Int.random(in: 0..<BUTTON_OPTIONS.count)
        self.b1 = BUTTON_OPTIONS_NAMES[secretCodeIndex1]
        self.secretCodeIndex2 = Int.random(in: 0..<BUTTON_OPTIONS.count)
        self.b2 = BUTTON_OPTIONS_NAMES[secretCodeIndex2]
        self.secretCodeIndex3 = Int.random(in: 0..<BUTTON_OPTIONS.count)
        self.b3 = BUTTON_OPTIONS_NAMES[secretCodeIndex3]
        self.secretCodeIndex4 = Int.random(in: 0..<BUTTON_OPTIONS.count)
        self.b4 = BUTTON_OPTIONS_NAMES[secretCodeIndex4]
        
        self.fullCode = [b1,b2,b3,b4]
        
        self.redCountList = [0,0,0,0,0,0]
        self.whiteCountList = [0,0,0,0,0,0]
        
        self.showPlayer1Name = true
        self.player1Name = "Player 1"
        self.player2Name = "Player 2"
        self.player1Score = -1
        self.player2Score = -1
        self.timer = Timer()
        
        print("Model: The secret code is \(b1) \(b2) \(b3) \(b4)")
    }
    
    // allowing the user to choose an individual button
    mutating func chooseButton(buttonNumber: Int) {
        if let oldButton = currentButton {
            buttonOptions[oldButton].isSelected = false
        }
        buttonOptions[buttonNumber].isSelected = true
        currentButton = buttonNumber
    }
    
    // returning if a row is full
    func rowIsFull(row: Int) -> Bool {

        if row < MAX_GUESSES{
            return userGuesses[row].isFull
        }
        return false
    }
    
    // moving to the next guess row
    mutating func nextRow(){
        
        if userGuesses[currentRowNumber].isFull && currentRowNumber < MAX_GUESSES {
            
            // check if the row of guesses causes or a win or loss before incrementing the row
            if declareLoser(row: currentRowNumber) {
            }
            else if declareWinner(redBeadCount: redCountList[currentRowNumber]) {
            }
            else {
                currentRowNumber = currentRowNumber - 1
                print("MODEL: current row is now \(reverseRow(oldRow: currentRowNumber))")
            }
        }
        else{
            print("MODEL: can't change current row --- at max or row isn't full")
        }
    }
    
    // changing current row number based on rowNumber
    mutating func chooseRow(rowNumber: Int){
        currentRowNumber = rowNumber
    }
    
    // swaps row numbers, swaps 0 for 5 and 5 for 0
    func reverseRow(oldRow: Int) -> Int {
        return MAX_GUESSES - 1 - oldRow
    }
    
    // set a button in a users guess
    mutating func setGuessButton(row: Int, column: Int) {
        
        // checking if the player has not won or if they have not lost, then they are currently playing
        if !declareWinner(redBeadCount: redCountList[currentRowNumber]) && !declareLoser(row: currentRowNumber) {
            if row == currentRowNumber {
                userGuesses[row].guessItem[column] = currentButton
            }
            else {
                print("MODEL: yikes! wrong row! can't set Button!")
            }
        }
    }
    
    // converting the userGuesses, an array of optionals, to an array of color strings with the same index as button option names
    func unWrapGuess() -> [String] {
        let userGuesses = userGuesses
        var guess = userGuesses[5]
        
        for i in 0..<userGuesses.count {
            if userGuesses[i].guessItem[0] != nil {
                guess = userGuesses[i]
                break
            }
        }
        
        var userGuessColors: [String] = []
        for beadIndex in guess.guessItem {
            if let index = beadIndex {
                userGuessColors.append(BUTTON_OPTIONS_NAMES[index])
            }
        }
        return userGuessColors
    }
    
    // calling unWrapGuess and then calculating the number of red and white beads and returning them in an array of ints
    func countBeads() -> Array<Int> {
        let userGuessColors = unWrapGuess()
        var whiteBeadCount: Int = 0
        var redBeadCount: Int = 0
        var redBeads = [false,false,false,false]
        var whiteBeads = [false,false,false,false]
        
        // a bead is red if is the right color in the right place
        for i in 0..<fullCode.count {
            if userGuessColors[i] == fullCode[i] {
                redBeadCount += 1
                redBeads[i] = true
            }
        }
        
        for i in 0..<userGuessColors.count {
            for j in 0..<fullCode.count {
                // a bead is white if its color is present in the code but not in the same position
                if userGuessColors[i] == fullCode[j] && redBeads[i] == false && redBeads[j] == false && whiteBeads[j] == false{
                    whiteBeadCount += 1
                    whiteBeads[j] = true
                    break
                }
            }
        }
        let allBeads = [redBeadCount, whiteBeadCount]
        return allBeads
    }
    
    // Dividing up the results of count Beads into red and white bead counts
    func countRedBeads() -> Int {
        let allBeads = countBeads()
        if allBeads == [0]{
            return 0
        }
        return allBeads[0]
    }
    
    func countWhiteBeads() -> Int {
        let allBeads = countBeads()
        if allBeads == [0]{
            return 0
        }
        return allBeads[1]
    }
    
    func declareWinner(redBeadCount: Int) -> Bool {
        if redBeadCount == BUTTON_GUESS_COUNT{
            print("MODEL: YOU WON!!!")
            return true
        }
        return false
    }
    
    func declareLoser(row: Int) -> Bool {
        if row == MIN_ROW{
            print("MODEL: YOU LOSE!!!")
            return true
        }
        return false
    }
    
    mutating func setGuessSecretCode(row: Int){
    }
    
}

struct ButtonOption: Identifiable{
    // id is the index number in the array of button options
    var id: Int
    
    // has this bead been selected by the user
    var isSelected: Bool
}
    
// three colors, representing a user's guess of the secret code 
struct Guess: Identifiable{
    var id: Int
    
    // array of Optionals to hold user guesses, will be nil if they haven't guessed yet
    var guessItem:[Int?] = Array(repeating: nil, count: BUTTON_GUESS_COUNT)
    
    var isFull: Bool {
        for i in 0..<BUTTON_GUESS_COUNT{
            if guessItem[i] == nil{
                return false
            }
        }
        return true
    }
    
}


