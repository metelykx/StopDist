import SwiftUI

struct RoadView: View {
    var length: CGFloat
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .frame(width: length, height: 20)
                .foregroundColor(.gray.opacity(0.3))
            
            // Оптимизированная разметка
            Path { path in
                let segmentLength: CGFloat = 50
                let segments = Int(length / segmentLength)
                
                for i in 0..<segments {
                    let x = CGFloat(i) * segmentLength + 15
                    path.move(to: CGPoint(x: x, y: 10))
                    path.addLine(to: CGPoint(x: x + 20, y: 10))
                }
            }
            .stroke(Color.white, lineWidth: 4)
        }
    }
}
