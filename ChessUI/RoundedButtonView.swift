//
//  RoundedButtonView.swift
//  VocabTest
//
//  Created by Jason Hibbeler on 12/3/23.
//

import SwiftUI

struct RoundedButtonView: View {
  var buttonText: String = ""
  var action: () -> Void
  var width: CGFloat = 150
  var height: CGFloat = 50
  var foregroundColor = Color.white
  var backgroundColor = LinearGradient(
    gradient: Gradient(colors: [
        colors.darkGreen,
        colors.vermontGreen
    ]),
    startPoint: .top,
    endPoint: .bottom
)

  var body: some View {
    Button(action: action) {
      Text(buttonText)
        .font(.custom("League Spartan", size: 32))
        .frame(width: width, height: height) .foregroundColor(foregroundColor) .background(backgroundColor)
        .cornerRadius(10)
    }
  }
}

#Preview {
  RoundedButtonView(buttonText: "Next", action: {})
}
