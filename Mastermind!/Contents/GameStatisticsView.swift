//
//  GameStatsView.swift
//  Mastermind!
//
//  Created by Keaton Goebel on 4/5/24.
//

import SwiftUI

struct GameStatsView: View {
    @ObservedObject var vm: ViewModel
    @Binding var gameState: ContentView.GameState
    
    var body: some View {
        ZStack{
            
            // Background color
            Rectangle()
                .fill(vm.getBackgroundColor(alternateColor: vm.alternateColors))
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                // Title
                Text("Game Statistics")
                    .font(.system(size: GAME_STATS_TEXT_SIZE, design: .rounded).bold())
                    .foregroundStyle(vm.alternateColors ? OFF_WHITE : OFF_BLACK)
                    .offset(y: COLUMN_Y_OFFSET)
                    .padding()
                
                // Column Headers
                HStack(spacing: COLUMN_SPACING) {
                    Text(" Player Name ")
                        .font(.system(size: COLUMN_TEXT_SIZE, design: .rounded).bold())
                        .foregroundStyle(vm.alternateColors ? OFF_WHITE : OFF_BLACK)
                    
                    Text(" Number Of Wins ")
                        .font(.system(size: COLUMN_TEXT_SIZE, design: .rounded).bold())
                        .foregroundStyle(vm.alternateColors ? OFF_WHITE : OFF_BLACK)
                    
                    Text(" Lowest Score ")
                        .font(.system(size: COLUMN_TEXT_SIZE, design: .rounded).bold())
                        .foregroundStyle(vm.alternateColors ? OFF_WHITE : OFF_BLACK)
                }
                .offset(y: COLUMN_Y_OFFSET)
                
                // Rows
                VStack(spacing: COLUMN_SPACING) {
                    Text("1")
                        .bold()
                        .foregroundStyle(vm.alternateColors ? OFF_WHITE : OFF_BLACK)
                    // if name exists in playerNames, then it will grab the elements from the tuple and post them in the leaderboard
                    HStack(spacing: COLUMN_SPACING) {
                        // if first user name exists first two commas
                        if let tupleStarter = vm.playerNames.firstIndex(of: "(") {
                            if let elementSeparator = vm.playerNames.firstIndex(of: ",") {
                                
                                // parsing player name
                                let playerNameStart = vm.playerNames.index(after: tupleStarter)
                                let playerNameEnd = vm.playerNames.index(before: elementSeparator)
                                let playerName = String(vm.playerNames[playerNameStart...playerNameEnd])
                                Text(playerName)
                                    .font(.system(size: COLUMN_DATA_TEXT_SIZE, design: .rounded))
                                    .foregroundStyle(vm.alternateColors ? OFF_WHITE : OFF_BLACK)
                                    .offset(x: USERNAME_OFFSET)
                                
                                if let tupleEnder = vm.playerNames.firstIndex(of: ")") {
                                    
                                    // parsing win Count
                                    if let secondSeparator = vm.playerNames[elementSeparator...].dropFirst().firstIndex(of: ","){
                                        
                                        let winCountStart = vm.playerNames.index(after: elementSeparator)
                                        let winCountEnd = vm.playerNames.index(before: secondSeparator)
                                        let winCount = String(vm.playerNames[winCountStart...winCountEnd])
                                        Text(winCount)
                                            .font(.system(size: COLUMN_DATA_TEXT_SIZE, design: .rounded))
                                            .foregroundStyle(vm.alternateColors ? OFF_WHITE : OFF_BLACK)
                                            .offset(x: WIN_OFFSET)
                                        
                                        // parsing lowest score
                                        let lowestScoreStart = vm.playerNames.index(after: secondSeparator)
                                        let lowestScoreEnd = vm.playerNames.index(before: tupleEnder)
                                        let lowestScore = String(vm.playerNames[lowestScoreStart...lowestScoreEnd])
                                        Text(lowestScore)
                                            .font(.system(size: COLUMN_DATA_TEXT_SIZE, design: .rounded))
                                            .foregroundStyle(vm.alternateColors ? OFF_WHITE : OFF_BLACK)
                                            .offset(x: HIGHSCORE_OFFSET)
                                    }
                                }
                            }
                        }
                    }
                    
                    Text("2")
                        .bold()
                        .foregroundStyle(vm.alternateColors ? OFF_WHITE : OFF_BLACK)
                    
                    // if name exists in playerNames, then it will grab the elements from the tuple and post them in the leaderboard
                    HStack(spacing: COLUMN_SPACING) {
                        // if second user name exists second two commas inside
                        if let firstTupleEnd = vm.playerNames.firstIndex(of: ")"){
                            
                            if let tupleStarter = vm.playerNames[firstTupleEnd...].dropFirst().firstIndex(of: "(") {
                                if let elementSeparator = vm.playerNames[firstTupleEnd...].dropFirst().firstIndex(of: ",") {
                                    
                                    // parsing player name
                                    let playerNameStart = vm.playerNames.index(after: tupleStarter)
                                    let playerNameEnd = vm.playerNames.index(before: elementSeparator)
                                    let playerName = String(vm.playerNames[playerNameStart...playerNameEnd])
                                    Text(playerName)
                                        .font(.system(size: COLUMN_DATA_TEXT_SIZE, design: .rounded))
                                        .foregroundStyle(vm.alternateColors ? OFF_WHITE : OFF_BLACK)
                                        .offset(x: USERNAME_OFFSET)
                                    
                                    if let tupleEnder = vm.playerNames[firstTupleEnd...].dropFirst().firstIndex(of: ")") {
                                        
                                        // parsing win Count
                                        if let secondSeparator = vm.playerNames[elementSeparator...].dropFirst().firstIndex(of: ","){
                                            
                                            let winCountStart = vm.playerNames.index(after: elementSeparator)
                                            let winCountEnd = vm.playerNames.index(before: secondSeparator)
                                            let winCount = String(vm.playerNames[winCountStart...winCountEnd])
                                            Text(winCount)
                                                .font(.system(size: COLUMN_DATA_TEXT_SIZE, design: .rounded))
                                                .foregroundStyle(vm.alternateColors ? OFF_WHITE : OFF_BLACK)
                                                .offset(x: WIN_OFFSET)
                                            
                                            // parsing lowest score
                                            let lowestScoreStart = vm.playerNames.index(after: secondSeparator)
                                            let lowestScoreEnd = vm.playerNames.index(before: tupleEnder)
                                            let lowestScore = String(vm.playerNames[lowestScoreStart...lowestScoreEnd])
                                            Text(lowestScore)
                                                .font(.system(size: COLUMN_DATA_TEXT_SIZE, design: .rounded))
                                                .foregroundStyle(vm.alternateColors ? OFF_WHITE : OFF_BLACK)
                                                .offset(x: HIGHSCORE_OFFSET)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    Text("3")
                        .bold()
                        .foregroundStyle(vm.alternateColors ? OFF_WHITE : OFF_BLACK)
                    
                    // if name exists in playerNames, then it will grab the elements from the tuple and post them in the leaderboard
                    HStack(spacing: COLUMN_SPACING) {
                        
                        if let firstTupleEnd = vm.playerNames.firstIndex(of: ")"){
                            if let secondTupleEnd = vm.playerNames[firstTupleEnd...].dropFirst().firstIndex(of: ")"){
                                
                                if let tupleStarter = vm.playerNames[secondTupleEnd...].dropFirst().firstIndex(of: "(") {
                                    if let elementSeparator = vm.playerNames[secondTupleEnd...].dropFirst().firstIndex(of: ",") {
                                        
                                        // parsing player name
                                        let playerNameStart = vm.playerNames.index(after: tupleStarter)
                                        let playerNameEnd = vm.playerNames.index(before: elementSeparator)
                                        let playerName = String(vm.playerNames[playerNameStart...playerNameEnd])
                                        Text(playerName)
                                            .font(.system(size: COLUMN_DATA_TEXT_SIZE, design: .rounded))
                                            .foregroundStyle(vm.alternateColors ? OFF_WHITE : OFF_BLACK)
                                            .offset(x: USERNAME_OFFSET)
                                        
                                        if let tupleEnder = vm.playerNames[secondTupleEnd...].dropFirst().firstIndex(of: ")") {
                                            
                                            // parsing win Count
                                            if let secondSeparator = vm.playerNames[elementSeparator...].dropFirst().firstIndex(of: ","){
                                                
                                                let winCountStart = vm.playerNames.index(after: elementSeparator)
                                                let winCountEnd = vm.playerNames.index(before: secondSeparator)
                                                let winCount = String(vm.playerNames[winCountStart...winCountEnd])
                                                Text(winCount)
                                                    .font(.system(size: COLUMN_DATA_TEXT_SIZE, design: .rounded))
                                                    .foregroundStyle(vm.alternateColors ? OFF_WHITE : OFF_BLACK)
                                                    .offset(x: WIN_OFFSET)
                                                
                                                // parsing lowest score
                                                let lowestScoreStart = vm.playerNames.index(after: secondSeparator)
                                                let lowestScoreEnd = vm.playerNames.index(before: tupleEnder)
                                                let lowestScore = String(vm.playerNames[lowestScoreStart...lowestScoreEnd])
                                                Text(lowestScore)
                                                    .font(.system(size: COLUMN_DATA_TEXT_SIZE, design: .rounded))
                                                    .foregroundStyle(vm.alternateColors ? OFF_WHITE : OFF_BLACK)
                                                    .offset(x: HIGHSCORE_OFFSET)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    Text("4")
                        .bold()
                        .foregroundStyle(vm.alternateColors ? OFF_WHITE : OFF_BLACK)
                    
                    // if name exists in playerNames, then it will grab the elements from the tuple and post them in the leaderboard
                    HStack(spacing: COLUMN_SPACING) {
                        
                        if let firstTupleEnd = vm.playerNames.firstIndex(of: ")"){
                            if let secondTupleEnd = vm.playerNames[firstTupleEnd...].dropFirst().firstIndex(of: ")"){
                                if let thirdTupleEnd = vm.playerNames[secondTupleEnd...].dropFirst().firstIndex(of: ")"){
                                    
                                    if let tupleStarter = vm.playerNames[thirdTupleEnd...].dropFirst().firstIndex(of: "(") {
                                        if let elementSeparator = vm.playerNames[thirdTupleEnd...].dropFirst().firstIndex(of: ",") {
                                            
                                            // parsing player name
                                            let playerNameStart = vm.playerNames.index(after: tupleStarter)
                                            let playerNameEnd = vm.playerNames.index(before: elementSeparator)
                                            let playerName = String(vm.playerNames[playerNameStart...playerNameEnd])
                                            Text(playerName)
                                                .foregroundStyle(vm.alternateColors ? OFF_WHITE : OFF_BLACK)
                                                .font(.system(size: COLUMN_DATA_TEXT_SIZE, design: .rounded))
                                                .offset(x: USERNAME_OFFSET)
                                            
                                            if let tupleEnder = vm.playerNames[thirdTupleEnd...].dropFirst().firstIndex(of: ")") {
                                                
                                                // parsing win Count
                                                if let secondSeparator = vm.playerNames[elementSeparator...].dropFirst().firstIndex(of: ","){
                                                    
                                                    let winCountStart = vm.playerNames.index(after: elementSeparator)
                                                    let winCountEnd = vm.playerNames.index(before: secondSeparator)
                                                    let winCount = String(vm.playerNames[winCountStart...winCountEnd])
                                                    Text(winCount)
                                                        .font(.system(size: COLUMN_DATA_TEXT_SIZE, design: .rounded))
                                                        .foregroundStyle(vm.alternateColors ? OFF_WHITE : OFF_BLACK)
                                                        .offset(x: WIN_OFFSET)
                                                    
                                                    // parsing lowest score
                                                    let lowestScoreStart = vm.playerNames.index(after: secondSeparator)
                                                    let lowestScoreEnd = vm.playerNames.index(before: tupleEnder)
                                                    let lowestScore = String(vm.playerNames[lowestScoreStart...lowestScoreEnd])
                                                    Text(lowestScore)
                                                        .font(.system(size: COLUMN_DATA_TEXT_SIZE, design: .rounded))
                                                        .foregroundStyle(vm.alternateColors ? OFF_WHITE : OFF_BLACK)
                                                        .offset(x: HIGHSCORE_OFFSET)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    Text("5")
                        .bold()
                        .foregroundStyle(vm.alternateColors ? OFF_WHITE : OFF_BLACK)
                    // if name exists in playerNames, then it will grab the elements from the tuple and post them in the leaderboard
                    HStack(spacing: COLUMN_SPACING) {
                        
                        if let firstTupleEnd = vm.playerNames.firstIndex(of: ")"){
                            if let secondTupleEnd = vm.playerNames[firstTupleEnd...].dropFirst().firstIndex(of: ")"){
                                if let thirdTupleEnd = vm.playerNames[secondTupleEnd...].dropFirst().firstIndex(of: ")"){
                                    if let fourthTupleEnd = vm.playerNames[thirdTupleEnd...].dropFirst().firstIndex(of: ")"){
                                        
                                        if let tupleStarter = vm.playerNames[fourthTupleEnd...].dropFirst().firstIndex(of: "(") {
                                            if let elementSeparator = vm.playerNames[fourthTupleEnd...].dropFirst().firstIndex(of: ",") {
                                                
                                                // parsing player name
                                                let playerNameStart = vm.playerNames.index(after: tupleStarter)
                                                let playerNameEnd = vm.playerNames.index(before: elementSeparator)
                                                let playerName = String(vm.playerNames[playerNameStart...playerNameEnd])
                                                Text(playerName)
                                                    .font(.system(size: COLUMN_DATA_TEXT_SIZE, design: .rounded))
                                                    .foregroundStyle(vm.alternateColors ? OFF_WHITE : OFF_BLACK)
                                                    .offset(x: USERNAME_OFFSET)
                                                
                                                if let tupleEnder = vm.playerNames[fourthTupleEnd...].dropFirst().firstIndex(of: ")") {
                                                    
                                                    // parsing win Count
                                                    if let secondSeparator = vm.playerNames[elementSeparator...].dropFirst().firstIndex(of: ","){
                                                        
                                                        let winCountStart = vm.playerNames.index(after: elementSeparator)
                                                        let winCountEnd = vm.playerNames.index(before: secondSeparator)
                                                        let winCount = String(vm.playerNames[winCountStart...winCountEnd])
                                                        Text(winCount)
                                                            .font(.system(size: COLUMN_DATA_TEXT_SIZE, design: .rounded))
                                                            .foregroundStyle(vm.alternateColors ? OFF_WHITE : OFF_BLACK)
                                                            .offset(x: WIN_OFFSET)
                                                        
                                                        // parsing lowest score
                                                        let lowestScoreStart = vm.playerNames.index(after: secondSeparator)
                                                        let lowestScoreEnd = vm.playerNames.index(before: tupleEnder)
                                                        let lowestScore = String(vm.playerNames[lowestScoreStart...lowestScoreEnd])
                                                        Text(lowestScore)
                                                            .font(.system(size: COLUMN_DATA_TEXT_SIZE, design: .rounded))
                                                            .foregroundStyle(vm.alternateColors ? OFF_WHITE : OFF_BLACK)
                                                            .offset(x: HIGHSCORE_OFFSET)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }   
                    
                    // Home Button to Exit
                    ZStack{
                        RoundedRectangle(cornerRadius: CORNER_RADIUS)
                            .stroke(Color.black,lineWidth: 8)
                            .fill(vm.getSideButtonColor(alternateColor: vm.alternateColors))
                            .frame(width: HOME_STATS_BUTTONS_WIDTH, height: HOME_STATS_BUTTONS_HEIGHT)
                            .padding(8)
                            .onTapGesture {
                                print("Going back to the home screen")
                                gameState = .homeScreen
                            }
                        Text("Home")
                            .font(.system(size: HOME_STATS_BUTTONS_TEXT_SIZE, design: .rounded).bold())
                            .foregroundStyle(vm.alternateColors ? OFF_WHITE : OFF_BLACK)
                            .onTapGesture {
                                print("Going back to the home screen")
                                gameState = .homeScreen
                            }
                    }
                    .offset(x: GAMESTATS_HOME_X_OFFSET)
                    
                    // Reset Button to Reset Stats
                    ZStack{
                        RoundedRectangle(cornerRadius: CORNER_RADIUS)
                            .stroke(Color.black,lineWidth: 8)
                            .fill(vm.getSideButtonColor(alternateColor: vm.alternateColors))
                            .frame(width: HOME_STATS_BUTTONS_WIDTH, height: HOME_STATS_BUTTONS_HEIGHT)
                            .padding(8)
                            .onTapGesture {
                                print("Reseting Game Stats")
                                vm.playerNames = ""
                            }
                        Text("Reset Statistics")
                            .font(.system(size: RESET_STATS_BUTTONS_TEXT_SIZE, design: .rounded).bold())
                            .foregroundStyle(vm.alternateColors ? OFF_WHITE : OFF_BLACK)
                            .onTapGesture {
                                print("Reseting Game Stats")
                                vm.playerNames = ""
                            }
                    }
                    .offset(x: GAMESTATS_HOME_X_OFFSET)
                }
                .offset(x: COLUMN_X_OFFSET, y: COLUMN_Y_OFFSET)
            }
        }
    }
}
