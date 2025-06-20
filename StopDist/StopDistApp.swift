//
//  StopDistApp.swift
//  StopDist
//
//  Created by Denis Ivaschenko on 20.06.2025.
//

import SwiftUI

@main
struct StopDistApp: App {
    
    //create variables in order to monitor changes in the lifecycle of the mobile application
    @Environment(\.scenePhase) var scenePhase
    
    //to track what to show
    @State var isAppActive: Bool = true
    var body: some Scene {
        WindowGroup {
            ZStack {
                
                //add Views
                ContentView()
                    .opacity(isAppActive ? 1:0)
                    .animation(.default, value: isAppActive)
                
                StartView()
                    .opacity(isAppActive ? 0:1)
                    .animation(.default, value: isAppActive)
            }
        }.onChange(of: scenePhase) { newValue in
            switch newValue {
            case .active:
                self.isAppActive = true
            case .inactive:
                self.isAppActive = false
            @unknown default:
                break
            }
        }
    }
}
