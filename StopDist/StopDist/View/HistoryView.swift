import SwiftUI

struct HistoryView: View {
    @ObservedObject var viewModel: HistoryViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            if viewModel.history.isEmpty {
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
            } else {
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
                        Button("Очистить историю") {
                            viewModel.clearHistory()
                        }
                        .foregroundColor(.red)
                    }
                }
            }
        }
    }
}

struct HistoryRow: View {
    let calc: Calculation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(calc.date, style: .date)
                .font(.caption)
                .foregroundColor(.secondary)
            
            HStack {
                Text("\(Int(calc.speed)) км/ч → \(calc.distance, specifier: "%.1f") м")
                    .font(.headline)
                
                Spacer()
                
                Text(calc.roadType)
                    .font(.caption)
                    .padding(4)
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(4)
                
                Text(calc.weather)
                    .font(.caption)
                    .padding(4)
                    .background(Color.green.opacity(0.2))
                    .cornerRadius(4)
            }
            
            Text("\(calc.tireType)\(calc.hasSpikes ? " (шипы)" : "") • \(calc.absStatus)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
    }
}
