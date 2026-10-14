public import FeatherDatabase

public protocol DatabaseFieldValue: Decodable & Sendable {
    var databaseQueryBinding: DatabaseQueryBinding? { get }
}

extension String: DatabaseFieldValue {
    public var databaseQueryBinding: DatabaseQueryBinding? {
        .string(self)
    }
}

extension Int: DatabaseFieldValue {
    public var databaseQueryBinding: DatabaseQueryBinding? {
        .int(self)
    }
}

extension Double: DatabaseFieldValue {
    public var databaseQueryBinding: DatabaseQueryBinding? {
        .double(self)
    }
}

extension Bool: DatabaseFieldValue {
    public var databaseQueryBinding: DatabaseQueryBinding? {
        .bool(self)
    }
}

extension Optional: DatabaseFieldValue where Wrapped: DatabaseFieldValue {
    public var databaseQueryBinding: DatabaseQueryBinding? {
        flatMap { $0.databaseQueryBinding }
    }
}
