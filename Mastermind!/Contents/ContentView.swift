//
// ContentView.swift
// Mastermind!
//
// CONTENT VIEW
//
// Created by Keaton Goebel on 1/17/24.
//

import SwiftUI
import ConfettiSwiftUI
import AVFoundation

class AudioManager {
    static let shared = AudioManager()
    var audioPlayerBackGround: AVAudioPlayer?
    var audioPlayerSoundEffect: AVAudioPlayer?
    
    let songTitles = ["background_music1", "background_music2", "background_music3", "background_music4", "background_music5", "background_music6", "background_music7", "background_music8", "background_music9", "background_music10"]
    
    func playBackgroundMusic(backgroundOn: Bool) {
        if backgroundOn {
            
            let randomIndex = Int.random(in: 0..<songTitles.count)
            let songTitle = songTitles[randomIndex]
            
            // Get the URL for the sound file
            if let url = Bundle.main.url(forResource: songTitle, withExtension: "mp4") {
                do {
                    // Initialize the AVAudioPlayer with the contents of the file
                    audioPlayerBackGround = try AVAudioPlayer(contentsOf: url)
                    audioPlayerBackGround?.numberOfLoops = -1
                    audioPlayerBackGround?.play()
                } catch {
                    print("Error playing background music: \(error.localizedDescription)")
                }
            } else {
                print("Background music file not found in bundle.")
            }
        }
    }

    func stopBackgroundMusic() {
        audioPlayerBackGround?.stop()
    }
    
    func playSoundEffect(soundName: String) {
           guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp4") else {
               print("Error: \(soundName).mp4 not found.")
               return
           }
           
           do {
               audioPlayerSoundEffect = try AVAudioPlayer(contentsOf: url)
               audioPlayerSoundEffect?.play()
           } catch {
               print("Error playing sound effect: \(error.localizedDescription)")
           }
       }
    
    func playBeadPress() {
        
        AudioManager.shared.playSoundEffect(soundName: "bead_press")
        
    }
    
    func playEnterKey() {
        
        AudioManager.shared.playSoundEffect(soundName: "enter_key")
        
    }
}


struct TimerView: View {
    @ObservedObject var vmLocal = ViewModel()
    
    var body: some View {
        
        VStack {
            
            // Progress bar, gray bar with a shrinking blue/red bar on top of it
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .foregroundColor(.gray)
                        .frame(width: geometry.size.width, height: 10)
                    Rectangle()
                        .foregroundColor(vmLocal.isThird ? .red : .blue)
                        .frame(width: CGFloat((vmLocal.remainingTime / vmLocal.timerDuration) * 361), height: 10)
                }
                .cornerRadius(5)
            }
            .frame(height: 10)
        }
    }
}

struct ContentView: View {
    
    enum GameState{
        case singlePlayer
        case twoPlayer
        case homeScreen
        case endScreen
        case settingScreen
    }
    
    @State var gameState = GameState.homeScreen
    @ObservedObject var vm = ViewModel()
    
    var body: some View {
        
        switch gameState{
        case .homeScreen:
            HomeScreenView(vm: vm, gameState: $gameState)
        case .singlePlayer:
            SinglePlayerView(vm: vm, gameState: $gameState, player1Name: "Player 1")
                .onAppear {
                   // print("Play background music with soundOn: \(soundOn)")
                    AudioManager.shared.playBackgroundMusic(backgroundOn: vm.backgroundMusicOn)
                    }
                .onDisappear {
                   // print("Stop background music")
                    AudioManager.shared.stopBackgroundMusic()
                    }
        case .twoPlayer:
            TwoPlayerView(vm: vm, gameState: $gameState, player1Name: "Player 1", player2Name: "Player 2")
                .onAppear {
                  //  print("Play background music with soundOn: \(soundOn)")
                    AudioManager.shared.playBackgroundMusic(backgroundOn: vm.backgroundMusicOn)
                }
                .onDisappear {
                  //  print("Stop background music")
                    AudioManager.shared.stopBackgroundMusic()
                }
        case .endScreen:
            GameStatsView(vm: vm, gameState: $gameState)
        
        case .settingScreen:
            SettingsView(vm: vm, gameState: $gameState)
        }
    }
    
    struct HomeScreenView: View {
        @ObservedObject var vm: ViewModel
        @Binding var gameState: GameState
        
        var body: some View {
            ZStack {
                
                Rectangle()
                    .fill(vm.getBackgroundColor(alternateColor: vm.alternateColors))
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    
                    Text("Mastermind!")
                        .font(.system(size: HOME_BUTTONS_TEXT_SIZE, design: .rounded).bold())
                        .foregroundStyle(vm.alternateColors ? OFF_WHITE : OFF_BLACK)
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: CORNER_RADIUS)
                            .fill(vm.getSideButtonColor(alternateColor: vm.alternateColors))
                            .stroke(Color.black,lineWidth: 8)
                            .frame(width: HOME_BUTTONS_WIDTH, height: HOME_BUTTONS_HEIGHT)
                            .padding(8)
                            .onTapGesture {
                                vm.startNewGameSinglePlayer()
                                vm.stopTimer()
                                vm.restartTimer()
                                gameState = .singlePlayer
                            }
                        Text("Single Player")
                            .font(.system(size: HOME_BUTTONS_TEXT_SIZE, design: .rounded).bold())
                            .foregroundStyle(vm.alternateColors ? OFF_WHITE : OFF_BLACK)
                            .onTapGesture {
                                vm.startNewGameSinglePlayer()
                                vm.stopTimer()
                                vm.restartTimer()
                                gameState = .singlePlayer
                            }
                    }
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: CORNER_RADIUS)
                            .fill(vm.getSideButtonColor(alternateColor: vm.alternateColors))
                            .stroke(Color.black,lineWidth: 8)
                            .frame(width: HOME_BUTTONS_WIDTH, height: HOME_BUTTONS_HEIGHT)
                            .padding(8)
                            .onTapGesture {
                                vm.changePlayer1Name(PlayerName: "Player 1")
                                vm.changePlayer2Name(PlayerName: "Player 2")
                                vm.changePlayer1Name(PlayerName: DEFAULT_PLAYER1_NAME)
                                vm.changePlayer2Name(PlayerName: DEFAULT_PLAYER2_NAME)
                                vm.changePlayer1Score(score: DEFAULT_PLAYER_SCORE)
                                vm.changePlayer2Score(score: DEFAULT_PLAYER_SCORE)
                                vm.stopTimer()
                                vm.restartTimer()
                                vm.startNewGameSinglePlayer()
                                gameState = .twoPlayer
                            }
                        Text("Two Player")
                            .font(.system(size: HOME_BUTTONS_TEXT_SIZE, design: .rounded).bold())
                            .foregroundStyle(vm.alternateColors ? OFF_WHITE : OFF_BLACK)
                            .onTapGesture {
                                
                                // When the user goes into the game from the homescreen, a full reset occurs. Therefore things like names and scores are returned to their default values
                                vm.changePlayer1Name(PlayerName: DEFAULT_PLAYER1_NAME)
                                vm.changePlayer2Name(PlayerName: DEFAULT_PLAYER2_NAME)
                                vm.changePlayer1Score(score: DEFAULT_PLAYER_SCORE)
                                vm.changePlayer2Score(score: DEFAULT_PLAYER_SCORE)
                                vm.stopTimer()
                                vm.restartTimer()
                                vm.startNewGameSinglePlayer()
                                gameState = .twoPlayer
                            }
                    }
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: CORNER_RADIUS)
                            .fill(vm.getSideButtonColor(alternateColor: vm.alternateColors))
                            .stroke(Color.black,lineWidth: 8)
                            .frame(width: HOME_BUTTONS_WIDTH, height: HOME_BUTTONS_HEIGHT)
                            .padding(8)
                            .onTapGesture {
                                gameState = .settingScreen
                            }
                        Text("Settings")
                            .font(.system(size: HOME_BUTTONS_TEXT_SIZE, design: .rounded).bold())
                            .foregroundStyle(vm.alternateColors ? OFF_WHITE : OFF_BLACK)
                            .onTapGesture {
                                gameState = .settingScreen
                            }
                    }
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: CORNER_RADIUS)
                            .fill(vm.getSideButtonColor(alternateColor: vm.alternateColors))
                            .stroke(Color.black,lineWidth: 8)
                            .frame(width: HOME_BUTTONS_WIDTH, height: HOME_BUTTONS_HEIGHT)
                            .padding(8)
                            .onTapGesture {
                                gameState = .endScreen
                            }
                        Text("Game Statistics")
                            .font(.system(size: HOME_BUTTONS_TEXT_SIZE, design: .rounded).bold())
                            .foregroundStyle(vm.alternateColors ? OFF_WHITE : OFF_BLACK)
                            .onTapGesture {
                                gameState = .endScreen
                            }
                    }

                }
            }
        }
        
    }
    
    struct SinglePlayerView: View {
        @ObservedObject var vm: ViewModel
        @Binding var gameState: GameState
        @State var seeGuesses: Bool = false
        @State var confettiCounter: Int = 0
        @State var showPlayer1Name = true
        @State var player1Name: String
        
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
                                 //   print("Going back to the home screen")
                                    vm.stopTimer()
                                    vm.restartTimer()
                                    gameState = .homeScreen
                                }
                        }
                        
                        Text("Mastermind! \n\(vm.getPlayer1Name()) : \(vm.reverseRow(oldRow: vm.currentRowNumber + -1))")
                            .font(.system(size: 20, design: .rounded).bold())
                            .foregroundStyle(vm.alternateColors ? OFF_WHITE : OFF_BLACK)
                        
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
                                    print("VIEW: Starting a new game")
                                    let currentName = vm.getPlayer1Name()
                                    vm.stopTimer()
                                    vm.restartTimer()
                                    vm.startNewGameSinglePlayer()
                                    seeGuesses = false
                                    showPlayer1Name = true
                                    vm.changePlayer1Name(PlayerName: currentName)
                                }
                        }
                    }
                    
                    if vm.timerOn {
                        TimerView(vmLocal: vm)
                    }
                    
                    // rows of user guesses
                    ForEach(vm.userGuesses){ guessNumber in
                        
                        ButtonGuessRow(row: guessNumber.id, vmLocal: vm, twoPlayer: Binding.constant(false), alternateColors: $vm.alternateColors, showPlayerOneName: $showPlayer1Name, showPlayerTwoName: Binding.constant(false), showPlayerOneCode: Binding.constant(false), showPlayerTwoCode: Binding.constant(false), onGameTwo: Binding.constant(false))
                            .onTapGesture {
                                vm.chooseRow(rowNumber: guessNumber.id)
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
                                ButtonOptionView(buttonId: thisButton.id, isSelected: thisButton.isSelected, alternateColors: $vm.alternateColors)
                                    .onTapGesture(perform: {
                                        // chosing a button
                                        if vm.selectionOn && showPlayer1Name == false{
                                            vm.chooseButton(buttonNumber: thisButton.id)
                                            
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
                
                // show playe1NameView
                if showPlayer1Name {
                    Player1NameViewSinglePlayer(player1Name: $player1Name, showPlayer1NameView: $showPlayer1Name, vmLocal: vm, alternateColors: $vm.alternateColors)
                }
                
                if (vm.getLoser() || vm.remainingTime == 0) && seeGuesses == false{
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: CORNER_RADIUS)
                            .stroke(.black,lineWidth: 15)
                            .fill(.black)
                            .frame(width: TWO_PLAYER_WIN_OR_LOSE_WIDTH, height: TWO_PLAYER_WIN_OR_LOSE_HEIGHT)
                            .onTapGesture {
                                if vm.winSounds{
                                    playLoseSound()
                                }
                            }
                        
                        VStack (spacing: 20){
                            Text(" YOU LOSE! ")
                                .bold()
                                .foregroundStyle(.white)
                                .font(.system(size: WIN_OR_LOSE_FONT_SIZE))
                                .onTapGesture {
                                    if vm.winSounds{
                                        playLoseSound()
                                    }
                                }
                            Text(" Reset Game? ")
                                .foregroundStyle(.white)
                                .onTapGesture {
                                    let currentName = vm.getPlayer1Name()
                                    vm.startNewGameSinglePlayer()
                                    seeGuesses = false
                                    showPlayer1Name = true
                                    vm.stopTimer()
                                    vm.restartTimer()
                                    vm.changePlayer1Name(PlayerName: currentName)
                                }
                                
                            Text(" See Guesses? ")
                                .foregroundStyle(.white)
                                .onTapGesture {
                                    seeGuesses = true
                                }
                            
                            Text(" See Game Statistics? ")
                                .foregroundStyle(.white)
                                .onTapGesture{
                                    gameState = .endScreen
                                }
                            
                        }
                        .onAppear{
                            if vm.winSounds{
                                playLoseSound()
                            }
                            vm.stopTimer()
                        }
                    }
                }
                
                else if seeGuesses == false && vm.getWinner(){
                    
                    ZStack {
                        
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
                        
                        VStack (spacing: 20){
                            Text(" YOU WIN! ")
                                .bold()
                                .foregroundStyle(.white)
                                .font(.system(size: WIN_OR_LOSE_FONT_SIZE))
                                .onTapGesture {
                                    confettiCounter += 1
                                    if vm.winSounds{
                                        playWinSound()
                                    }
                                }
                            Text(" Reset Game? ")
                                .foregroundStyle(.white)
                                .onTapGesture {
                                    let currentName = vm.getPlayer1Name()
                                    vm.startNewGameSinglePlayer()
                                    seeGuesses = false
                                    showPlayer1Name = true
                                    vm.stopTimer()
                                    vm.restartTimer()
                                    vm.changePlayer1Name(PlayerName: currentName)
                                
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
                            
                            .confettiCannon(counter: $confettiCounter, num: CONFETTI_NUM, rainHeight: CONFETTI_RAIN_HEIGHT, openingAngle: Angle.degrees(CONFETTI_RAIN_OPENING_ANGLE), closingAngle: Angle.degrees(CONFETTI_RAIN_CLOSING_ANGLE))
                        }
                        .onAppear{
                            confettiCounter += 1
                            if vm.winSounds{
                                playWinSound()
                            }
                            
                            vm.addPlayerName(playerName: vm.getPlayer1Name())
                            
                            // incrementing win counts for both players
                            vm.incrementWinCount(playerName: vm.getPlayer1Name())
                            
                            // changing the high score for both players if their high scores need to be changed
                            vm.newHighScore(playerName: vm.getPlayer1Name(), newScore: vm.reverseRow(oldRow: vm.currentRowNumber))
                            vm.stopTimer()
                        }
                    }
                }
            }
        }
    }
    
    // view of a single button that the user can select
    struct ButtonOptionView: View{
        var buttonId: Int
        var isSelected: Bool
        @Binding var alternateColors: Bool
        
        var body: some View{
            ZStack{
                Circle()
                    .fill(BUTTON_OPTIONS[buttonId].gradient)
                    .stroke(isSelected ? alternateColors ? SIDE_BUTTON_COLOR2 : SIDE_BUTTON_COLOR : Color.black, lineWidth: isSelected ? 8 : 6)
                    .padding(1)
                }
            }
        }
    }

    // view for a single bead of a user's guess
    struct ButtonGuessView: View{
        var buttonId: Int?
        var onCurrentRow: Bool
        @Binding var alternateColors: Bool
        
        var body: some View{
            
            if onCurrentRow{
                // case 1 if on the current row and the button has been selected, fill in color and make it blue and big
                if let buttonNumber = buttonId{
                    return ZStack {
                        Circle()
                            .fill(BUTTON_OPTIONS[buttonNumber])
                            .stroke(alternateColors ? SIDE_BUTTON_COLOR2 : SIDE_BUTTON_COLOR, lineWidth: 8)
                            .padding(1)
                    }
                }
                // case 2 if the button has not been selected but on the current row, fill with white and make it blue and small
                else{
                    return ZStack {
                        Circle()
                            .fill(.white)
                            .stroke(alternateColors ? SIDE_BUTTON_COLOR2 : SIDE_BUTTON_COLOR, lineWidth: 6)
                            .padding(1)
                    }
                }
            }
            else if let buttonNumber = buttonId{
                // case 3 not on the current row but the botton has been selected, fill in color and make it black and small
                return ZStack {
                    Circle()
                        .fill(BUTTON_OPTIONS[buttonNumber])
                        .stroke(Color.black, lineWidth: 6)
                        .padding(1)
                }
            }
            else {
                // case 4 not on current row and and button has not been selected, fill with white make it black and small
                return ZStack {
                    Circle()
                        .fill(.white)
                        .stroke(Color.black, lineWidth: 6)
                        .padding(1)
                }
            }
        }
    }
        
// view for a complete guess: a row of BUTTON_GUESS_COUNT buttons
struct ButtonGuessRow: View{
    var row: Int
    @ObservedObject var vmLocal: ViewModel
    @Binding var twoPlayer : Bool
    @Binding var alternateColors : Bool
    @Binding var showPlayerOneName: Bool
    @Binding var showPlayerTwoName: Bool
    @Binding var showPlayerOneCode: Bool
    @Binding var showPlayerTwoCode: Bool
    @Binding var onGameTwo: Bool
    
    var body: some View {
        HStack{
        
            // feedback beads
            ZStack{
                RoundedRectangle(cornerRadius: CORNER_RADIUS)
                    .stroke(Color.black,lineWidth: 8)
                    .fill(vmLocal.getSideButtonColor(alternateColor: alternateColors))
                    .padding(5)
                VStack{
                    makeFeedBackBeadsTopRow(redBeadCount: vmLocal.m.redCountList[row], whiteBeadCount: vmLocal.m.whiteCountList[row], currentRow: row, pastRow: vmLocal.currentRowNumber)
                    makeFeedBackBeadsBotRow(redBeadCount: vmLocal.m.redCountList[row], whiteBeadCount: vmLocal.m.whiteCountList[row], currentRow: row, pastRow: vmLocal.currentRowNumber)
                }
            }
            // this is to guarentee tapping the feedback button does nothing
            .allowsHitTesting(false)
            
            ForEach(0..<BUTTON_GUESS_COUNT, id:\.self) { column in
                ButtonGuessView(buttonId: vmLocal.userGuesses[row].guessItem[column], onCurrentRow: row == vmLocal.currentRowNumber, alternateColors: $alternateColors)
                    .onTapGesture{
                            // this is to ensure the player cannot select beads after the game is already over
                            if vmLocal.selectionOn{
                                
                                // these conditions are to ensure the player cannot select beads while there are overviews on the screen
                                // set single player
                                if !twoPlayer && !showPlayerOneName {
                                    vmLocal.setGuessButton(rowe: (vmLocal.reverseRow(oldRow: row)), col: column)
                                    if row == vmLocal.currentRowNumber {
                                        if vmLocal.tappingSounds {
                                            let audiomanagerLocal = AudioManager()
                                            audiomanagerLocal.playBeadPress()
                                        }
                                    }
                                }
                                // set two player game one
                                if twoPlayer && !onGameTwo && !showPlayerOneName && !showPlayerTwoName && !showPlayerOneCode {
                                    vmLocal.setGuessButton(rowe: (vmLocal.reverseRow(oldRow: row)), col: column)
                                    if row == vmLocal.currentRowNumber {
                                        if vmLocal.tappingSounds {
                                            let audiomanagerLocal = AudioManager()
                                            audiomanagerLocal.playBeadPress()
                                        }
                                    }
                                }
                                    // set two player game two
                                    if onGameTwo && !showPlayerTwoCode {
                                        vmLocal.setGuessButton(rowe: (vmLocal.reverseRow(oldRow: row)), col: column)
                                        if row == vmLocal.currentRowNumber {
                                            if vmLocal.tappingSounds {
                                                let audiomanagerLocal = AudioManager()
                                                audiomanagerLocal.playBeadPress()
                                            }
                                        }
                                    }
                                 
                            }

                    }
            }
            makeEnterKeyBody(isRowFull: vmLocal.rowIsFull(vmLocal.currentRowNumber), viewModel: vmLocal, currentRow: row, onGameTwo: onGameTwo, alternateColors: alternateColors)
        }
    }
    
    // func to make top feedback beeds, black represent a wrong guess, red beads always go before white beads,
    // and also empty beads are there for before you make a guess
    func makeFeedBackBeadsTopRow(redBeadCount: Int, whiteBeadCount: Int, currentRow: Int, pastRow: Int) -> some View {
        
        return HStack{
            
            // currentRow represents the row we are currently on, pastRow goes through all rows and fills them in when pastRow is less than currentRow
            if currentRow > pastRow {
                
                // top row beads
                if redBeadCount >= 2{
                    Circle()
                        .fill(SOFT_RED)
                        .frame(width: BEAD_WIDTH, height: BEAD_HEIGHT)
                    Circle()
                        .fill(SOFT_RED)
                        .frame(width: BEAD_WIDTH, height: BEAD_HEIGHT)
                }
                if redBeadCount == 1 && whiteBeadCount >= 1 {
                    Circle()
                        .fill(SOFT_RED)
                        .frame(width: BEAD_WIDTH, height: BEAD_HEIGHT)
                    Circle()
                        .fill(Color.white)
                        .frame(width: BEAD_WIDTH, height: BEAD_HEIGHT)
                }
                if whiteBeadCount >= 2 && redBeadCount == 0{
                    Circle()
                        .fill(Color.white)
                        .frame(width: BEAD_WIDTH, height: BEAD_HEIGHT)
                    Circle()
                        .fill(Color.white)
                        .frame(width: BEAD_WIDTH, height: BEAD_HEIGHT)
                }
                if redBeadCount == 1 && whiteBeadCount == 0{
                    Circle()
                        .fill(SOFT_RED)
                        .frame(width: BEAD_WIDTH, height: BEAD_HEIGHT)
                    Circle()
                        .fill(Color.black)
                        .frame(width: BEAD_WIDTH, height: BEAD_HEIGHT)
                }
                if whiteBeadCount == 1 && redBeadCount == 0{
                    Circle()
                        .fill(Color.white)
                        .frame(width: BEAD_WIDTH, height: BEAD_HEIGHT)
                    Circle()
                        .fill(Color.black)
                        .frame(width: BEAD_WIDTH, height: BEAD_HEIGHT)
                }
                if redBeadCount == 0 && whiteBeadCount == 0{
                    Circle()
                        .fill(Color.black)
                        .frame(width: BEAD_WIDTH, height: BEAD_HEIGHT)
                    Circle()
                        .fill(Color.black)
                        .frame(width: BEAD_WIDTH, height: BEAD_HEIGHT)
                }
            }
            else {
                Circle()
                    .fill(.white)
                    .strokeBorder(.black, lineWidth: 1.75)
                    .frame(width: BEAD_WIDTH, height: BEAD_HEIGHT)
    
                Circle()
                    .fill(.white)
                    .strokeBorder(Color.black, lineWidth: 1.75)
                    .frame(width: BEAD_WIDTH, height: BEAD_HEIGHT)
            }
        }
         
}
    // func to make bot feedback beeds, black represent a wrong guess, red beads always go before white beads
    // and also empty beads are there for before you make a guess
    func makeFeedBackBeadsBotRow(redBeadCount: Int, whiteBeadCount: Int, currentRow: Int, pastRow: Int) -> some View {
        
        return HStack{
        
            // currentRow represents the row we are currently on, pastRow goes through all rows and fills them in when pastRow is less than currentRow
            if currentRow > pastRow {
                
                // make bottom beads
                if redBeadCount == 4{
                    Circle()
                        .fill(SOFT_RED)
                        .frame(width: BEAD_WIDTH, height: BEAD_HEIGHT)
                    Circle()
                        .fill(SOFT_RED)
                        .frame(width: BEAD_WIDTH, height: BEAD_HEIGHT)
                }
                if whiteBeadCount == 4{
                    Circle()
                        .fill(Color.white)
                        .frame(width: BEAD_WIDTH, height: BEAD_HEIGHT)
                    Circle()
                        .fill(Color.white)
                        .frame(width: BEAD_WIDTH, height: BEAD_HEIGHT)
                }
                if redBeadCount == 2 && whiteBeadCount == 1{
                    Circle()
                        .fill(Color.white)
                        .frame(width: BEAD_WIDTH, height: BEAD_HEIGHT)
                    Circle()
                        .fill(Color.black)
                        .frame(width: BEAD_WIDTH, height: BEAD_HEIGHT)
                }
                if redBeadCount == 1 && whiteBeadCount == 2{
                    Circle()
                        .fill(Color.white)
                        .frame(width: BEAD_WIDTH, height: BEAD_HEIGHT)
                    Circle()
                        .fill(Color.black)
                        .frame(width: BEAD_WIDTH, height: BEAD_HEIGHT)
                }
                if redBeadCount == 2 && whiteBeadCount == 2{
                    Circle()
                        .fill(Color.white)
                        .frame(width: BEAD_WIDTH, height: BEAD_HEIGHT)
                    Circle()
                        .fill(Color.white)
                        .frame(width: BEAD_WIDTH, height: BEAD_HEIGHT)
                }
                if redBeadCount == 3 && whiteBeadCount == 0{
                    Circle()
                        .fill(SOFT_RED)
                        .frame(width: BEAD_WIDTH, height: BEAD_HEIGHT)
                    Circle()
                        .fill(Color.black)
                        .frame(width: BEAD_WIDTH, height: BEAD_HEIGHT)
                }
                if whiteBeadCount == 3 && redBeadCount == 0{
                    Circle()
                        .fill(Color.white)
                        .frame(width: BEAD_WIDTH, height: BEAD_HEIGHT)
                    Circle()
                        .fill(Color.black)
                        .frame(width: BEAD_WIDTH, height: BEAD_HEIGHT)
                }
                if redBeadCount == 0 && whiteBeadCount == 0{
                    Circle()
                        .fill(Color.black)
                        .frame(width: 15, height: 8)
                    Circle()
                        .fill(Color.black)
                        .frame(width: 15, height: 8)
                }
                if redBeadCount == 1 && whiteBeadCount == 1{
                    Circle()
                        .fill(Color.black)
                        .frame(width: BEAD_WIDTH, height: BEAD_HEIGHT)
                    Circle()
                        .fill(Color.black)
                        .frame(width: BEAD_WIDTH, height: BEAD_HEIGHT)
                }
                if redBeadCount == 2 && whiteBeadCount == 0{
                    Circle()
                        .fill(Color.black)
                        .frame(width: BEAD_WIDTH, height: BEAD_HEIGHT)
                    Circle()
                        .fill(Color.black)
                        .frame(width: BEAD_WIDTH, height: BEAD_HEIGHT)
                }
                if redBeadCount == 0 && whiteBeadCount == 2{
                    Circle()
                        .fill(Color.black)
                        .frame(width: BEAD_WIDTH, height: BEAD_HEIGHT)
                    Circle()
                        .fill(Color.black)
                        .frame(width: BEAD_WIDTH, height: BEAD_HEIGHT)
                }
                if redBeadCount == 0 && whiteBeadCount == 1 || redBeadCount == 1 && whiteBeadCount == 0{
                    Circle()
                        .fill(Color.black)
                        .frame(width: BEAD_WIDTH, height: BEAD_HEIGHT)
                    Circle()
                        .fill(Color.black)
                        .frame(width: BEAD_WIDTH, height: BEAD_HEIGHT)
                }
                if redBeadCount == 1 && whiteBeadCount == 3 {
                    Circle()
                        .fill(Color.white)
                        .frame(width: BEAD_WIDTH, height: BEAD_HEIGHT)
                    Circle()
                        .fill(Color.white)
                        .frame(width: BEAD_WIDTH, height: BEAD_HEIGHT)
                }
            }
            else {
                Circle()
                    .fill(.white)
                    .strokeBorder(.black, lineWidth: 1.75)
                    .frame(width: BEAD_WIDTH, height: BEAD_HEIGHT)
    
                Circle()
                    .fill(.white)
                    .strokeBorder(Color.black, lineWidth: 1.75)
                    .frame(width: BEAD_WIDTH, height: BEAD_HEIGHT)
            }
        }
    }
}
