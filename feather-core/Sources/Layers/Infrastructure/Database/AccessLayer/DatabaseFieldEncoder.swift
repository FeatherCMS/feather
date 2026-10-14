import FeatherDatabase

public struct DatabaseFieldEncoder: Sendable {

    private(set) var fields: [DatabaseEncodedField] = []

    public init() {}

    public mutating func encode<Value: DatabaseFieldValue>(
        _ value: Value,
        for field: DatabaseField<Value>
    ) {
        fields.append(
            DatabaseEncodedField(
                name: field.name,
                binding: value.databaseQueryBinding,
                expression: nil
            )
        )
    }

    public mutating func encode<Value: Decodable & Sendable>(
        _ expression: DatabaseSQLExpression,
        for field: DatabaseField<Value>
    ) {
        fields.append(
            DatabaseEncodedField(
                name: field.name,
                binding: nil,
                expression: expression
            )
        )
    }
}
