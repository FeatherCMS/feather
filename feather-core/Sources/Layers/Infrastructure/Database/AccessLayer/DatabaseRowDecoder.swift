import FeatherDatabase

public struct DatabaseRowDecoder: Sendable {

    public init() {}

    public func decode<Value: Decodable & Sendable>(
        _ field: DatabaseField<Value>,
        from row: any DatabaseRow
    ) throws(DecodingError) -> Value {
        try row.decode(
            column: field.name,
            as: Value.self
        )
    }
}
