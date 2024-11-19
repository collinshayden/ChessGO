//
//  ProfileView.swift
//  ChessUI
//
//  Created by Evan Rohan on 10/22/24.
//

//tactic badges
import SwiftUI

struct ProfileView : View {
    @EnvironmentObject var profile: Profile
    @Binding var showProfile: Bool
    @Binding var showMap: Bool
    
    
    var body : some View {
        VStack{
            Text("Profile").font(.largeTitle).padding(40)
            Spacer()
            
            HStack{
                Spacer()
                ZStack{
                    Button( action: {
                        profile.pieceChoice -= 1
                    }, label: {
                        Image(systemName: "arrow.left").imageScale(.large).foregroundColor(profile.pieceChoice != 0 ? .white : .gray).opacity(profile.pieceChoice != 0 ? 1 : 0.2)
                    }).disabled(profile.pieceChoice == 0)
                }
                Spacer()
                ZStack{
                    profile.pieces[profile.pieceChoice]
                }.background(colors.lightGreen).cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
                Spacer()
                ZStack{
                    Button( action: {
                        profile.pieceChoice += 1
                    }, label: {
                        Image(systemName: "arrow.right").imageScale(.large).foregroundColor(.white).foregroundColor(profile.pieceChoice != profile.pieces.count - 1 ? .black : .gray).opacity(profile.pieceChoice != profile.pieces.count - 1 ? 1 : 0.2)
                    }).disabled(profile.pieceChoice == profile.pieces.count - 1)
                }
                Spacer()
                
            }.padding()
            Text("Choose your character")
            Spacer()
            Spacer()
            DefaultButtonView(buttonImage: "xmark", action: { showProfile = false ; showMap = true})
        }.padding(20)
            .environment(\.font, .custom("League Spartan", size: 32))
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
}

#Preview {
    @State var showProfile = true
    @State var showMap = true
    return ProfileView(showProfile: $showProfile, showMap: $showMap).environmentObject(Profile())
}

