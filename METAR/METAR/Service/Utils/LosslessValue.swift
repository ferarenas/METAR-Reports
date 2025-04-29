import Foundation

@propertyWrapper
struct LosslessValue<T: LosslessStringConvertible & Decodable>: Decodable {
    let wrappedValue: T?

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let intValue = try? container.decode(Int.self) {
            wrappedValue = T("\(intValue)")
        } else if let stringValue = try? container.decode(String.self) {
            wrappedValue = T(stringValue)
        } else {
            wrappedValue = nil
        }
    }
}
