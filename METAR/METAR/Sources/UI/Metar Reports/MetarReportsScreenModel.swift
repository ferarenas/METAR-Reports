import Foundation

final class MetarReportsScreenModel: MetarReportsScreenViewModel {
    @Published private(set) var reports: [MetarReport] = []
    @Published private(set) var errorMessage: String?
    @Published private(set) var isLoading: Bool = false

    private let manager = MetarReportsScreenActor(service: MetarApiService())
    private let stations: [String] = ["KJFK", "KORD", "KIAH", "CYEG", "CYHZ", "CYOW", "CYUL", "CYVR"]

    func loadReports(force: Bool) async {
        var fetchedReports: [MetarReport] = []
        var errors: [String] = []

        await withTaskGroup(of: Result<MetarReport, Error>.self) { group in
            for station in stations {
                group.addTask { [manager] in
                    do {
                        let report = try await manager.fetchReport(for: station, force: force)
                        return .success(report)
                    } catch {
                        return .failure(error)
                    }
                }
            }
            
            for await result in group {
                switch result {
                case .success(let report):
                    fetchedReports.append(report)
                case .failure(let error):
                    errors.append(error.localizedDescription)
                }
            }
        }
        
        reports = fetchedReports.sorted(by: { $0.icaoId < $1.icaoId })
        errorMessage = errors.isEmpty ? nil : errors.joined(separator: "\n")
    }
    
    // This was introduced because the refresh from cache happens instantaneously
    // so this was added to show the user that something did happened
    func loadReportsWithDelay() async {
        isLoading = true
        try? await Task.sleep(for: .seconds(0.5))
        await loadReports(force: false)
        isLoading = false
    }
}
