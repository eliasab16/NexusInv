//
//  SignInView.swift
//  NexusInv
//
//  Created by Elias Abunuwara on 2022-07-15.
//

import SwiftUI
import FirebaseAuth

//class AppViewModel: ObservableObject {
//
//    let auth = Auth.auth()
//
//    var isSignedIn: Bool {
//        return auth.currentUser != nil
//    }
//
//    func signIn(email: String, password: String) {
//        auth.signIn(withEmail: email,
//                    password: password) {result, error in
//            guard result != nil, error == nil else {
//                return
//            }
//
//            // success
//        }
//    }
//}


struct SignInView: View {
    @EnvironmentObject var model: ViewModel
    
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        NavigationView {
                Form {
                    Image("logo-cropped")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                    TextField("Email Address", text: $email)
                        .padding()
                    SecureField("Password", text: $email)
                        .padding()
                    Section {
                        // sign in button
                        Button(action: {
                            model.signIn(email: email, password: password)
                        }) {
                            Spacer()
                            Text("Sign In")
                            Spacer()
                        }
                        .buttonStyle(PlainButtonStyle())
                        .foregroundColor(Color(UIColor.systemBlue))
                        .disabled(email.isEmpty || password.isEmpty)
                    }
                }
                .ignoresSafeArea()
        }
    }
    
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}

