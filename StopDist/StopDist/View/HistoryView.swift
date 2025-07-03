import SwiftUI

struct HistoryView: View {
    @StateObject private var viewModel = HistoryViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            if viewModel.history.isEmpty {
                emptyHistoryView
            } else {
                historyListView
            }
        }
    }
    
    private var emptyHistoryView: some View {
        VStack(spacing: 20) {
            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            Text("История расчетов пуста")
                .font(.title2)
            Text("Выполните расчеты на вкладке 'Симуляция', чтобы сохранить результаты")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
        }
        .frame(maxHeight: .infinity)
    }
    
    private var historyListView: some View {
        List {
            ForEach(viewModel.history) { calc in
                HistoryRow(calc: calc)
            }
            .onDelete(perform: viewModel.deleteItems)
        }
        .listStyle(.plain)
        .navigationTitle("История расчетов")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Закрыть") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
            
            ToolbarItem(placement: .bottomBar) {
                Button(action: {
                    viewModel.clearHistory()
                }) {
                    Text("Очистить историю")
                        .foregroundColor(.red)
                }
            }
        }
    }
}

struct HistoryRow: View {
    let calc: Calculation
    
    private var roadTypeEnum: RoadType? {
        RoadType(rawValue: calc.roadType)
    }
    
    private var weatherEnum: WeatherCondition? {
        WeatherCondition(rawValue: calc.weather)
    }
    
    private var tireTypeEnum: TireType? {
        TireType(rawValue: calc.tireType)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(calc.date, style: .date)
                .font(.caption)
                .foregroundColor(.secondary)
            
            HStack {
                Text("\(Int(calc.speed)) км/ч → \(calc.distance, specifier: "%.1f") м")
                    .font(.headline)
                
                Spacer()
                
                if let roadType = roadTypeEnum {
                    Text(roadType.rawValue)
                        .font(.caption)
                        .padding(4)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(4)
                }
                
                if let weather = weatherEnum {
                    Text(weather.rawValue)
                        .font(.caption)
                        .padding(4)
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(4)
                }
            }
            
            if let tireType = tireTypeEnum {
                Text("\(tireType.rawValue)\(calc.hasSpikes ? " (шипы)" : "") • \(calc.absStatus)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
}
