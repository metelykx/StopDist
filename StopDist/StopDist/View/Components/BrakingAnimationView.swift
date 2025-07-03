import SwiftUI

struct BrakingAnimationView: View {
    @ObservedObject var calculationVM: CalculationViewModel
    @ObservedObject var animationVM: AnimationViewModel
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Дорога
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 40)
                    
                    // Начало торможения
                    Rectangle()
                        .fill(Color.gray)
                        .frame(width: 2)
                        .offset(x: geometry.size.width * 0.4)
                    
                    // Тормозной путь
                    if animationVM.brakingZoneVisible {
                        let startX = geometry.size.width * 0.4
                        let brakingWidth = min(
                            CGFloat(calculationVM.brakingDistance) * geometry.size.width / 100,
                            geometry.size.width * 0.6
                        )
                        
                        Rectangle()
                            .fill(Color.red.opacity(0.3))
                            .frame(width: brakingWidth)
                            .offset(x: startX)
                    }
                    
                    // Машинка
                    Image(systemName: "car.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 30)
                        .offset(x: geometry.size.width * animationVM.carProgress - 30)
                        .foregroundColor(.blue)
                }
            }
            .frame(height: 100)
            
            DistanceScaleView(
                brakingDistance: calculationVM.brakingDistance,
                visible: animationVM.brakingZoneVisible
            )
        }
    }
}
