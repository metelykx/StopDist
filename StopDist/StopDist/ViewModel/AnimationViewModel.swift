import SwiftUI

class AnimationViewModel: ObservableObject {
    enum AnimationPhase {
        case ready, accelerating, braking, stopped
    }
    
    @Published var animationPhase: AnimationPhase = .ready
    @Published var carPosition: CGFloat = 0
    @Published var brakingZoneVisible = false
    
    private var isActive = true
    private let screenWidth = UIScreen.main.bounds.width
    
    var buttonText: String {
        switch animationPhase {
        case .ready: return "Запустить симуляцию"
        case .accelerating: return "Разгон..."
        case .braking: return "Торможение..."
        case .stopped: return "Остановлено"
        }
    }
    
    func displayBrakingDistance(for distance: Double) -> CGFloat {
        min(CGFloat(distance) * 8, screenWidth * 0.8)
    }
    
    func totalRoadLength(for distance: Double) -> CGFloat {
        screenWidth * 1.5
    }
    
    func startAnimation(calculationVM: CalculationViewModel) {
        // Разрешаем запуск из состояний ready и stopped
        guard isActive && (animationPhase == .ready || animationPhase == .stopped) else { return }
        
        resetState()
        animationPhase = .accelerating
        brakingZoneVisible = false
        
        // Начальная позиция машины (слева от экрана)
        carPosition = -100
        
        // Позиция в центре экрана
        let centerX = screenWidth / 2
        
        // Фаза разгона до центра экрана
        withAnimation(.easeIn(duration: 1.5)) {
            self.carPosition = centerX - 30
        }
        
        // Переход к торможению
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self, self.isActive else { return }
            
            self.animationPhase = .braking
            self.brakingZoneVisible = true
            
            let brakingDuration = Double(calculationVM.brakingDistance) * 0.04
            let brakingDistance = self.displayBrakingDistance(for: calculationVM.brakingDistance)
            
            // Торможение в центре экрана
            withAnimation(.easeOut(duration: brakingDuration)) {
                self.carPosition = centerX - 30 + brakingDistance
            }
            
            // Завершение анимации
            DispatchQueue.main.asyncAfter(deadline: .now() + brakingDuration) { [weak self] in
                guard let self = self, self.isActive else { return }
                self.animationPhase = .stopped
            }
        }
    }
    
    func resetState() {
        animationPhase = .ready
        carPosition = -100
        brakingZoneVisible = false
    }
    
    func stopAnimation() {
        isActive = false
        animationPhase = .stopped
    }
    
    func reset() {
        isActive = true
        resetState()
    }
}
