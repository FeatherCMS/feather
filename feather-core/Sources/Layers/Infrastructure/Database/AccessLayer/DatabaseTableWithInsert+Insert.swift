import FeatherDatabase

public extension DatabaseTableWithInsert {

    func insert<Insert: DatabaseEncodable, Row: DatabaseDecodable>(
        _ value: Insert,
        returning rowType: Row.Type
    ) async throws -> Row? {
        var encoder = DatabaseFieldEncoder()
        value.encode(to: &encoder)

        let fields = encoder.fields
        let columns = fields.map { $0.name }.joined(separator: ", ")
        var bindings: [DatabaseQueryBindings] = []
        let values = fields.map { field -> String in
            if let expression = field.expression {
                return expression.sql
            }

            guard let binding = field.binding else {
                return "NULL"
            }

            bindings.append(
                DatabaseQueryBindings(
                    index: bindings.count,
                    binding: binding
                )
            )
            return "{{\(bindings.count)}}"
        }
        .joined(separator: ", ")

        return try await connection.run(
            query: DatabaseQuery(
                unsafeSQL: """
                    INSERT INTO \(Self.name) (\(columns))
                    VALUES (\(values))
                    RETURNING *;
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
