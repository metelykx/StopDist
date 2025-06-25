//
//  HistoryView.swift
//  StopDist
//
//  Created by Denis Ivaschenko on 25.06.2025.
//

import SwiftUI

struct HistoryView: View {
    @ObservedObject var viewModel: HistoryViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.history) { calc in
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
                    if !viewModel.history.isEmpty {
                        Button("Очистить историю") {
                            viewModel.history.removeAll()
                        }
                        .foregroundColor(.red)
                    }
                }
            }
        }
    }
}
