import FeatherDatabase

public extension DatabaseTableWithList {

    func list<Row: DatabaseDecodable>(
        _ query: DatabaseTableQuery,
        returning rowType: Row.Type
    ) async throws -> [Row] {
        let whereSQL = query.whereSQL.isEmpty
            ? ""
            : "WHERE \(query.whereSQL)"
        let orderBySQL = query.orderBySQL.isEmpty
            ? ""
            : "ORDER BY \(query.orderBySQL)"
        let limitSQL = query.limitSQL.map { "LIMIT \($0)" } ?? ""
        let offsetSQL = query.offsetSQL.map { "OFFSET \($0)" } ?? ""

        return try await connection.run(
            query: DatabaseQuery(
                unsafeSQL: """
                    SELECT *
                    FROM \(Self.name)
                    \(whereSQL)
                    \(orderBySQL)
                    \(limitSQL)
                    \(offsetSQL);
                    """,
                bindings: query.queryBindings
            )
        ) { sequence in
            try await sequence.collect().map {
                try Row(
                    from: DatabaseRowDecoder(),
                    row: $0
                )
            }
        }
    }

    func count(_ query: DatabaseTableQuery) async throws -> Int {
        let whereSQL = query.whereSQL.isEmpty
            ? ""
            : "WHERE \(query.whereSQL)"

        return try await connection.run(
            query: DatabaseQuery(
                unsafeSQL: """
                    SELECT COUNT(*) AS count
                    FROM \(Self.name)
                    \(whereSQL);
                    """,
                bindings: query.queryBindings
            )
        ) { sequence in
            guard let row = try await sequence.collect().first else {
                return 0
            }
            return try row.decode(column: "count", as: Int.self)
        }
    }
}
