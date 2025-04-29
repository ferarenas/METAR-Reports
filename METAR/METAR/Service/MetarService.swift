import Foundation

// TODO: - Create Mock Service to use in Unit Tests
protocol MetarService {
    func metarReport(for station: String) async throws -> MetarReport
}

final class MetarApiService: MetarService {
    func metarReport(for station: String) async throws -> MetarReport {
        guard var components = URLComponents(string: "https://aviationweather.gov/api/data/metar")
        else { throw NetworkError.invalidURL }
        
        components.queryItems = [
            .init(name: "ids", value: station),
            .init(name: "format", value: "json")
        ]
        
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        
        return try .init(await ApiService.shared.get(url: url), station: station)
    }
}
