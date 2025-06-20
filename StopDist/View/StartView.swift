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
                            .scaledToFit()
                            .frame(width: geometry.size.width * 0.7)
                        
                        Text("StopDist")
                            .font(.custom("LexendDeca-Regular", size: geometry.size.width * 0.12))
                            .foregroundStyle(.white)
                            .padding(.top, geometry.size.height * -(0.05))
                    }.padding(.bottom, geometry.size.height*0.18)
                    
                    Spacer()
                    MetelykxView()
                        .font(.custom("LexendDeca-Regular", size: geometry.size.width * 0.045))
                        .padding(.bottom, geometry.size.height * 0.01)
                }
                .frame(width: geometry.size.width)
            }
        }
    }
}
//-MARK: struct Metelykx
struct MetelykxView: View {
    
    var body: some View {

            VStack {
                Text("from")
                    .foregroundStyle(.white)
                
                Text("metelykx")
                    .foregroundStyle(Color("colorMetelykx"))
        }
    }
}


#Preview {
    StartView()
}
