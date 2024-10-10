//
//  DBError.swift
//  ChessUI
//
//  Created by Evan Rohan on 10/9/24.
//
//

import Foundation

//Custom Error Code
enum DBError: Error {
  case registrationFailed(errorMessage: String)
  case loginFailed(errorMessage: String)
  case fetchFailed(errorMessage: String)
}

