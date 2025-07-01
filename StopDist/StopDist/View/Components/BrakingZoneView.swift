import SwiftUI

struct BrakingZoneView: View {
    var width: CGFloat
    @State private var blink = false
    
    var body: some View {
        ZStack {
            // Основная зона
            RoundedRectangle(cornerRadius: 8)
                .frame(width: width, height: 20)
                .foregroundColor(blink ? Color.red.opacity(0.8) : Color.orange.opacity(0.7))
                .onAppear {
                    withAnimation(Animation.easeInOut(duration: 0.5).repeatForever()) {
                        blink.toggle()
                    }
                }
            
            // Текст
            Text("ТОРМОЖЕНИЕ")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.white)
                .opacity(blink ? 1 : 0.5)
        }
    }
}
