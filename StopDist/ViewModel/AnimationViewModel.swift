//
//  AnimationViewModel.swift
//  StopDist
//
//  Created by Denis Ivaschenko on 26.06.2025.
//

import SwiftUI

class AnimationViewModel: ObservableObject {
    enum AnimationPhase {
        case ready, accelerating, cruising, braking, stopped
    }
    
    @Published var animationPhase: AnimationPhase = .ready
    @Published var carPosition: CGFloat = 0
    @Published var roadOffset: CGFloat = 0
    
    private var isActive = true
    private let screenWidth = UIScreen.main.bounds.width
    
    var buttonText: String {
        switch animationPhase {
        case .ready: return "Запустить симуляцию"
        case .accelerating: return "Разгон..."
        case .cruising: return "Движение..."
        case .braking: return "Торможение..."
        case .stopped: return "Завершено"
        }
    }
    
    func displayBrakingDistance(for distance: Double) -> CGFloat {
        min(CGFloat(distance) * 5, screenWidth * 2)
    }
    
    func totalRoadLength(for distance: Double) -> CGFloat {
        screenWidth + displayBrakingDistance(for: distance) + 100
    }
    
    func startAnimation(calculationVM: CalculationViewModel) {
        guard isActive else { return }
        
        animationPhase = .accelerating
        carPosition = -screenWidth / 2 + 50
        roadOffset = 0
        
        withAnimation(.easeIn(duration: 1)) {
            carPosition = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self, self.isActive else { return }
            
            self.animationPhase = .cruising
            let cruisingDuration = Double(300 / calculationVM.speed)
            
            withAnimation(.linear(duration: cruisingDuration)) {
                self.carPosition = self.screenWidth / 2 - 30
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + cruisingDuration) { [weak self] in
                guard let self = self, self.isActive else { return }
                
                self.animationPhase = .braking
                let brakingDuration = Double(calculationVM.brakingDistance) * 0.02
                let displayDistance = self.displayBrakingDistance(for: calculationVM.brakingDistance)
                
                withAnimation(.easeOut(duration: brakingDuration)) {
                    self.carPosition += displayDistance
                    self.roadOffset = -displayDistance
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + brakingDuration) { [weak self] in
                    guard let self = self, self.isActive else { return }
                    
                    self.animationPhase = .stopped
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                        self?.animationPhase = .ready
                    }
                }
            }
        }
    }
    
    func stopAnimation() {
        isActive = false
        animationPhase = .ready
    }
    
    func reset() {
        isActive = true
        carPosition = 0
        roadOffset = 0
    }
}
