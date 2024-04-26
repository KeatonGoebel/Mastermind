//
//  TwoPlayerView.swift
//  Mastermind!
//
//  Created by Keaton Goebel on 3/21/24.
//

import Foundation
import ConfettiSwiftUI
import SwiftUI

struct TwoPlayerView: View {
    @ObservedObject var vm: ViewModel
    @Binding var gameState: ContentView.GameState
    @State var showPlayer1Name = true
    @State var player1Name: String
    @State var showPlayer2Name = false
    @State var player2Name: String
    @State var showPlayer1Code = false
    @State var showPlayer2Code = false
    @State var firstCodeSet = false
    @State var selectedColor = -1
    @State var goToGameTwo = false
    @State var seeGuesses = false
    @State var confettiCounter: Int = 0
    
    func playWinSound() {
        
        AudioManager.shared.playSoundEffect(soundName: "win_sound")
        
    }
    
    func playLoseSound() {
        
        AudioManager.shared.playSoundEffect(soundName: "lose_sound")
        
    }
    
    var body: some View {
        
        ZStack{
        
            // Background color
            Rectangle()
                .fill(vm.getBackgroundColor(alternateColor: vm.alternateColors))
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                // Home Button, Player names, and Reset button
                HStack {
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: CORNER_RADIUS)
                            .stroke(Color.black,lineWidth: 8)
                            .fill(vm.getSideButtonColor(alternateColor: vm.alternateColors))
                            .frame(width: HOME_BUTTON_WIDTH, height: MAIN_GAME_BUTTON_HEIGHT)
                            .padding(8)
                        Text("Home")
                            .font(.system(size: 15, design: .rounded).bold())
                            .foregroundStyle(vm.alternateColors ? OFF_WHITE : OFF_BLACK)
                            .onTapGesture {
                                print("Going back to the home screen")
                                vm.stopTimer()
                                vm.restartTimer()
                                gameState = .homeScreen
                            }
                    }
                    
                    if seeGuesses {
                        ZStack{
                            RoundedRectangle(cornerRadius: CORNER_RADIUS)
                                .stroke(Color.black,lineWidth: 8)
                                .fill(vm.getSideButtonColor(alternateColor: vm.alternateColors))
                                .frame(width: NEXT_GAME_BUTTON_WIDTH, height: MAIN_GAME_BUTTON_HEIGHT)
                                .padding(8)
                            Text("Next Game? ")
                                .font(.system(size: 15, design: .rounded).bold())
                                .onTapGesture {
                                    print(vm.currentRowNumber)
                                    print(vm.reverseRow(oldRow: vm.currentRowNumber))
                                    vm.startNewGameTwoPlayer(savedPlayer1Name: player1Name, savedPlayer2Name: player2Name, savedPlayer1Score: vm.getPlayer1Score(), savedPlayer2Score: vm.getPlayer2Score(), resetCode: firstCodeSet)
                                    goToGameTwo = true
                                }
                        }
                    }
                    
                    // players start out with a score of one because they start out already on the first row
                    else if vm.getPlayer2Score() == -1{
                        Text("\(vm.getPlayer1Name()): 1 \n\(vm.getPlayer2Name()): 1")
                            .font(.system(size: 20, design: .rounded).bold())
                            .foregroundStyle(vm.alternateColors ? OFF_WHITE : OFF_BLACK)
                            .offset(x: 0)
                    }
                    else {
                        // when the player score increases it becomes a dynamic variable
                        Text("\(vm.getPlayer1Name()): 1 \n\(vm.getPlayer2Name()): \(vm.getPlayer2Score() + 1)")
                            .font(.system(size: 20, design: .rounded).bold())
                            .foregroundStyle(vm.alternateColors ? OFF_WHITE : OFF_BLACK)
                            .offset(x: 0)
                    }
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: CORNER_RADIUS)
                            .stroke(Color.black,lineWidth: 8)
                            .fill(vm.getSideButtonColor(alternateColor: vm.alternateColors))
                            .frame(width: HOME_BUTTON_WIDTH, height: MAIN_GAME_BUTTON_HEIGHT)
                            .padding(8)
                        Text("Reset")
                            .font(.system(size: 15, design: .rounded).bold())
                            .foregroundStyle(vm.alternateColors ? OFF_WHITE : OFF_BLACK)
                            .onTapGesture {
                                
                                // the reset button causes a partial reset, it resets the beads of the game but saves the player names, it saves player scores in between games, and it saves the inputted code. If a winner or loser has been declared, then the reset button does nothing because the game is already over
                                if vm.getLoser() == false && vm.getWinner() == false && vm.remainingTime != 0{
                                    print("VIEW: Starting a new game")
                                    vm.stopTimer()
                                    vm.restartTimer()
                                    vm.startNewGameTwoPlayer(savedPlayer1Name: player1Name, savedPlayer2Name: player2Name, savedPlayer1Score: 1, savedPlayer2Score: 1, resetCode: firstCodeSet)
                                    vm.changePlayer2Score(score: -1)
                                    showPlayer1Name = true
                                    showPlayer2Name = false
                                    showPlayer1Code = false
                                    showPlayer2Code = false
                                }
                                seeGuesses = false
                            }
                    }
                    
                }
                
                if vm.timerOn {
                    TimerView(vmLocal: vm)
                }
                
                // rows of user guesses
                ForEach(vm.userGuesses){ guessNumber in
                    
                    ButtonGuessRow(row: guessNumber.id, vmLocal: vm, twoPlayer: Binding.constant(true), alternateColors: $vm.alternateColors, showPlayerOneName: $showPlayer1Name, showPlayerTwoName: $showPlayer2Name, showPlayerOneCode: $showPlayer1Code, showPlayerTwoCode: Binding.constant(false), onGameTwo: Binding.constant(false))
                        .onTapGesture {
                            
                            if !showPlayer1Code {
                                vm.chooseRow(rowNumber: guessNumber.id)
                            }
                            
                        }
                }
                
                // if we have a loser, prints out Secret code
                if vm.getLoser() || vm.remainingTime == 0{
                    Text("Secret Code")
                        .font(.system(size: 20).bold())
                        .foregroundStyle(vm.alternateColors ? OFF_WHITE : OFF_BLACK)
                    
                }
                else{
                    Text("Choose a color:")
                        .font(.system(size: 20))
                        .foregroundStyle(vm.alternateColors ? OFF_WHITE : OFF_BLACK)
                }
                
                // the view of the button color options, if we have a loser, then it prints out the secret code
                if vm.getLoser() || vm.remainingTime == 0{
                    HStack {
                        ForEach(vm.secretCode, id: \.self) { codeColor in
                            Circle()
                                .fill(codeColor)
                                .stroke(Color.black, lineWidth: 8)
                                .padding(3)
                        }
                    }
                }
                else {
                    HStack {
                        ForEach(vm.buttonOptions) { thisButton in
                            ContentView.ButtonOptionView(buttonId: thisButton.id, isSelected: thisButton.isSelected, alternateColors: $vm.alternateColors)
                                .onTapGesture(perform: {
                                    // chosing a button
                                    if !showPlayer1Name && !showPlayer2Name{
                                        vm.chooseButton(buttonNumber: thisButton.id)
                                        selectedColor = thisButton.id
                                        
                                        if vm.tappingSounds {
                                            let audiomanagerLocal = AudioManager()
                                            audiomanagerLocal.playBeadPress()
                                        }
                                        
                                    }
                                })
                        }
                    }
                }
            }
            .padding()
            
            // transitioning between different views depending on conditional statements and boolean flags
            if showPlayer1Name {
                Player1NameView(player1Name: $player1Name, showPlayer1NameView: $showPlayer1Name, showPlayer2NameView: $showPlayer2Name, vmLocal: vm)
            }
            if showPlayer2Name {
                Player2NameView(player2Name: $player2Name, showPlayer2NameView: $showPlayer2Name,  showPlayer1CodeView: $showPlayer1Code, firstCodeSet: $firstCodeSet, vmLocal: vm)
            }
            if showPlayer1Code {
                Player1CodeView(player1Name: $player1Name, player2Name: $player2Name, showPlayer1CodeView: $showPlayer1Code, showPlayer2CodeView: $showPlayer2Code, firstCodeSet: $firstCodeSet, selectedColor: $selectedColor, vmLocal: vm)
            }
            
            // we have two cases, you win or you lose. You lose case must be first in the code to short-circuit program
            if (vm.getLoser() || vm.remainingTime == 0) && seeGuesses == false{
                
                ZStack{
                    RoundedRectangle(cornerRadius: CORNER_RADIUS)
                        .stroke(.black,lineWidth: 15)
                        .fill(.black)
                        .frame(width: TWO_PLAYER_WIN_OR_LOSE_WIDTH, height: TWO_PLAYER_WIN_OR_LOSE_HEIGHT)
                        .onTapGesture {
                            if vm.winSounds{
                                playLoseSound()
                            }
                        }
                    VStack{
                        Text(" YOU LOSE! ")
                             .bold()
                             .foregroundStyle(.white)
                             .background(Color.black)
                             .font(.system(size: WIN_OR_LOSE_FONT_SIZE))
                             .onTapGesture {
                                 if vm.winSounds{
                                     playLoseSound()
                                 }
                             }
                        
                        // next game button takes us to the second game
                        Text("Next Game?")
                            .foregroundStyle(.white)
                            .onTapGesture{
                                print(vm.currentRowNumber)
                                print(vm.reverseRow(oldRow: vm.currentRowNumber))
                                vm.startNewGameTwoPlayer(savedPlayer1Name: player1Name, savedPlayer2Name: player2Name, savedPlayer1Score: vm.getPlayer1Score(), savedPlayer2Score: vm.getPlayer2Score(), resetCode: firstCodeSet)
                                vm.stopTimer()
                                vm.restartTimer()
                                goToGameTwo = true
                            }
                            
                        Text(" See Guesses? ")
                            .foregroundStyle(.white)
                            .onTapGesture {
                                seeGuesses = true
                            }
                        
                    }
                    .onAppear{
                        if vm.winSounds{
                            playLoseSound()
                        }
                        
                        if vm.remainingTime == 0{
                            vm.changePlayer2Score(score: 6)
                        }
                        vm.stopTimer()
                        
                    }
                }
            }
            
            else if seeGuesses == false && vm.getWinner(){
                ZStack{
                    RoundedRectangle(cornerRadius: CORNER_RADIUS)
                        .stroke(.black,lineWidth: 15)
                        .fill(.black)
                        .frame(width: TWO_PLAYER_WIN_OR_LOSE_WIDTH, height: TWO_PLAYER_WIN_OR_LOSE_HEIGHT)
                        .onTapGesture {
                            print("Attempting Win Animation")
                            confettiCounter += 1
                            if vm.winSounds{
                                playWinSound()
                            }
                        }
                    VStack(spacing: 20){
                        Text(" YOU WIN! ")
                             .bold()
                             .foregroundStyle(.white)
                             .background(Color.black)
                             .font(.system(size: WIN_OR_LOSE_FONT_SIZE))
                             .onTapGesture {
                                 print("Attempting Win Animation")
                                 confettiCounter += 1
                                 if vm.winSounds{
                                     playWinSound()
                                 }
                             }
                        
                        // next game button takes us to the second game
                        Text("Next Game?")
                            .foregroundStyle(.white)
                            .onTapGesture{
                                print(vm.currentRowNumber)
                                print(vm.reverseRow(oldRow: vm.currentRowNumber))
                                vm.startNewGameTwoPlayer(savedPlayer1Name: player1Name, savedPlayer2Name: player2Name, savedPlayer1Score: vm.getPlayer1Score(), savedPlayer2Score: vm.getPlayer2Score(), resetCode: firstCodeSet)
                                
                                // making a new code upon going to game two
                                vm.changeBeadColor(IndexOfBead: 1, IndexOfNewColor: Int.random(in: 0..<BUTTON_OPTIONS.count))
                                vm.changeBeadColor(IndexOfBead: 2, IndexOfNewColor: Int.random(in: 0..<BUTTON_OPTIONS.count))
                                vm.changeBeadColor(IndexOfBead: 3, IndexOfNewColor: Int.random(in: 0..<BUTTON_OPTIONS.count))
                                vm.changeBeadColor(IndexOfBead: 4, IndexOfNewColor: Int.random(in: 0..<BUTTON_OPTIONS.count))
                                
                                vm.stopTimer()
                                vm.restartTimer()
                                goToGameTwo = true
                            }
                        Text(" See Guesses? ")
                            .foregroundStyle(.white)
                            .onTapGesture {
                                seeGuesses = true
                            }
                        
                    }
                    .onAppear{
                        if goToGameTwo == false {
                            confettiCounter += 1
                            if vm.winSounds{
                                playWinSound()
                            }
                        }
                        vm.stopTimer()
                    }
                }
                .confettiCannon(counter: $confettiCounter, num: CONFETTI_NUM, rainHeight: CONFETTI_RAIN_HEIGHT, openingAngle: Angle.degrees(CONFETTI_RAIN_OPENING_ANGLE), closingAngle: Angle.degrees(CONFETTI_RAIN_CLOSING_ANGLE))
            }
           
            if goToGameTwo {
                TwoPlayerGameTwoView(vm: vm, gameState: $gameState, player1Name: player1Name, player2Name: player2Name)
            }
        }
    }
}

