import Foundation

struct MetarReportDecodable: Decodable {
    let metarId: Int
    let icaoId: String
    let name: String
    let reportTime: String
    @LosslessValue var wdir: String?
    @LosslessValue var wspd: Int?
    let clouds: [CloudDecodable]
}

struct CloudDecodable: Decodable {
    @LosslessValue var cover: String?
    @LosslessValue var base: Int?
}
