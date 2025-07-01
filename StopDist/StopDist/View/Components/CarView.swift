import SwiftUI

struct CarView: View {
    var tireType: TireType
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Основная иконка машины
            Image(systemName: "car.fill")
                .font(.system(size: 40))
                .foregroundColor(.blue)
            
            // Маркер типа резины
            Image(systemName: tireType == .summer ? "sun.max.fill" : "snowflake")
                .font(.system(size: 14))
                .foregroundColor(tireType == .summer ? .yellow : .blue)
                .padding(5)
                .background(Circle().fill(Color.white))
                .offset(x: -8, y: 4)
        }
        .compositingGroup()
        .shadow(radius: 2)
    }
}
