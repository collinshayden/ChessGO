//
//  FirebaseService.swift
//  ChessUI
//
//  Created by Evan Rohan on 10/9/24.
//

import FirebaseFirestore
import FirebaseCore
import FirebaseAuth

//returns puzzleID based on rating range
//tasks
class FireBaseService: ObservableObject{
    
    var userSession: FirebaseAuth.User!
    var firebaseAuth: Auth!
    var db: Firestore!
    @Published var currentUser: String!
    @Published var isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
    
    init() {
        self.currentUser = nil
        self.firebaseAuth = Auth.auth()
        if let user = self.firebaseAuth.currentUser {
            self.currentUser = user.email
        }
        db = Firestore.firestore()
    }
    //also set up userInfo on firebase
    func createAccount(_ username: String) async throws {
      do {
        print("trying create with \(username)")
        let authResult = try await firebaseAuth.createUser(withEmail: "\(username)@chess.com", password: "chess123")
        self.userSession = authResult.user
        if let session = userSession {
        print("createUser success: \(session)")
        DispatchQueue.main.async {
        self.currentUser = session.email
        self.isLoggedIn = true
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        UserDefaults.standard.set(username, forKey: "username")
          }
        try await db.collection("users").document("\(username)").setData([
                "username" : username,
                "elo" : 400,
                "correct" : 0,
                "incorrect" : 0,
                "tactics" : []
            ])
        
        }
      } catch {
        print("Error registering user or saving user data: \(error.localizedDescription)")
        throw DBError.registrationFailed(errorMessage: error.localizedDescription)
      }
    }
    
    func signIn(_ username : String) async throws {
      do {
        print("trying signin with |\(username)")
        let loginResult = try await firebaseAuth.signIn(withEmail: "\(username)@chess.com", password: "chess123")
        self.userSession = loginResult.user
        if let us = userSession {
            print("signIn successful: \(us)")
            DispatchQueue.main.async {
            self.currentUser = us.email
            self.isLoggedIn = true
          }
        }
      } catch {
        print("login failed for email \(username)")
        throw DBError.loginFailed(errorMessage: error.localizedDescription)
      }
    }
    
    func validUsername(_ username : String) async -> Bool{
        do{
            let check = try await db.collection("users").whereField("username", isEqualTo: username).getDocuments()
            if(check.isEmpty){
                print("Validation Successful!")
            }else{
                print("Username already exists.")
            }
                return check.isEmpty
        }catch{
            print("error in accessing user validation")
            return false
        }
    }
    //maybe add throw
    //hayden needs to do tasks
    func getPuzzle(_ min : Int , _ max : Int) async -> [String]{
        let puzzles = db.collection("puzzles")
            var choices : [[String]] = []
            do{
                let querySnapshot = try await puzzles.whereField("rating", isGreaterThan: min).whereField("rating", isLessThan: max).getDocuments()
                
                for puzzles in querySnapshot.documents{
                    //return FEN, rating, moves instead
                    let dict = puzzles.data()
                    let rating = (dict["Rating"]) as! Int
                    let FEN = dict["FEN"] as! String
                    let Moves = dict["Moves"] as! String
                    
                    choices.append([String(rating),FEN,Moves])
                }
            }catch{
                print("error getting puzzles")
            }
            
            return choices[0]
    }

}

