//
// EnterKey.swift
// Mastermind!
//
// Created by Keaton Goebel on 2/7/24.
//
//
import Foundation
import SwiftUI

struct EnterKeyState: View {
    var isRowFull: Bool
    var viewModel: ViewModel
    var currentRow: Int
    var onGameTwo: Bool
    @Binding var alternateColors : Bool
    
    var body: some View {
        return makeEnterKeyBody(isRowFull: isRowFull, viewModel: viewModel, currentRow: currentRow, onGameTwo: onGameTwo, alternateColors: alternateColors)
    }
}

func makeEnterKeyBody(isRowFull: Bool, viewModel: ViewModel, currentRow: Int, onGameTwo: Bool, alternateColors: Bool) -> some View {
    
    let isRowFull = isRowFull ? true : false
    
    // case 1: the row is not full, black
    if isRowFull == false {
        return ZStack {
            RoundedRectangle(cornerRadius: CORNER_RADIUS)
                .stroke(Color.black,lineWidth: 12)
                .fill(viewModel.getSideButtonColor(alternateColor: alternateColors))
                .padding(5)
            Text("Enter")
                .foregroundStyle(viewModel.alternateColors ? OFF_WHITE : OFF_BLACK)
                .bold()
                .font(.system(size: 15, design: .rounded).bold())
                .padding(1)
            
        }
        .onTapGesture{
        }
    }
    
    // case 2: the row is full and its the current row, red
    else if isRowFull == true && viewModel.currentRowNumber == currentRow{
        return ZStack {
            RoundedRectangle(cornerRadius: CORNER_RADIUS)
                .stroke(SOFT_RED,lineWidth: 12)
                .fill(viewModel.getSideButtonColor(alternateColor: alternateColors))
                .padding(5)
            Text("Enter")
                .foregroundStyle(viewModel.alternateColors ? OFF_WHITE : OFF_BLACK)
                .bold()
                .font(.system(size: 15, design: .rounded).bold())
                .padding(1)
            
        }
        .onTapGesture{
            if viewModel.selectionOn {
                viewModel.m.redCountList[currentRow] = viewModel.countRedBeads()
                viewModel.m.whiteCountList[currentRow] = viewModel.countWhiteBeads()
                viewModel.nextRow()
                viewModel.restartTimer()
                if viewModel.tappingSounds {
                    let audiomanagerLocal = AudioManager()
                    audiomanagerLocal.playEnterKey()
                }
                
                if onGameTwo == false {
                    viewModel.changePlayer2Score(score: viewModel.reverseRow(oldRow: viewModel.currentRowNumber))
                }
                else{
                    viewModel.changePlayer1Score(score: viewModel.reverseRow(oldRow: viewModel.currentRowNumber))
                }
                
                if TEST_MODE {
                    
                    // unwrapping optionals and matching up the correct bead with the color in its index
                    if let secretCode = viewModel.userGuesses.last{
                        for guesses in 0..<secretCode.guessItem.count{
                            if let guessValue = secretCode.guessItem[guesses]{
                                viewModel.changeBeadColor(IndexOfBead: guesses + 1, IndexOfNewColor: guessValue)
                            }
                        }
                    }
                    print("TEST MODE: The secret code is  \(viewModel.m.b1) \(viewModel.m.b2) \(viewModel.m.b3) \(viewModel.m.b4)")
                }
            }
        }
    }
    
    // case 3, the row is full but its not the right row, black
    else {
        return ZStack {
            RoundedRectangle(cornerRadius: CORNER_RADIUS)
                .stroke(Color.black,lineWidth: 12)
                .fill(viewModel.getSideButtonColor(alternateColor: alternateColors))
                .padding(5)
            Text("Enter")
                .foregroundStyle(viewModel.alternateColors ? OFF_WHITE : OFF_BLACK)
                .bold()
                .font(.system(size: 15, design: .rounded).bold())
                .padding(1)
            
        }
        .onTapGesture{
        }
    }
}
