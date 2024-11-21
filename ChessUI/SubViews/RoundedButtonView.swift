//
//  RoundedButtonView.swift
//
//  Created by Evan Rohan
//

import SwiftUI

struct RoundedButtonView: View {
  var buttonText: String = ""
  var action: () -> Void
  var width: CGFloat = 150
  var height: CGFloat = 50
  var foregroundColor = Color.white
    var backgroundColor = colors.darkGreen

  var body: some View {
    Button(action: action) {
      Text(buttonText)
        .font(.custom("League Spartan", size: 25))
        .frame(width: width, height: height) .foregroundColor(foregroundColor) .background(backgroundColor)
        .cornerRadius(10)
    }
  }
}

#Preview {
  RoundedButtonView(buttonText: "Next", action: {})
}
