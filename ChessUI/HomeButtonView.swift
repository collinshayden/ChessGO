//
//  HomeButtonView.swift
//  ChessUI
//
//  Created by Evan Rohan on 10/21/24.
//

import SwiftUI

struct HomeButtonView : View {
    
    @State private var buttonOffset: CGFloat = 200
    @State private var gradientOffset = UIScreen.main.bounds.height
    @State private var showMap = false
    @State private var showSettings = false
    @State private var showStats = false
    @State private var showProfile = false
    
  
    var body: some View {
        if showMap{
            MapView()
        }else if showSettings{
            SettingsView()
        }else if showStats{
            StatsView()
        }else if showProfile{
            ProfileView()
        }
        else{
            
            ZStack{
                LinearGradient(
                    gradient: Gradient(colors: [
                        colors.darkGreen,
                        colors.vermontGreen,
                        colors.lightGreen
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                ).ignoresSafeArea()
                    .offset(y: gradientOffset) // Control the vertical position for animation
                    .animation(.easeInOut(duration: 0.5), value: gradientOffset) // Animation effect
                
                VStack{
                    Spacer()
                    DefaultButtonView(buttonImage: "gear", action: { showSettings = true})
                            .padding(.bottom, 5)
                            .offset(y: buttonOffset + 15)
    
                    DefaultButtonView(buttonImage: "person.fill", action: { showProfile = true})
                        .padding(.bottom, 5)
                        .offset(y: buttonOffset + 10)
                    DefaultButtonView(buttonImage: "chart.bar.fill", action: {showStats = true})
                        .padding(.bottom, 5)
                        .offset(y: buttonOffset + 5)
                    DefaultButtonView(buttonImage: "xmark", action: {print("showMap") ; showMap = true}).padding(.bottom, 20)
                    
                    
                    
                }
            }.onAppear{
                gradientOffset = 0
                buttonOffset = 0
            }
        }
    }
}

#Preview {
    HomeButtonView()
}
