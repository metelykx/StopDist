//
//  StartView.swift
//  StopDist
//
//  Created by Denis Ivaschenko on 20.06.2025.
//

import SwiftUI

//-MARK: struct StartView
struct StartView: View {
    var body: some View {
        GeometryReader { geometry in
            
            ZStack {
                Color("background", bundle: nil).ignoresSafeArea()
                
                
                VStack {
                    Spacer()
                    VStack {
                        Image("emblema", bundle: nil)
                            .resizable()
                            .frame(width: 300, height: 300)
                        
                        Text("StopDist")
                            .font(.custom("LexendDeca-Regular", size: 40))
                            .foregroundStyle(.white)
                            .padding(.top, -45)
                    }.padding(.bottom, 120)
                    
                    Spacer()
                    MetelykxView().padding(.bottom, 10)
                }
            }
        }
    }
}
//-MARK: struct Metelykx
struct MetelykxView: View {
    var body: some View {
        VStack {
            Text("from").font(.custom("LexendDeca-Regular", size: 20))
                .foregroundStyle(.white)
            
            
            Text("metelykx").font(.custom("LexendDeca-Regular", size: 20))
                .foregroundStyle(Color("colorMetelykx"))
        }
    }
}

#Preview {
    StartView()
}
