import SwiftUI

struct RoadView: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Основное полотно дороги
                RoundedRectangle(cornerRadius: 4)
                    .frame(width: geometry.size.width, height: 8)
                    .foregroundColor(Color.gray)
                
                // Дорожная разметка
                HStack(spacing: 30) {
                    ForEach(0..<Int(geometry.size.width/40), id: \.self) { _ in
                        Rectangle()
                            .frame(width: 20, height: 3)
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
}
