//
//  ContentView_Previews.swift
//  StopDist
//
//  Created by Denis Ivaschenko on 26.06.2025.
//

import SwiftUI

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AppSettings())
    }
}
