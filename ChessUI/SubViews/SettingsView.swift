//
//  SettingsView.swift
//  ChessUI
//
//  Created by Evan Rohan on 10/22/24.
//

//settings? maybe like change board color or something
import SwiftUI

struct SettingsView : View {
    @EnvironmentObject var settings: Settings
    @Binding var showSettings: Bool
    @Binding var showMap: Bool
    
    // TODO make UI look nicer
    var body : some View {
        
        VStack() {
            Text("Settings").font(.custom("League Spartan", size : 40))
            Spacer()
            
            HStack {
                Text("Puzzle Difficulty").font(.custom("League Spartan", size : 20))
                Picker("Puzzle Difficulty", selection: $settings.puzzleDifficulty) {
                    ForEach(settings.difficulties, id: \.value) { difficulty in
                        Text("\(difficulty.label) (\(formatValue(difficulty.value)))")
                            .tag(difficulty.value)
                    }
                }.accentColor(.white)
            }
            
            HStack {
                Text("Animation Speed").font(.custom("League Spartan", size : 20))
                Picker("Animation Speed", selection: $settings.animationSpeed) {
                    ForEach(settings.animationSpeeds, id: \.value) { speed in
                        Text("\(speed.label) (\(String(format: "%.2f", speed.value))s)")
                            .tag(speed.value)
                    }
                }.accentColor(.white)
            }
            
            HStack {
                Text("Board Theme")
                Picker("Board Theme", selection: $settings.boardTheme) {
                    ForEach(settings.themes, id: \.self) { theme in
                        HStack(spacing: 2) {
                            Rectangle()
                                .fill(theme.lightColor)
                                .frame(width: 35, height: 35)
                                .border(.black)
                            Rectangle()
                                .fill(theme.darkColor)
                                .frame(width: 35, height: 35)
                                .border(.black)
                        }
                    }
                }
                .pickerStyle(.wheel)
            }
            Spacer()
            DefaultButtonView(buttonImage: "xmark", action: { showSettings = false ; showMap = true})
        }
        .padding(20)
        .environment(\.font, .custom("League Spartan", size : 32))
        .foregroundColor(.white)
        .background(LinearGradient(
            gradient: Gradient(colors: [
                colors.darkGreen,
                colors.vermontGreen,
                colors.lightGreen
            ]),
            startPoint: .top,
            endPoint: .bottom
        ))
        
    }
    
    // helper function to add the "+" for positive difficulties
    func formatValue(_ value: Int) -> String {
        value >= 0 ? "+\(value)" : "\(value)"
    }
}

#Preview {
    @State var showSettings = true
    @State var showMap = true
    return SettingsView(showSettings: $showSettings, showMap: $showMap).environmentObject(Settings())
}
