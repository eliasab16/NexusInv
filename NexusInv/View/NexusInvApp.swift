//
//  NexusInvApp.swift
//  NexusInv
//
//  Created by Elias Abunuwara on 2022-07-15.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct NexusInvApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @StateObject var model = ViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(model)
                .environment(\.colorScheme, .light)
                .environment(\.layoutDirection, .rightToLeft)
        }
    }
}
