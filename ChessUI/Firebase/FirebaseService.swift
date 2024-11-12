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
                "elo" : [400],
                "correct" : 0,
                "incorrect" : 0,
                "themes" : [],
                "k" : 250
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
    
    func getPuzzle(_ min : Int , _ max : Int) async -> [String]{
        let randomPuzzleRating = Int.random(in: min...max-15)
        let puzzles = db.collection("puzzles")
            var selectedPuzzle : [String] = []
            do{
                
                let querySnapshot = try await puzzles.whereField("Rating", isGreaterThanOrEqualTo: randomPuzzleRating).whereField("Rating", isLessThanOrEqualTo: max).limit(to: 1).getDocuments()
                
                for puzzle in querySnapshot.documents{
                    let dict = puzzle.data()
                    let Rating = (dict["Rating"]) as! Int
                    let FEN = dict["FEN"] as! String
                    let Moves = dict["Moves"] as! String
                    let Themes = dict["Themes"] as! String
                    
                    selectedPuzzle = [String(Rating), FEN, Moves, Themes]
                }
            }catch{
                print("Error executing query: \(error)")
            }
        return selectedPuzzle
    }
    //returns the user information from firebase in order, username, elo, correct, incorrect, themes
    func getUser() async -> (String,[Int],Int,Int,[String],Int){
        let users = db.collection("users")
        var result : (String,[Int],Int,Int,[String],Int) = ("",[],0,0,[],0)
        //print("User: \(UserDefaults.standard.value(forKey: "username")!)")
        do{
            let querySnapshot = try await users.whereField("username", isEqualTo: UserDefaults.standard.value(forKey: "username")!).getDocuments()
            if let document = querySnapshot.documents.first {
                let dict = document.data()
                result = ((dict["username"]) as! String,(dict["elo"]) as! [Int],(dict["correct"]) as! Int,(dict["incorrect"]) as! Int,(dict["themes"]) as! [String], (dict["k"]) as! Int)
            }
        }catch{
            print("error getting userInfo")
        }
        return result
    }
    
    func updateUserAccount(username : String, elo : [Int], correct : Int, incorrect : Int, themes : [String], k : Int)async -> Bool {
        do {
            try await db.collection("users").document("\(username)").setData([
                "username" : username,
                "elo" : elo,
                "correct" : correct,
                "incorrect" : incorrect,
                "themes" : themes,
                "k" : k
            ])
            return true
        }
        catch {
            print("Error updating user information: \(error.localizedDescription)")
            return false
        }
    }
    
}

