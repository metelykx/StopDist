//
//  CarView.swift
//  StopDist
//
//  Created by Denis Ivaschenko on 25.06.2025.
//

import SwiftUI

struct CarView: View {
    var tireType: TireType
    
    var body: some View {
        HStack(spacing: 0) {
            Image(systemName: "car.fill")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            
            Image(systemName: tireType == .summer ? "sun.max.fill" : "snowflake")
                .font(.system(size: 20))
                .foregroundColor(tireType == .summer ? .yellow : .blue)
                .offset(x: -25, y: -15)
        }
    }
}
