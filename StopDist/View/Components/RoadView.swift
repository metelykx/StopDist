//
//  RoadView.swift
//  StopDist
//
//  Created by Denis Ivaschenko on 25.06.2025.
//

import SwiftUI

struct RoadView: View {
    var length: CGFloat
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .frame(width: length, height: 20)
                .foregroundColor(.gray.opacity(0.3))
            
            HStack(spacing: 30) {
                ForEach(0..<Int(length / 40), id: \.self) { _ in
                    Rectangle()
                        .frame(width: 20, height: 4)
                        .foregroundColor(.white)
                }
            }
        }
    }
}
