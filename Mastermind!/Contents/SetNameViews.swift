//
//  SetNameViews.swift
//  Mastermind!
//
//  Created by Keaton Goebel on 3/21/24.
//

import Foundation
import SwiftUI

struct Player1NameView: View {
    @Binding var player1Name: String
    @Binding var showPlayer1NameView: Bool
    @Binding var showPlayer2NameView: Bool
    @ObservedObject var vmLocal: ViewModel
    
    var body: some View {
        
        ZStack{
            
            // structure is player name, textfield, submit button, and skip button
            RoundedRectangle(cornerRadius: CORNER_RADIUS)
                .stroke(OVERVIEW_STROKE,lineWidth: 15)
                .fill(vmLocal.getOverviewColor(alternateColor: vmLocal.alternateColors))
                .frame(width: TWO_PLAYER_OVERLAY_WINDOW_WIDTH, height: TWO_PLAYER_OVERLAY_WINDOW_HEIGHT)
            
            VStack{
                Text(" \(vmLocal.getPlayer1Name()) \n Enter A Username")
                    .font(.system(size: 30, design: .rounded).bold())
                    .foregroundStyle(vmLocal.alternateColors ? OFF_WHITE : OFF_BLACK)
                    .padding()
                TextField("Enter A Username", text: $player1Name)
                    .frame(width: TEXT_BOX_WIDTH)
                    .background(.white)
                    .border(.black)
                    .disableAutocorrection(true)
                    .foregroundColor(.black)
                    .onChange(of: player1Name, initial: true) { newValue, _ in
                        if newValue.count > 10 {
                            player1Name = String(newValue.prefix(10))
                        }
                    }
                
                // if name is empty it submits Player 1, same logic for skip button. This is to prevent players from submitting an empty string for their name
                Text(" Submit ")
                    .font(.system(size: 20, design: .rounded).bold())
                    .foregroundStyle(vmLocal.alternateColors ? OFF_WHITE : OFF_BLACK)
                    .onTapGesture {
                    if player1Name.isEmpty{
                        vmLocal.changePlayer1Name(PlayerName: "Player 1")
                        print("Player1Name = \(vmLocal.getPlayer1Name())")
                        showPlayer1NameView.toggle()
                        withAnimation{
                            showPlayer2NameView.toggle()
                        }
                    }
                    else {
                        vmLocal.changePlayer1Name(PlayerName: player1Name)
                        print("Player1Name = \(vmLocal.getPlayer1Name())")
                        showPlayer1NameView.toggle()
                        withAnimation{
                            showPlayer2NameView.toggle()
                        }
                    }
                }
                
                Text(" Skip ")
                    .font(.system(size: 20, design: .rounded).bold())
                    .foregroundStyle(vmLocal.alternateColors ? OFF_WHITE : OFF_BLACK)
                    .padding()
                    .onTapGesture {
                        print(player1Name)
                        if player1Name.isEmpty {
                            vmLocal.changePlayer1Name(PlayerName: "Player 1")
                        }
                        print("Player1Name = \(vmLocal.getPlayer1Name())")
                        showPlayer1NameView.toggle()
                        withAnimation{
                            showPlayer2NameView.toggle()
                        }
    
                    }
            }
            .padding()
            
        }
    }
    
}

struct Player2NameView: View {
    @Binding var player2Name: String
    @Binding var showPlayer2NameView: Bool
    @Binding var showPlayer1CodeView: Bool
    @Binding var firstCodeSet: Bool
    @ObservedObject var vmLocal: ViewModel
    
    var body: some View {
        
        ZStack{
            
            // structure is player name, textfield, submit button, and skip button
            RoundedRectangle(cornerRadius: CORNER_RADIUS)
                .stroke(OVERVIEW_STROKE,lineWidth: 15)
                .fill(vmLocal.getOverviewColor(alternateColor: vmLocal.alternateColors))
                .frame(width: TWO_PLAYER_OVERLAY_WINDOW_WIDTH, height: TWO_PLAYER_OVERLAY_WINDOW_HEIGHT)
            
            VStack{
                Text(" \(vmLocal.getPlayer2Name()) \n Enter A Username")
                    .font(.system(size: 30, design: .rounded).bold())
                    .foregroundStyle(vmLocal.alternateColors ? OFF_WHITE : OFF_BLACK)
                    .padding()
                TextField("Enter A Username", text: $player2Name)
                    .frame(width: TEXT_BOX_WIDTH)
                    .background(.white)
                    .border(.black)
                    .disableAutocorrection(true)
                    .foregroundColor(.black)
                    .onChange(of: player2Name, initial: true) { newValue, _ in
                        if newValue.count > 10 {
                            player2Name = String(newValue.prefix(10))
                        }
                    }
                
                // if name is empty it submits Player 2, same logic for skip button. This is to prevent players from submitting an empty string for their name
                Text(" Submit ")
                    .font(.system(size: 20, design: .rounded).bold())
                    .foregroundStyle(vmLocal.alternateColors ? OFF_WHITE : OFF_BLACK)
                    .onTapGesture {
                    if player2Name.isEmpty{
                        vmLocal.changePlayer2Name(PlayerName: "Player 2")
                        print("Player2Name = \(vmLocal.getPlayer2Name())")
                        showPlayer2NameView = false
                        
                        if !firstCodeSet{
                            withAnimation{
                                showPlayer1CodeView.toggle()
                            }
                        }
                    }
                    else{
                        vmLocal.changePlayer2Name(PlayerName: player2Name)
                        print("Player2Name = \(vmLocal.getPlayer2Name())")
                        showPlayer2NameView = false
                        
                        if !firstCodeSet{
                            withAnimation{
                                showPlayer1CodeView.toggle()
                            }
                        }
                    }
                        if firstCodeSet && vmLocal.timerOn{
                            vmLocal.startTimer()
                        }
                }
                
                Text(" Skip ")
                    .font(.system(size: 20, design: .rounded).bold())
                    .foregroundStyle(vmLocal.alternateColors ? OFF_WHITE : OFF_BLACK)
                    .padding()
                    .onTapGesture {
                        if player2Name == "" {
                            vmLocal.changePlayer2Name(PlayerName: "Player 2")
                        }
                        print("Player2Name = \(vmLocal.getPlayer2Name())")
                        showPlayer2NameView = false
                        
                        if !firstCodeSet {
                            withAnimation{
                                showPlayer1CodeView.toggle()
                            }
                        }
                        if firstCodeSet && vmLocal.timerOn{
                            vmLocal.startTimer()
                        }
                    }
            }
            .padding()
        }
        .transition(.move(edge: .trailing))
    }
    
}

struct Player1NameViewSinglePlayer: View {
    @Binding var player1Name: String
    @Binding var showPlayer1NameView: Bool
    @ObservedObject var vmLocal: ViewModel
    @Binding var alternateColors: Bool
    
    var body: some View {
        
        ZStack{
            
            // structure is player name, textfield, submit button, and skip button
            RoundedRectangle(cornerRadius: CORNER_RADIUS)
                .stroke(OVERVIEW_STROKE,lineWidth: 15)
                .fill(vmLocal.getOverviewColor(alternateColor: alternateColors))
                .frame(width: TWO_PLAYER_OVERLAY_WINDOW_WIDTH, height: TWO_PLAYER_OVERLAY_WINDOW_HEIGHT)
            
            VStack{
                
                Text(" \(vmLocal.getPlayer1Name()) \n Enter A Username")
                    .font(.system(size: 30, design: .rounded).bold())
                    .foregroundStyle(vmLocal.alternateColors ? OFF_WHITE : OFF_BLACK)
                    .padding()
                TextField("Enter A Username", text: $player1Name)
                    .frame(width: TEXT_BOX_WIDTH)
                    .background(.white)
                    .border(.black)
                    .disableAutocorrection(true)
                    .foregroundColor(.black)
                    .onChange(of: player1Name, initial: true) { newValue, _ in
                        if newValue.count > 10 {
                            player1Name = String(newValue.prefix(10))
                        }
                    }
                
                // if name is empty it submits Player 1, same logic for skip button. This is to prevent players from submitting an empty string for their name
                Text(" Submit ")
                    .font(.system(size: 20, design: .rounded).bold())
                    .foregroundStyle(vmLocal.alternateColors ? OFF_WHITE : OFF_BLACK)
                    .onTapGesture {
                    if player1Name.isEmpty{
                        vmLocal.changePlayer1Name(PlayerName: "Player 1")
                        print("Player1Name = \(vmLocal.getPlayer1Name())")
                    }
                    else {
                        vmLocal.changePlayer1Name(PlayerName: player1Name)
                        print("Player1Name = \(vmLocal.getPlayer1Name())")
                        showPlayer1NameView.toggle()
                        if vmLocal.timerOn {
                            vmLocal.startTimer()
                        }
                    }
                }
                
                Text(" Skip ")
                    .font(.system(size: 20, design: .rounded).bold())
                    .foregroundStyle(vmLocal.alternateColors ? OFF_WHITE : OFF_BLACK)
                    .padding()
                    .onTapGesture {
                        print(player1Name)
                        if player1Name.isEmpty {
                            vmLocal.changePlayer1Name(PlayerName: "Player 1")
                        }
                        print("Player1Name = \(vmLocal.getPlayer1Name())")
                        showPlayer1NameView.toggle()
                        if vmLocal.timerOn {
                            vmLocal.startTimer()
                        }
    
                    }
            }
            .padding()
        }
    }
    
}


