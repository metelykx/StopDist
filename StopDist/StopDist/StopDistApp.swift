import SwiftUI

@main
struct StopDistApp: App {
    // Создаем экземпляр настроек приложения
    @StateObject private var appSettings = AppSettings()
    
    // Переменные для отслеживания жизненного цикла приложения
    @Environment(\.scenePhase) var scenePhase
    @State var isAppActive: Bool = true
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                // Главный экран приложения
                ContentView()
                    .opacity(isAppActive ? 1 : 0)
                    .animation(.default, value: isAppActive)
                    // Передаем настройки в иерархию представлений
                    .environmentObject(appSettings)
                
                // Стартовый экран (возможно, заставка)
                StartView()
                    .opacity(isAppActive ? 0 : 1)
                    .animation(.default, value: isAppActive)
            }
        }
        .onChange(of: scenePhase) { newValue in
            switch newValue {
            case .active:
                self.isAppActive = true
            case .inactive:
                self.isAppActive = false
            @unknown default:
                break
            }
        }
    }
}
