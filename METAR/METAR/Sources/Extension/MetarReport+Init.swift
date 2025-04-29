import Foundation

extension MetarReport {
    // TODO: - Find a better way to show the failed station so this init does not need to take the station
    init(_ data: [MetarReportDecodable], station: String) throws {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        guard let report = data.first,
              let reportDate = dateFormatter.date(from: report.reportTime)
        else { throw NetworkError.invalidReport(station) }

        self.id = report.metarId
        self.icaoId = report.icaoId
        self.airportName = report.name
        self.wind = .init(wdir: report.wdir, wspd: report.wspd)
        self.ceiling = report.clouds.first(where: { cloud in
            cloud.cover == "BKN" || cloud.cover == "OVC"
        })?.base.map { "\($0) ft" } ?? "—"
        self.reportTime = reportDate
    }
}

extension MetarReport.Wind {
    init?(wdir: String?, wspd: Int?) {
        guard wdir != nil, wspd != nil else { return nil }
        
        self.direction = wdir
        self.speed = wspd
    }
}
