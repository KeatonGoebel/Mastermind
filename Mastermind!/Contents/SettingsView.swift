//
//  SettingsView.swift
//  Mastermind!
//
//  Created by Keaton Goebel on 4/17/24.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var vm: ViewModel
    @Binding var gameState: ContentView.GameState

    var body: some View {
        
        ZStack {
            
            Rectangle()
                .fill(vm.getBackgroundColor(alternateColor: vm.alternateColors))
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                Text("Settings")
                    .font(.system(size: HOME_BUTTONS_TEXT_SIZE, design: .rounded).bold())
                    .foregroundStyle(vm.alternateColors ? OFF_WHITE : OFF_BLACK)
                
                HStack {
                    Text("Timer Mode")
                        .font(.system(size: HOME_BUTTON_TOGGLE_TEXT_SIZE, design: .rounded).bold())
                        .foregroundStyle(vm.alternateColors ? OFF_WHITE : OFF_BLACK)
                        .offset(x: SETTINGS_TEXT_OFFSET)
                    .lineLimit(1)
                    Toggle("", isOn: $vm.timerOn)
                        .offset(x: SETTINGS_TOGGLE_OFFSET)
                }
                .padding()
                
                Text("Select a Timer Duration")
                    .font(.system(size: HOME_BUTTON_TOGGLE_TEXT_SIZE, design: .rounded).bold())
                    .foregroundStyle(vm.alternateColors ? OFF_WHITE : OFF_BLACK)
                Picker(selection: $vm.timerDuration, label: Text("")) {
                    Text("10").tag(10.0)
                    Text("15").tag(15.0)
                    Text("20").tag(20.0)
                }
                .pickerStyle(SegmentedPickerStyle())
                .background(Color.gray.opacity(0.5))
                .padding()
                
                HStack {
                    Text("Background Music")
                        .font(.system(size: HOME_BUTTON_TOGGLE_TEXT_SIZE, design: .rounded).bold())
                        .foregroundStyle(vm.alternateColors ? OFF_WHITE : OFF_BLACK)
                        .offset(x: SETTINGS_TEXT_OFFSET)
                    .lineLimit(1)
                    Toggle("", isOn: $vm.backgroundMusicOn)
                        .offset(x: SETTINGS_TOGGLE_OFFSET)
                }
                .padding()
                
                HStack {
                    Text("Win or Lose Sound Effects")
                        .font(.system(size: HOME_BUTTON_TOGGLE_TEXT_SIZE, design: .rounded).bold())
                        .foregroundStyle(vm.alternateColors ? OFF_WHITE : OFF_BLACK)
                        .offset(x: SETTINGS_TEXT_OFFSET)
                    Toggle("", isOn: $vm.winSounds)
                        .offset(x: SETTINGS_TOGGLE_OFFSET)
                }
                .padding()
                
                HStack {
                    Text("Tapping Sound Effects")
                        .font(.system(size: HOME_BUTTON_TOGGLE_TEXT_SIZE, design: .rounded).bold())
                        .foregroundStyle(vm.alternateColors ? OFF_WHITE : OFF_BLACK)
                        .offset(x: SETTINGS_TEXT_OFFSET)
                    .lineLimit(1)
                    Toggle("", isOn: $vm.tappingSounds)
                        .offset(x: SETTINGS_TOGGLE_OFFSET)
                }
                .padding()
                
                HStack {
                    Text("Alternate Colors")
                        .font(.system(size: HOME_BUTTON_TOGGLE_TEXT_SIZE, design: .rounded).bold())
                        .foregroundStyle(vm.alternateColors ? OFF_WHITE : OFF_BLACK)
                        .offset(x: SETTINGS_TEXT_OFFSET)
                    .lineLimit(1)
                    Toggle("", isOn: $vm.alternateColors)
                        .offset(x: SETTINGS_TOGGLE_OFFSET)
                }
                .padding()
                
                ZStack{
                    RoundedRectangle(cornerRadius: CORNER_RADIUS)
                        .stroke(Color.black,lineWidth: 8)
                        .fill(vm.getSideButtonColor(alternateColor: vm.alternateColors))
                        .frame(width: HOME_STATS_BUTTONS_WIDTH, height: HOME_STATS_BUTTONS_HEIGHT)
                        .padding(8)
                        .onTapGesture {
                            print("Going back to the home screen")
                            print(vm.timerDuration)
                            gameState = .homeScreen
                        }
                    Text("Home")
                        .font(.system(size: HOME_STATS_BUTTONS_TEXT_SIZE, design: .rounded).bold())
                        .foregroundStyle(vm.alternateColors ? OFF_WHITE : OFF_BLACK)
                        .onTapGesture {
                            print("Going back to the home screen")
                            vm.remainingTime = vm.timerDuration
                            print(vm.remainingTime)
                            print(vm.timerDuration)
                            gameState = .homeScreen
                        }
                }
            }
        }

    }
}

