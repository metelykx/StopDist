import SwiftUI

struct GuideView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Факторы тормозного пути")
                        .font(.title)
                        .padding(.bottom, 10)
                    
                    InfoCard(
                        title: "Скорость",
                        description: "Увеличение скорости в 2 раза увеличивает тормозной путь в 4 раза",
                        icon: "speedometer"
                    )
                    
                    InfoCard(
                        title: "Дорожное покрытие",
                        description: "Тормозной путь на льду может быть в 5-10 раз длиннее, чем на сухом асфальте",
                        icon: "road.lanes"
                    )
                    
                    InfoCard(
                        title: "Шины",
                        description: "Зимние шины улучшают сцепление на 15-50% в холодную погоду",
                        icon: "tirepressure"
                    )
                    
                    InfoCard(
                        title: "ABS",
                        description: "Система ABS сокращает тормозной путь на 10-30% на скользких поверхностях",
                        icon: "abs"
                    )
                    
                    InfoCard(
                        title: "Загрузка",
                        description: "Полностью загруженный автомобиль требует на 20-40% больше тормозного пути",
                        icon: "shippingbox"
                    )
                    
                    InfoCard(
                        title: "Температура",
                        description: "При температуре ниже 7°C летние шины теряют эффективность",
                        icon: "thermometer"
                    )
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Справочник")
        }
    }
}
