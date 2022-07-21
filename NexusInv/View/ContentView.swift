//
//  ContentView.swift
//  NexusInv
//
//  Created by Elias Abunuwara on 2022-07-15.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    @EnvironmentObject var model : ViewModel
    
    var body: some View {
        NavigationView {
            if model.signedIn {
                AccessView()
                    .environmentObject(model)
            }
            else {
                LogInView()
                    .environmentObject(model)
            }
        }
        .onAppear {
            model.signedIn = model.isSignedIn
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// hide keyboard if user clicks outside form
#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

// an abstract of the log in view
struct LogInView: View {
    @EnvironmentObject var model: ViewModel
    
    @StateObject private var keyboardHandler = KeyboardHandler()
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        VStack {
            Form {
                Image("logo-cropped")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                TextField("דוא״ל", text: $email)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding()
                SecureField("סיסמה", text: $password)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding()
                Section {
                    // sign in button
                    Button(action: {
                        model.signIn(email: email, password: password)
                    }) {
                        Spacer()
                        Text("התחבר")
                        Spacer()
                    }
                    .buttonStyle(PlainButtonStyle())
                    .foregroundColor(Color(UIColor.systemBlue))
                    .disabled(email.isEmpty || password.isEmpty)
                }
            }
        }
        .alert(isPresented: $model.loginError) {
            Alert(title: Text("Incorrect email or password"))
        }
        // keyboard avoidance - push form up
    }
    
}

// an abstract of access view

struct AccessView: View {
    
    @EnvironmentObject var model : ViewModel
    
    @State var showingScanner = false
    @State var showingList = false
    @State var showingSettings = false
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            VStack{
                Image("logo-cropped")
                    .resizable()
                    .padding([.top, .leading, .trailing])
                    .aspectRatio(contentMode: .fit)
                
                Spacer()
                
                // open scanner button
                VStack (alignment: .leading){
                    Spacer ()
                    Spacer()
                    Spacer()
                    
                    // scanner button
                    Button(action: {
//                        model.getIden(collection: "Suppliers")
//                        model.getIden(collection: "Customers")
//                        model.getIden(collection: "Brands")
                        model.getAll()
                        self.model.showItemOptions = false
                        self.showingScanner.toggle()
                    }) {
                        Image(systemName: "barcode.viewfinder")
                            .resizable()
                            .frame(width: 45.0, height: 45.0)
                        Text("התחל סריקה")
                    }.sheet(isPresented: $showingScanner) {
                            ScannerView()
                                .environmentObject(model)
                                .environment(\.layoutDirection, .rightToLeft)
                    }
                    
                    // items list button
                    Button(action: {
                        model.getData()
                        self.showingList.toggle()
                    }) {
                        Image(systemName: "list.bullet.rectangle")
                            .resizable()
                            .frame(width: 45.0, height: 45.0)
                        Text("מלאי")
                    }.sheet(isPresented: $showingList) {
                        if model.showLoadingItemOptions {
                            LoadingView()
                        }
                        else {
                            ItemsListView()
                                .environmentObject(model)
                                .environment(\.layoutDirection, .rightToLeft)
                        }
                    }
                    
                    // settings
                    Button(action: {
//                        model.getIden(collection: "Suppliers")
//                        model.getIden(collection: "Customers")
//                        model.getIden(collection: "Brands")
                        model.getAll()
                        self.showingSettings.toggle()
                    }) {
                        Image(systemName: "gearshape")
                            .resizable()
                            .frame(width: 45.0, height: 45.0)
                        Text("הגדרות")
                    }.sheet(isPresented: $showingSettings) {
                        SettingsView()
                            .environmentObject(model)
                            .environment(\.layoutDirection, .rightToLeft)
                    }

                    
                    // sign out button
                    Button(action: {
                        model.signOut()
                    }) {
                        Image(systemName: "arrow.backward.square")
                            .resizable()
                            .frame(width: 45.0, height: 45.0)
                        Text("התנתק")
                    }
                    
                    Spacer()
                    Spacer()
                    Spacer()
                }
            }
        }
    }
}


// keyboard avoidance code, source: (https://stackoverflow.com/questions/56491881/move-textfield-up-when-the-keyboard-has-appeared-in-swiftui)

//struct AdaptsToKeyboard: ViewModifier {
//    @State var currentHeight: CGFloat = 0
//
//    func body(content: Content) -> some View {
//        GeometryReader { geometry in
//            content
//                .padding(.bottom, self.currentHeight)
//                .onAppear(perform: {
//                    NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillShowNotification)
//                        .merge(with: NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillChangeFrameNotification))
//                        .compactMap { notification in
//                            withAnimation(.easeOut(duration: 0.16)) {
//                                notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
//                            }
//                    }
//                    .map { rect in
//                        rect.height - geometry.safeAreaInsets.bottom
//                    }
//                    .subscribe(Subscribers.Assign(object: self, keyPath: \.currentHeight))
//
//                    NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillHideNotification)
//                        .compactMap { notification in
//                            CGFloat.zero
//                    }
//                    .subscribe(Subscribers.Assign(object: self, keyPath: \.currentHeight))
//                })
//        }
//    }
//}
//
//extension View {
//    func adaptsToKeyboard() -> some View {
//        return modifier(AdaptsToKeyboard())
//    }
//}
