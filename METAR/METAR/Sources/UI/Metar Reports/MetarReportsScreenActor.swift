import Foundation

actor MetarReportsScreenActor<Service> where Service: MetarService {
    private var cache: [String: (report: MetarReport, fetchedAt: Date)] = [:]
    private let cacheTTL: TimeInterval = 5 * 60
    private let service: Service
    
    init(service: Service) {
        self.service = service
    }
    
    nonisolated func fetchReport(for station: String, force: Bool) async throws -> MetarReport {
        if let cachedEntry = await cache[station],
           Date().timeIntervalSince(cachedEntry.fetchedAt) < cacheTTL,
           !force {
            return cachedEntry.report
        }
        
        let freshReport = try await service.metarReport(for: station)
        await updateCache(of: station, with: (report: freshReport, fetchedAt: Date()))
        return freshReport
    }
    
    private func updateCache(of station: String, with data: (report: MetarReport, fetchedAt: Date)) {
        cache[station] = data
    }
}
