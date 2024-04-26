//
//  SetCodeViews.swift
//  Mastermind!
//
//  Created by Keaton Goebel on 3/22/24.
//

import Foundation
import SwiftUI

struct Player1CodeView: View {
    @Binding var player1Name: String
    @Binding var player2Name: String
    @Binding var showPlayer1CodeView: Bool
    @Binding var showPlayer2CodeView: Bool
    @Binding var firstCodeSet: Bool
    @Binding var selectedColor: Int
    @ObservedObject var vmLocal: ViewModel
    
    @State var selectColors: [Color] = [.white,.white,.white,.white]
    @State var selectColorsIndex: [Int] = [-1,-1,-1,-1]
    
    var body: some View {
        
        ZStack{
            
            // structure is player name, HStack of beads, submit button, and skip button
            RoundedRectangle(cornerRadius: CORNER_RADIUS)
                .stroke(OVERVIEW_STROKE,lineWidth: 15)
                .fill(vmLocal.getOverviewColor(alternateColor: vmLocal.alternateColors))
                .frame(width: TWO_PLAYER_OVERLAY_WINDOW_WIDTH, height: TWO_PLAYER_OVERLAY_WINDOW_HEIGHT)
            
            VStack{
                Text(" \(vmLocal.getPlayer1Name()) \n Please Select a Code")
                    .font(.system(size: 25, design: .rounded).bold())
                    .foregroundStyle(vmLocal.alternateColors ? OFF_WHITE : OFF_BLACK)
                    .padding()
                
                HStack(spacing: 15){
                    
                    ForEach(0..<4) { index in
                        Circle()
                            .fill(selectColors[index])
                            .stroke(Color.black, lineWidth: 6)
                            .frame(width: CODE_CIRCLE_WIDTH, height: CODE_CIRCLE_HEIGHT)
                            .onTapGesture {
                                if selectedColor != -1 {
                                    selectColors[index] = BUTTON_OPTIONS[selectedColor]
                                    selectColorsIndex[index] = selectedColor
                                    
                                    if vmLocal.tappingSounds {
                                        let audiomanagerLocal = AudioManager()
                                        audiomanagerLocal.playBeadPress()
                                    }
                                    
                                }
                                print(selectedColor)
                            }
                    }
                }
                
                Text(" Submit ")
                    .font(.system(size: 20, design: .rounded).bold())
                    .foregroundStyle(vmLocal.alternateColors ? OFF_WHITE : OFF_BLACK)
                    .onTapGesture {
                    
                    // players can only submit their code if they have inputted a full code. That means they have changed the color of all four beads at least once. Inputting a code also causes a reset of the game to prevent to make sure all the beads on the game board are blank
                    if !selectColors.contains(.white) {
                        
                        print(selectColors)
                        print(selectColorsIndex)
                        
                        
                        vmLocal.changeBeadColor(IndexOfBead: 1, IndexOfNewColor: selectColorsIndex[0])
                        vmLocal.changeBeadColor(IndexOfBead: 2, IndexOfNewColor: selectColorsIndex[1])
                        vmLocal.changeBeadColor(IndexOfBead: 3, IndexOfNewColor: selectColorsIndex[2])
                        vmLocal.changeBeadColor(IndexOfBead: 4, IndexOfNewColor: selectColorsIndex[3])
                        
                        showPlayer1CodeView.toggle()
                        showPlayer2CodeView.toggle()
                        firstCodeSet = true
                        
                        if vmLocal.timerOn {
                            vmLocal.startTimer()
                        }
                    }
                    else {
                        print("Cannot Submit code not complete!")
                    }
                }
                
                Text(" Skip ")
                    .font(.system(size: 20, design: .rounded).bold())
                    .foregroundStyle(vmLocal.alternateColors ? OFF_WHITE : OFF_BLACK)
                    .padding()
                    .onTapGesture {
                        
                        showPlayer1CodeView.toggle()
                        showPlayer2CodeView.toggle()
                        firstCodeSet = true
                        if vmLocal.timerOn {
                            vmLocal.startTimer()
                        }
                    }
            }
            .padding()
        }
        .transition(.move(edge: .trailing))
    }
    
}

struct Player2CodeView: View {
    @Binding var player1Name: String
    @Binding var player2Name: String
    @Binding var showPlayer2CodeView: Bool
    @Binding var secondCodeSet: Bool
    @Binding var selectedColor: Int
    @ObservedObject var vmLocal: ViewModel
    
    @State var selectColors: [Color] = [.white,.white,.white,.white]
    @State var selectColorsIndex: [Int] = [-1,-1,-1,-1]
    
    var body: some View {
        
        ZStack{
            
            // structure is player name, HStack of beads, submit button, and skip button
            RoundedRectangle(cornerRadius: CORNER_RADIUS)
                .stroke(OVERVIEW_STROKE,lineWidth: 15)
                .fill(vmLocal.getOverviewColor(alternateColor: vmLocal.alternateColors))
                .frame(width: TWO_PLAYER_OVERLAY_WINDOW_WIDTH, height: TWO_PLAYER_OVERLAY_WINDOW_HEIGHT)
            
            VStack{
                Text(" \(vmLocal.getPlayer2Name()) \n Please Select a Code")
                    .font(.system(size: 25, design: .rounded).bold())
                    .foregroundStyle(vmLocal.alternateColors ? OFF_WHITE : OFF_BLACK)
                    .padding()
                
                HStack(spacing: 15){
                    
                    ForEach(0..<4) { index in
                        Circle()
                            .fill(selectColors[index])
                            .stroke(Color.black, lineWidth: 6)
                            .frame(width: CODE_CIRCLE_WIDTH, height: CODE_CIRCLE_HEIGHT)
                            .onTapGesture {
                                if selectedColor != -1 {
                                    selectColors[index] = BUTTON_OPTIONS[selectedColor]
                                    selectColorsIndex[index] = selectedColor
                                    
                                    if vmLocal.tappingSounds {
                                        let audiomanagerLocal = AudioManager()
                                        audiomanagerLocal.playBeadPress()
                                    }
                                }
                            }
                    }
                }
                
                Text(" Submit ")
                    .font(.system(size: 20, design: .rounded).bold())
                    .foregroundStyle(vmLocal.alternateColors ? OFF_WHITE : OFF_BLACK)
                    .onTapGesture {
                    
                    // players can only submit their code if they have inputted a full code. That means they have changed the color of all four beads at least once. Inputting a code also causes a reset of the game to prevent to make sure all the beads on the game board are blank
                    if !selectColors.contains(.white) {
                        
                        print(selectColors)
                        print(selectColorsIndex)
                        
                        print(vmLocal.getPlayer1Score())
                        
                        vmLocal.changeBeadColor(IndexOfBead: 1, IndexOfNewColor: selectColorsIndex[0])
                        vmLocal.changeBeadColor(IndexOfBead: 2, IndexOfNewColor: selectColorsIndex[1])
                        vmLocal.changeBeadColor(IndexOfBead: 3, IndexOfNewColor: selectColorsIndex[2])
                        vmLocal.changeBeadColor(IndexOfBead: 4, IndexOfNewColor: selectColorsIndex[3])
                        
                        showPlayer2CodeView.toggle()
                        secondCodeSet = true
                        
                        if vmLocal.timerOn {
                            vmLocal.startTimer()
                        }
                    }
                    else {
                        print("Cannot Submit code not complete!")
                    }
                }
                
                Text(" Skip ")
                    .font(.system(size: 20, design: .rounded).bold())
                    .foregroundStyle(vmLocal.alternateColors ? OFF_WHITE : OFF_BLACK)
                    .padding()
                    .onTapGesture {
                        
                        showPlayer2CodeView.toggle()
                        secondCodeSet = true
                        
                        if vmLocal.timerOn {
                            vmLocal.startTimer()
                        }
                    }
            }
            .padding()
            
        }
    }
    
}



