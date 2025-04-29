import Foundation

struct MetarReport: Identifiable {
    let id: Int
    let icaoId: String
    let airportName: String
    let wind: Wind?
    let ceiling: String?
    let reportTime: Date
}

extension MetarReport {
    struct Wind: Decodable {
        let direction: String?
        let speed: Int?
    }
}
