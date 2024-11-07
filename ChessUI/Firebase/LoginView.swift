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
    
    @State private var username: String = ""
    @State private var error: String? = nil
    var body: some View {
        VStack {
                
                Image("ChessGo").resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 400, height: 400)
            
                Spacer()
            
                VStack{
                    TextField("Welcome! Enter a Username", text: $username).padding().background(colors.gray.opacity(0.5)).autocorrectionDisabled()
                        .font(.custom("League Spartan", size: 22))
                        .foregroundColor(colors.black)
                        .cornerRadius(10)
                    
                    if let message = error { Text("\(message)").foregroundColor(.red) }
                }
            Spacer()
            RoundedButtonView(buttonText: "Sign Up" , action: {
                Task{
                    error = await CreateAccount(fireBaseService, username)
                }
            }
            )
        }
        .padding(50)

    }
}


func CreateAccount(_ fireBaseService : FireBaseService, _ username : String) async -> String?
{
        do{
            if (await fireBaseService.validUsername(username)){
                try await fireBaseService.createAccount(username)
                return nil
            }else{
                return "Username already exists."
            }
        }
        catch{
            return "Error Creating an Account"
        }
}
#Preview {
    LoginView()
    .environmentObject(FireBaseService())
}

