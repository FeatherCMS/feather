import FeatherDatabase

public extension DatabaseTableWithUpdate {

    func update<
        Values: DatabaseEncodable,
        Row: DatabaseDecodable
    >(
        _ values: Values,
        matching id: String,
        returning rowType: Row.Type
    ) async throws -> Row? {
        var encoder = DatabaseFieldEncoder()
        values.encode(to: &encoder)

        var bindings: [DatabaseQueryBindings] = []
        let assignments = encoder.fields.map { field -> String in
            if let expression = field.expression {
                return "\(field.name) = \(expression.sql)"
            }

            guard let binding = field.binding else {
                return "\(field.name) = NULL"
            }

            bindings.append(
                DatabaseQueryBindings(
                    index: bindings.count,
                    binding: binding
                )
            )
            return "\(field.name) = {{\(bindings.count)}}"
        }

        let primaryKeyFilter: String
        if let binding = id.databaseQueryBinding {
            bindings.append(
                DatabaseQueryBindings(
                    index: bindings.count,
                    binding: binding
                )
            )
            primaryKeyFilter = "\(Self.primaryKeyField.name) = {{\(bindings.count)}}"
        }
        else {
            primaryKeyFilter = "\(Self.primaryKeyField.name) IS NULL"
        }

        return try await connection.run(
            query: DatabaseQuery(
                unsafeSQL: """
                    UPDATE \(Self.name)
                    SET \(assignments.joined(separator: ", "))
                    WHERE \(primaryKeyFilter)
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
