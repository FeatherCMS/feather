import Foundation

extension Template {
    public indirect enum Value: Codable, Sendable, Equatable {
        case object([String: Value])
        case array([Value])
        case string(String)
        case integer(Int64)
        case number(Double)
        case boolean(Bool)
        case null

        public init(from decoder: any Decoder) throws {
            let container = try decoder.singleValueContainer()
            if container.decodeNil() {
                self = .null
            }
            else if let value = try? container.decode(Bool.self) {
                self = .boolean(value)
            }
            else if let value = try? container.decode(Int64.self) {
                self = .integer(value)
            }
            else if let value = try? container.decode(Double.self) {
                self = .number(value)
            }
            else if let value = try? container.decode(String.self) {
                self = .string(value)
            }
            else if let values = try? container.decode([Value].self) {
                self = .array(values)
            }
            else {
                self = .object(try container.decode([String: Value].self))
            }
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .object(let value): try container.encode(value)
            case .array(let value): try container.encode(value)
            case .string(let value): try container.encode(value)
            case .integer(let value): try container.encode(value)
            case .number(let value): try container.encode(value)
            case .boolean(let value): try container.encode(value)
            case .null: try container.encodeNil()
            }
        }

        public var sendableValue: any Sendable {
            switch self {
            case .object(let value):
                value.mapValues(\.sendableValue)
            case .array(let value):
                value.map(\.sendableValue)
            case .string(let value): value
            case .integer(let value): value
            case .number(let value): value
            case .boolean(let value): value
            case .null: ""
            }
        }
    }
}
