//
//  TwoPlayerGameTwoView.swift
//  Mastermind!
//
//  Created by Keaton Goebel on 3/26/24.
//

import ConfettiSwiftUI
import SwiftUI

struct TwoPlayerGameTwoView: View {
    @ObservedObject var vm: ViewModel
    @Binding var gameState: ContentView.GameState
    @State var player1Name: String
    @State var player2Name: String
    @State var showPlayer2Code = true
    @State var secondCodeSet = false
    @State var selectedColor = -1
    @State var seeGuesses: Bool = false
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
                
                // Home Button, Mastermind text, and Reset button
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
                                .frame(width: GAME_STATS_GAME_BUTTON_WIDTH, height: MAIN_GAME_BUTTON_HEIGHT)
                                .padding(8)
                            Text(" See Game Statistics ")
                                .font(.system(size: 15, design: .rounded).bold())
                                .onTapGesture {
                                    gameState = .endScreen
                                }
                        }
                    }
                    
                    else if vm.getPlayer1Score() == -1{
                        
                        // player 1 gets score from first game and player 1 starts out with score of one as they are on the first row
                        Text("\(vm.getPlayer1Name()): 1 \n\(vm.getPlayer2Name()): \(vm.getPlayer2Score() + 1)")
                            .font(.system(size: 20, design: .rounded).bold())
                            .foregroundStyle(vm.alternateColors ? OFF_WHITE : OFF_BLACK)
                    }
                    else {
                        // when player 2 score increases both variables are now dynamic
                        Text("\(vm.getPlayer1Name()): \(vm.getPlayer1Score() + 1) \n\(vm.getPlayer2Name()): \(vm.getPlayer2Score() + 1)")
                            .font(.system(size: 20, design: .rounded).bold())
                            .foregroundStyle(vm.alternateColors ? OFF_WHITE : OFF_BLACK)
                    }
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: CORNER_RADIUS)
                            .stroke(Color.black,lineWidth: 8)
                            .fill(vm.getSideButtonColor(alternateColor: vm.alternateColors))
                            .frame(width: HOME_BUTTON_WIDTH, height: MAIN_GAME_BUTTON_HEIGHT)
                            .padding(8)
                        
                        // the reset button causes a partial reset, it resets the beads of the game but saves the player names, it saves player scores, and it saves the inputted code. If a winner or loser has been declared, then the reset button does nothing because the game is already over
                        Text("Reset")
                            .font(.system(size: 15, design: .rounded).bold())
                            .foregroundStyle(vm.alternateColors ? OFF_WHITE : OFF_BLACK)
                            .onTapGesture {
                                if vm.getLoser() == false && vm.getWinner() == false && vm.remainingTime != 0{
                                    print("VIEW: Starting a new game")
                                    if secondCodeSet == false{
                                        vm.stopTimer()
                                        vm.restartTimer()
                                    }
                                    else {
                                        vm.restartTimer()
                                    }
                                    vm.startNewGameTwoPlayer(savedPlayer1Name: player1Name, savedPlayer2Name: player2Name, savedPlayer1Score: vm.getPlayer1Score(), savedPlayer2Score: vm.getPlayer2Score(), resetCode: secondCodeSet)
                                    vm.changePlayer1Score(score: -1)
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
                    
                    ButtonGuessRow(row: guessNumber.id, vmLocal: vm, twoPlayer: Binding.constant(true), alternateColors: $vm.alternateColors, showPlayerOneName: Binding.constant(false), showPlayerTwoName: Binding.constant(false), showPlayerOneCode: Binding.constant(false), showPlayerTwoCode: $showPlayer2Code, onGameTwo: Binding.constant(true))
                        .onTapGesture {
                            vm.chooseRow(rowNumber: guessNumber.id)
                        }
                }
                
                // if we have a loser, prints out Secret code
                if vm.getLoser() || vm.remainingTime == 0 {
                    Text("Secret Code")
                        .font(.system(size: 20).bold())
                        .foregroundStyle(vm.alternateColors ? OFF_WHITE : OFF_BLACK)
                        .onAppear {
                            if vm.remainingTime == 0 {
                                vm.changePlayer1Score(score: 6)
                            }
                        }
                    
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
                                    if vm.selectionOn{
                                        vm.chooseButton(buttonNumber: thisButton.id)
                                        selectedColor = thisButton.id
                                        
                                        if vm.tappingSounds {
                                            let audiomanagerLocal = AudioManager()
                                            audiomanagerLocal.playBeadPress()
                                        }
                                    }
                                    //print("You clicked this color, \(thisButton.id)")
                                    //selectedColor = thisButton.id
                                   
                                })
                        }
                    }
                }
            }
            .padding()
            
            // transitioning between different views depending on conditional statements and boolean flags
            if showPlayer2Code{
                Player2CodeView(player1Name: $player1Name, player2Name: $player2Name, showPlayer2CodeView: $showPlayer2Code, secondCodeSet: $secondCodeSet, selectedColor: $selectedColor, vmLocal: vm)
            }
            
            // There are three cases, player 1 wins, player 2 wins, or player 1 and player 2 have a tie. The loser case must be first in the code to short-circuit program.
            if (vm.getLoser() || vm.remainingTime == 0) && seeGuesses == false{
                
                if vm.getPlayer1Score() < vm.getPlayer2Score() && vm.remainingTime != 0{
                    ZStack{
                        RoundedRectangle(cornerRadius: CORNER_RADIUS)
                            .stroke(.black,lineWidth: 15)
                            .fill(.black)
                            .frame(width: TWO_PLAYER_WIN_OR_LOSE_WIDTH, height: TWO_PLAYER_WIN_OR_LOSE_HEIGHT)
                            .onTapGesture {
                                confettiCounter += 1
                                if vm.winSounds{
                                    playWinSound()
                                }
                            }
                        VStack{
                            Text(" \(vm.getPlayer1Name()) WINS \n CONGRATULATIONS!")
                                 .bold()
                                 .foregroundStyle(.white)
                                 .background(Color.black)
                                 .font(.system(size: WIN_OR_LOSE_FONT_SIZE))
                                 .onTapGesture {
                                     confettiCounter += 1
                                     if vm.winSounds{
                                         playWinSound()
                                     }
                                 }
                            Text(" See Guesses? ")
                                .foregroundStyle(.white)
                                .onTapGesture {
                                    seeGuesses = true
                                }
                            
                            Text(" See Game Statistics? ")
                                .foregroundStyle(.white)
                                .onTapGesture {
                                    gameState = .endScreen
                                }
                            .padding(3)
                        }
                        .onAppear{
                            
                            confettiCounter += 1
                            if vm.winSounds{
                                playWinSound()
                            }
                            
                            print("TEST PRINT 3")
                            // adding player nmes to the list of player names if they do not already exist
                            vm.addPlayerName(playerName: vm.getPlayer1Name())
                            
                            // incrementing win counts for player1
                            vm.incrementWinCount(playerName: vm.getPlayer1Name())

                            // changing the high score for both players if their high scores need to be changed
                            vm.newHighScore(playerName: vm.getPlayer1Name(), newScore: vm.getPlayer1Score())
                        
                            vm.stopTimer()
                            
                        }
                        
                    }
                }
                
                else if vm.getPlayer1Score() > vm.getPlayer2Score() {
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
                            Text(" \(vm.getPlayer2Name()) WINS \n CONGRATULATIONS!")
                                 .bold()
                                 .foregroundStyle(.white)
                                 .background(Color.black)
                                 .font(.system(size: WIN_OR_LOSE_FONT_SIZE))
                                 .onTapGesture {
                                     if vm.winSounds{
                                         playLoseSound()
                                     }
                                 }
                            Text(" See Guesses? ")
                                .foregroundStyle(.white)
                                .onTapGesture {
                                    seeGuesses = true
                                }
                            
                            Text(" See Game Statistics? ")
                                .foregroundStyle(.white)
                                .onTapGesture {
                                    gameState = .endScreen
                                }
                            .padding(3)
                        }
                        .onAppear{
                            if vm.winSounds{
                                playLoseSound()
                            }
                            
                            // adding player nmes to the list of player names if they do not already exist
                            vm.addPlayerName(playerName: vm.getPlayer2Name())
                            
                            // incrementing win counts for both player2
                            vm.incrementWinCount(playerName: vm.getPlayer2Name())
                            
                            // changing the high score for both players if their high scores need to be changed
                            vm.newHighScore(playerName: vm.getPlayer2Name(), newScore: vm.getPlayer2Score())
                            
                            vm.stopTimer()
                        }
                    }
                }
                
                else if vm.getPlayer1Score() == vm.getPlayer2Score() {
                    ZStack{
                        RoundedRectangle(cornerRadius: CORNER_RADIUS)
                            .stroke(.black,lineWidth: 15)
                            .fill(.black)
                            .frame(width: TWO_PLAYER_WIN_OR_LOSE_WIDTH, height: TWO_PLAYER_WIN_OR_LOSE_HEIGHT)
                            .onTapGesture {
                                confettiCounter += 1
                                if vm.winSounds{
                                    playWinSound()
                                }
                            }
                        VStack{
                            Text(" \(vm.getPlayer1Name()) and \(vm.getPlayer2Name()) \n have a tie!")
                                 .bold()
                                 .foregroundStyle(.white)
                                 .background(Color.black)
                                 .font(.system(size: WIN_OR_LOSE_FONT_SIZE))
                                 .onTapGesture {
                                     confettiCounter += 1
                                     if vm.winSounds{
                                         playWinSound()
                                     }
                                 }
                            Text(" See Guesses? ")
                                .foregroundStyle(.white)
                                .onTapGesture {
                                    seeGuesses = true
                                }
                            
                            Text(" See Game Statistics? ")
                                .foregroundStyle(.white)
                                .onTapGesture {
                                    gameState = .endScreen
                                }
                            .padding(3)
                        }
                        .onAppear{
                            confettiCounter += 1
                            if vm.winSounds{
                                playWinSound()
                            }
                            
                            print("TEST PRINT 1")
                            // adding player nmes to the list of player names if they do not already exist
                            vm.addPlayerName(playerName: vm.getPlayer1Name())
                            vm.addPlayerName(playerName: vm.getPlayer2Name())
                            
                            // incrementing win counts for both players
                            vm.incrementWinCount(playerName: vm.getPlayer1Name())
                            vm.incrementWinCount(playerName: vm.getPlayer2Name())
                            
                            // changing the high score for both players if their high scores need to be changed
                            vm.newHighScore(playerName: vm.getPlayer1Name(), newScore: vm.getPlayer1Score())
                            vm.newHighScore(playerName: vm.getPlayer2Name(), newScore: vm.getPlayer2Score())
                            
                            vm.stopTimer()
                            
                        }
                        .confettiCannon(counter: $confettiCounter, num: CONFETTI_NUM, rainHeight: CONFETTI_RAIN_HEIGHT, openingAngle: Angle.degrees(CONFETTI_RAIN_OPENING_ANGLE), closingAngle: Angle.degrees(CONFETTI_RAIN_CLOSING_ANGLE))
                    }
                }
            }
            else if seeGuesses == false && vm.getWinner(){
                
                if vm.getPlayer1Score() < vm.getPlayer2Score() {
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
                        VStack{
                            Text(" \(vm.getPlayer1Name()) WINS \n CONGRATULATIONS!")
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
                            Text(" See Guesses? ")
                                .foregroundStyle(.white)
                                .onTapGesture {
                                    seeGuesses = true
                                }
                            
                            Text(" See Game Statistics? ")
                                .foregroundStyle(.white)
                                .onTapGesture {
                                    gameState = .endScreen
                                }
                            .padding(3)
                        }
                        .onAppear{
                            if vm.winSounds{
                                confettiCounter += 1
                                playWinSound()
                            }
                            
                            // adding player nmes to the list of player names if they do not already exist
                            vm.addPlayerName(playerName: vm.getPlayer1Name())
                            // incrementing win counts for both players
                            vm.incrementWinCount(playerName: vm.getPlayer1Name())
                            
                            // changing the high score for both players if their high scores need to be changed
                            vm.newHighScore(playerName: vm.getPlayer1Name(), newScore: vm.getPlayer1Score())
                            
                            vm.stopTimer()
                            vm.restartTimer()
                        }
                       .confettiCannon(counter: $confettiCounter, num: CONFETTI_NUM, rainHeight: CONFETTI_RAIN_HEIGHT, openingAngle: Angle.degrees(CONFETTI_RAIN_OPENING_ANGLE), closingAngle: Angle.degrees(CONFETTI_RAIN_CLOSING_ANGLE))
                    }
                }
                
                else if vm.getPlayer1Score() > vm.getPlayer2Score() {
                    ZStack{
                        RoundedRectangle(cornerRadius: CORNER_RADIUS)
                            .stroke(.black,lineWidth: 15)
                            .fill(.black)
                            .frame(width: TWO_PLAYER_WIN_OR_LOSE_WIDTH, height: TWO_PLAYER_WIN_OR_LOSE_HEIGHT)
                            .onTapGesture {
                                print("Attempting Win Animation")
                                if vm.winSounds{
                                    playLoseSound()
                                }
                            }
                        VStack{
                            Text(" \(vm.getPlayer2Name()) WINS \n CONGRATULATIONS!")
                                 .bold()
                                 .foregroundStyle(.white)
                                 .background(Color.black)
                                 .font(.system(size: WIN_OR_LOSE_FONT_SIZE))
                                 .onTapGesture {
                                     print("Attempting Win Animation")
                                     if vm.winSounds{
                                         playLoseSound()
                                     }
                                 }
                            Text(" See Guesses? ")
                                .foregroundStyle(.white)
                                .onTapGesture {
                                    seeGuesses = true
                                }
                            
                            Text(" See Game Statistics? ")
                                .foregroundStyle(.white)
                                .onTapGesture {
                                    gameState = .endScreen
                                }
                            .padding(3)
                        }
                        .onAppear{
                            if vm.winSounds{
                                playLoseSound()
                            }
                            
                            // adding player nmes to the list of player names if they do not already exist
                            vm.addPlayerName(playerName: vm.getPlayer2Name())
                            
                            // incrementing win counts for both players
                            vm.incrementWinCount(playerName: vm.getPlayer2Name())
                            
                            // changing the high score for both players if their high scores need to be changed
                            vm.newHighScore(playerName: vm.getPlayer2Name(), newScore: vm.getPlayer2Score())
                            
                            vm.stopTimer()
                            vm.restartTimer()
                        }
                        .confettiCannon(counter: $confettiCounter, num: CONFETTI_NUM, rainHeight: CONFETTI_RAIN_HEIGHT, openingAngle: Angle.degrees(CONFETTI_RAIN_OPENING_ANGLE), closingAngle: Angle.degrees(CONFETTI_RAIN_CLOSING_ANGLE))
                    }
                }
                
                if vm.getPlayer1Score() == vm.getPlayer2Score() {
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
                        VStack{
                            Text(" \(vm.getPlayer1Name()) and \(vm.getPlayer2Name()) \n have a tie!")
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
                            Text(" See Guesses? ")
                                .foregroundStyle(.white)
                                .onTapGesture {
                                    seeGuesses = true
                                }
                            
                            Text(" See Game Statistics? ")
                                .foregroundStyle(.white)
                                .onTapGesture {
                                    gameState = .endScreen
                                }
                            .padding(3)
                        }
                        .onAppear{
                            confettiCounter += 1
                            if vm.winSounds {
                                playWinSound()
                            }
                            
                            print("TEST PRINT 2")
                            // adding player nmes to the list of player names if they do not already exist
                            vm.addPlayerName(playerName: vm.getPlayer1Name())
                            vm.addPlayerName(playerName: vm.getPlayer2Name())
                            
                            // incrementing win counts for both players
                            vm.incrementWinCount(playerName: vm.getPlayer1Name())
                            vm.incrementWinCount(playerName: vm.getPlayer2Name())
                            
                            // changing the high score for both players if their high scores need to be changed
                            vm.newHighScore(playerName: vm.getPlayer1Name(), newScore: vm.getPlayer1Score())
                            vm.newHighScore(playerName: vm.getPlayer2Name(), newScore: vm.getPlayer2Score())
                            
                            vm.stopTimer()
                            vm.restartTimer()
                        }
                    }
                    .confettiCannon(counter: $confettiCounter, num: CONFETTI_NUM, rainHeight: CONFETTI_RAIN_HEIGHT, openingAngle: Angle.degrees(CONFETTI_RAIN_OPENING_ANGLE), closingAngle: Angle.degrees(CONFETTI_RAIN_CLOSING_ANGLE))
                }
                
            }
        }
    }
}

