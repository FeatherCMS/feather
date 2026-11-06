public import ContactModule
public import FeatherDBAL

public import struct Foundation.Date

extension Submission.Table: DatabaseTableWithInsert {
    public struct Insert: DatabaseTableRowEncodable {
        public let id: String
        public let formId: String
        public let values: JSONValue
        public let itemsSnapshot: JSONValue
        public let metadata: JSONValue?
        public let status: String

        enum CodingKeys: String, CodingKey {
            case id
            case formId = "form_id"
            case values
            case itemsSnapshot = "items_snapshot"
            case metadata
            case status
        }
    }
}

extension Submission.Table: DatabaseTableWithUpdate {
    public struct Update: DatabaseTableRowEncodable {
        public let status: String

        public func afterEncode(values: inout DatabaseTableRowValues) throws {
            values[Submission.Table.columns.updatedAt] = .currentTimestamp
        }
    }
}

extension Submission.Table: DatabaseTableWithDetail {
    public struct Detail: DatabaseTableRowDecodable {
        public let id: String
        public let formId: String
        public let values: String
        public let itemsSnapshot: String
        public let metadata: String?
        public let status: String
        public let createdAt: Date
        public let updatedAt: Date

        enum CodingKeys: String, CodingKey {
            case id = "id"
            case formId = "form_id"
            case values = "values"
            case itemsSnapshot = "items_snapshot"
            case metadata = "metadata"
            case status = "status"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
        }
    }
}

extension Submission.Table: DatabaseTableWithList {
    public struct List: DatabaseTableRowDecodable {
        public let id: String
        public let formId: String
        public let values: String
        public let itemsSnapshot: String
        public let metadata: String?
        public let status: String
        public let createdAt: Date
        public let updatedAt: Date

        enum CodingKeys: String, CodingKey {
            case id = "id"
            case formId = "form_id"
            case values = "values"
            case itemsSnapshot = "items_snapshot"
            case metadata = "metadata"
            case status = "status"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
        }
    }
}

extension Submission.Table: DatabaseTableWithDelete {}

extension Submission.Table {
    public enum JSONValue: Codable, Sendable {
        case object([String: Self])
        case array([Self])
        case string(String)
        case integer(Int64)
        case number(Double)
        case boolean(Bool)
        case null

        public init(from decoder: any Decoder) throws {
            let singleValue = try decoder.singleValueContainer()
            if singleValue.decodeNil() {
                self = .null
            }
            else if let value = try? singleValue.decode(Bool.self) {
                self = .boolean(value)
            }
            else if let value = try? singleValue.decode(Int64.self) {
                self = .integer(value)
            }
            else if let value = try? singleValue.decode(Double.self) {
                self = .number(value)
            }
            else if let value = try? singleValue.decode(String.self) {
                self = .string(value)
            }
            else if let container = try? decoder.container(keyedBy: Key.self) {
                var object: [String: Self] = [:]
                for key in container.allKeys {
                    object[key.stringValue] = try container.decode(
                        Self.self,
                        forKey: key
                    )
                }
                self = .object(object)
            }
            else {
                var container = try decoder.unkeyedContainer()
                var array: [Self] = []
                while !container.isAtEnd {
                    array.append(try container.decode(Self.self))
                }
                self = .array(array)
            }
        }

        public func encode(to encoder: any Encoder) throws {
            switch self {
            case .object(let object):
                var container = encoder.container(keyedBy: Key.self)
                for (name, value) in object {
                    try container.encode(value, forKey: Key(stringValue: name)!)
                }
            case .array(let array):
                var container = encoder.unkeyedContainer()
                for value in array { try container.encode(value) }
            case .string(let value):
                var container = encoder.singleValueContainer()
                try container.encode(value)
            case .integer(let value):
                var container = encoder.singleValueContainer()
                try container.encode(value)
            case .number(let value):
                var container = encoder.singleValueContainer()
                try container.encode(value)
            case .boolean(let value):
                var container = encoder.singleValueContainer()
                try container.encode(value)
            case .null:
                var container = encoder.singleValueContainer()
                try container.encodeNil()
            }
        }

        private struct Key: CodingKey {
            let stringValue: String
            let intValue: Int?

            init?(stringValue: String) {
                self.stringValue = stringValue
                self.intValue = nil
            }

            init?(intValue: Int) {
                self.stringValue = String(intValue)
                self.intValue = intValue
            }
        }
    }
}
