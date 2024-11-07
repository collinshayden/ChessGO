//
//  DefaultButtonView.swift
//  ChessUI
//
//  Created by Evan Rohan on 10/21/24.
//

import SwiftUI

struct DefaultButtonView : View {
    
    var buttonImage: String = ""
    var action: () -> Void
    var width: CGFloat = 75
    var height: CGFloat = 75
    var foregroundColor = Color.white
    var backgroundColor = LinearGradient(
      gradient: Gradient(colors: [
        colors.orange,
          colors.yellow
      ]),
      startPoint: .top,
      endPoint: .bottom
  )
    
    var body: some View {
        Button(action: action) {
            Image(systemName: buttonImage)
            .font(.custom("League Spartan", size: 32))
            .frame(width: width, height: height) .foregroundColor(foregroundColor) .background(backgroundColor)
            .cornerRadius(100)
        }
    }
}


#Preview {
    DefaultButtonView(buttonImage: "house", action: {})
}
