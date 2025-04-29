import SwiftUI

@MainActor
protocol MetarReportsScreenViewModel: ObservableObject {
    var reports: [MetarReport] { get }
    var errorMessage: String? { get }
    var isLoading: Bool { get }
    
    func loadReports(force: Bool) async
    func loadReportsWithDelay() async
}

struct MetarReportsScreen<ViewModel>: View
where ViewModel: MetarReportsScreenViewModel {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    if !viewModel.isLoading {
                        if let error = viewModel.errorMessage, viewModel.reports.isEmpty {
                            errorMessage(error) // TODO: - Handle Errors more gracefully
                        } else {
                            reportsSection
                        }
                    }
                }
                
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(2)
                }
            }
            .refreshable { await viewModel.loadReports(force: true) }
            .navigationTitle("METAR Reports")
            .task { await viewModel.loadReports(force: true) }
        }
    }
    
    private var reportsSection: some View {
        VStack(spacing: 12) {
            Button("Refresh from Cache") {
                Task { await viewModel.loadReportsWithDelay() }
            }
            .buttonStyle(.borderedProminent)
            .tint(.accentColor)
            
            ForEach(viewModel.reports) {
                reportCard(for: $0)
            }
        }
        .padding()
    }
    
    private func errorMessage(_ error: String) -> some View {
        VStack(spacing: 12) {
            Text("Error Loading Reports")
                .font(.headline)
            
            Text(error)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Button("Retry") {
                Task {
                    await viewModel.loadReports(force: true)
                }
            }
            .buttonStyle(.borderedProminent)
            .tint(.accentColor)
        }
    }
    
    private func reportCard(for report: MetarReport) -> some View {
        HStack(alignment: .top, spacing: 0) {
            VStack(alignment: .leading, spacing: 10) {
                Text(report.icaoId)
                    .fontWeight(.bold)
                
                Text(report.airportName)
                    .fontWeight(.semibold)
                
                if let wind = report.wind {
                    Label {
                        Text("Wind: \(wind.direction ?? "")° at \(wind.speed ?? 0) knots")
                    } icon: {
                        Image(systemName: "wind")
                    }
                    .font(.subheadline)
                }
                
                if let ceiling = report.ceiling {
                    Label {
                        Text("Ceiling: \(ceiling)")
                    } icon: {
                        Image(systemName: "cloud")
                    }
                    .font(.subheadline)
                }
            }
            
            Spacer(minLength: 8)
            
            ageIndicator(for: report.reportTime)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
    
    private func ageIndicator(for time: Date) -> some View {
        let age = Int(Date().timeIntervalSince(time)) / 60
        
        return HStack {
            Text("\(age) min")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Circle()
                .fill(age <= 30 ? Color.green : Color.orange)
                .frame(width: 10, height: 10)
        }
    }
}
