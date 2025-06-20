//
//  StartView.swift
//  StopDist
//
//  Created by Denis Ivaschenko on 20.06.2025.
//

import SwiftUI

struct StartView: View {
    var body: some View {
        ZStack {
            Color("background", bundle: nil).ignoresSafeArea()
            
            
            VStack {
                Image("emblema", bundle: nil)
                    .resizable()
                    .frame(width: 300, height: 300)
                
                Text("StopDist")
                    .font(.custom("LexendDeca-Regular", size: 40))
                    .foregroundStyle(.white)
            }
        }
    }
}

#Preview {
    StartView()
}
