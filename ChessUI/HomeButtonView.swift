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
    
    var body: some View {
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
                ForEach(["gear", "person.fill", "chart.bar.fill"], id: \.self) { imageName in
                    DefaultButtonView(buttonImage: imageName, action: {})
                        .padding(.bottom, 5)
                        .offset(y: buttonOffset) // Start just below the X button
                }
                DefaultButtonView(buttonImage: "xmark", action: {}).padding(.bottom, 20)
                
                
                
            }
        }.onAppear{
                gradientOffset = 0
                buttonOffset = 0
        }
    }
}

#Preview {
    HomeButtonView()
}
