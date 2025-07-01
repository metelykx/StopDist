import SwiftUI

struct BrakingAnimationView: View {
    var calculationVM: CalculationViewModel
    @ObservedObject var animationVM: AnimationViewModel
    
    // Локальные переменные для упрощения доступа
    private var brakingDistance: Double {
        calculationVM.brakingDistance
    }
    
    private var displayBrakingDistance: CGFloat {
        animationVM.displayBrakingDistance(for: brakingDistance)
    }
    
    private var centerX: CGFloat {
        UIScreen.main.bounds.width / 2
    }
    
    var body: some View {
        VStack {
            // Индикатор состояния
            HStack {
                Spacer()
                Text(animationVM.animationPhase == .stopped ?
                     "Остановлено" : animationVM.buttonText)
                    .font(.headline)
                    .foregroundColor(animationVM.animationPhase == .braking ? .red : .primary)
                Spacer()
            }
            .padding(.bottom, 5)
            
            // Контейнер анимации
            ZStack {
                // Фон для контраста
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                
                // Центральная линия (для ориентации)
                Rectangle()
                    .frame(width: 2, height: 100)
                    .foregroundColor(.blue.opacity(0.3))
                    .position(x: centerX, y: 50)
                
                // Дорожное полотно
                RoadView()
                    .frame(height: 20)
                    .padding(.horizontal, 20)
                
                // Зона торможения (всегда в центре)
                if animationVM.brakingZoneVisible {
                    BrakingZoneView(width: displayBrakingDistance)
                        .position(x: centerX, y: 50)
                }
                
                // Машина
                CarView(tireType: calculationVM.tireType)
                    .position(x: animationVM.carPosition, y: 50)
            }
            .frame(height: 100)
            
            // Шкала расстояния
            if animationVM.brakingZoneVisible || animationVM.animationPhase == .stopped {
                HStack {
                    Text("0 м")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("\(brakingDistance, specifier: "%.1f") м")
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(5)
                        .background(Color.red.opacity(0.2))
                        .cornerRadius(5)
                    
                    Spacer()
                    
                    Text("100 м")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 30)
                .padding(.top, 5)
            }
        }
        .padding(.vertical, 10)
    }
}
