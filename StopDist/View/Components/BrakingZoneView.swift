import SwiftUI

struct BrakingZoneView: View {
    var width: CGFloat
    
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .frame(width: width, height: 20)
            .foregroundColor(.red.opacity(0.4))
    }
}
