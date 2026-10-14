import FeatherDatabase

public extension DatabaseTableWithFind {

    func findFirst<Value: DatabaseFieldValue, Row: DatabaseDecodable>(
        by field: DatabaseField<Value>,
        equals value: Value,
        returning rowType: Row.Type
    ) async throws -> Row? {
        var bindings: [DatabaseQueryBindings] = []
        let filter: String

        if let binding = value.databaseQueryBinding {
            bindings.append(
                DatabaseQueryBindings(
                    index: 0,
                    binding: binding
                )
            )
            filter = "\(field.name) = {{1}}"
        }
        else {
            filter = "\(field.name) IS NULL"
        }

        return try await connection.run(
            query: DatabaseQuery(
                unsafeSQL: """
                    SELECT *
                    FROM \(Self.name)
                    WHERE \(filter)
                    LIMIT 1;
                    """,
                bindings: bindings
            )
        ) { sequence in
            guard let row = try await sequence.collect().first else {
                return nil
            }
            return try Row(
                from: DatabaseRowDecoder(),
                row: row
            )
        }
    }
}
