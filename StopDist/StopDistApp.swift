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
    
    @State var isAppActive: Bool = true
    var body: some Scene {
        
        WindowGroup {
            ContentView()
        }
    }
}
