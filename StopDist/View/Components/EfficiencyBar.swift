//
//  EfficiencyBar.swift
//  StopDist
//
//  Created by Denis Ivaschenko on 25.06.2025.
//

import SwiftUI

struct EfficiencyBar: View {
    var value: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width, height: 10)
                    .opacity(0.3)
                    .foregroundColor(Color.gray)
                
                Rectangle()
                    .frame(width: min(CGFloat(value) * geometry.size.width, geometry.size.width), height: 10)
                    .foregroundColor(colorForEfficiency(value))
                    .animation(.linear, value: value)
            }
            .cornerRadius(5)
        }
        .frame(height: 10)
    }
    
    private func colorForEfficiency(_ value: Double) -> Color {
        switch value {
        case ..<0.6: return .red
        case 0.6..<0.8: return .orange
        case 0.8..<0.95: return .yellow
        default: return .green
        }
    }
}
