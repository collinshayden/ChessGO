//
//  LoginView.swift
//  ChessUI
//
//  Created by Evan Rohan on 10/9/24.
//

import SwiftUI
import FirebaseFirestore

struct LoginView: View {
    
    @EnvironmentObject var fireBaseService : FireBaseService
    let textFieldColor = Color(red:0.2, green: 0.1, blue: 0.5)

    @State private var username: String = ""
    @State private var error: String? = nil
    var body: some View {
        VStack {
                Text("Welcome to ChessGO!")
                
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                
                HStack{
                    Text("Enter a Username:")
                    TextField("i.e. hikaru", text: $username).padding().background(Color.gray.opacity(0.2)).autocorrectionDisabled().onSubmit{
                        Task{
                            do{
                                if (await fireBaseService.validUsername(username)){
                                    try await fireBaseService.createAccount(username)
                                }else{
                                    error = "Username already exists."
                                }
                            }
                            catch{
                                print("Error Creating an Account")
                            }
                        }
                    }
                    
                    if let message = error { Text("\(message)").foregroundColor(.red) }
                }
        }
        .padding()
    }
}

#Preview {
    LoginView()
    .environmentObject(FireBaseService())
}

