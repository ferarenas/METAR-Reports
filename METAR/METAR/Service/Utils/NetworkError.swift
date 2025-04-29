import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidReport(String)
    case requestFailed(Int)
    case decodingError(Error)
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL is invalid."
        case let .invalidReport(station):
            return "Invalid report for station \(station)"
        case let .requestFailed(statusCode):
            return "Request failed with status code: \(statusCode)."
        case let .decodingError(error):
            return "Failed to decode \(error.localizedDescription)."
        case .unknown:
            return "An unknown network error occurred."
        }
    }
}
