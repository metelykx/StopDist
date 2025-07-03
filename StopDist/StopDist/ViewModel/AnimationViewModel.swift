import SwiftUI

class AnimationViewModel: ObservableObject {
    enum AnimationPhase {
        case ready, accelerating, braking, stopped
    }
    
    @Published var animationPhase: AnimationPhase = .ready
    @Published var carProgress: CGFloat = 0
    @Published var brakingZoneVisible = false
    @Published var isAnimating = false
    
    private var animationTask: DispatchWorkItem?
    
    var buttonText: String {
        switch animationPhase {
        case .ready: return "Запустить симуляцию"
        case .accelerating: return "Разгон..."
        case .braking: return "Торможение..."
        case .stopped: return "Остановлено"
        }
    }
    
    func startAnimation(calculationVM: CalculationViewModel) {
        guard !isAnimating else { return }
        
        resetState()
        isAnimating = true
        animationPhase = .accelerating
        brakingZoneVisible = false
        
        // Отменяем предыдущие задачи анимации
        animationTask?.cancel()
        
        // Анимация разгона
        withAnimation(.easeIn(duration: 1.5)) {
            self.carProgress = 0.4
        }
        
        // Создаем задачу для торможения
        let brakingTask = DispatchWorkItem { [weak self] in
            guard let self = self, self.isAnimating else { return }
            
            self.animationPhase = .braking
            self.brakingZoneVisible = true
            
            // Рассчитываем длительность торможения пропорционально пути
            let brakingDuration = Double(calculationVM.brakingDistance) * 0.02
            
            // Анимация торможения
            withAnimation(.easeOut(duration: brakingDuration)) {
                // Рассчитываем конечную позицию с учетом масштабирования
                let maxProgress = min(0.4 + 0.6 * (calculationVM.brakingDistance / 100), 1.0)
                self.carProgress = maxProgress
            }
            
            // Задача для завершения анимации
            let stopTask = DispatchWorkItem { [weak self] in
                guard let self = self, self.isAnimating else { return }
                self.animationPhase = .stopped
                self.isAnimating = false
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + brakingDuration, execute: stopTask)
            self.animationTask = stopTask
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: brakingTask)
        animationTask = brakingTask
    }
    
    func stopAnimation() {
        // Отменяем все запланированные анимации
        animationTask?.cancel()
        
        // Возвращаем машинку в начальное положение с анимацией
        withAnimation(.easeOut(duration: 0.5)) {
            self.carProgress = 0
            self.brakingZoneVisible = false
        }
        
        // Устанавливаем состояние
        isAnimating = false
        animationPhase = .ready
    }
    
    func resetState() {
        // Без анимации - мгновенный сброс
        carProgress = 0
        brakingZoneVisible = false
        animationPhase = .ready
    }
    
    func reset() {
        isAnimating = false
        resetState()
    }
}
