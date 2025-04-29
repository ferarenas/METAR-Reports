import Foundation

protocol MetarService {
    func metarReport(for station: String) async throws -> MetarReport
}

