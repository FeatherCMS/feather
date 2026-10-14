import FeatherDatabase

public extension DatabaseTableWithBulkDelete {

    func delete(ids: [String]) async throws -> [String] {
        guard !ids.isEmpty else { return [] }

        return try await connection.run(
            query: #"""
                DELETE FROM \#(unescaped: Self.name)
                WHERE \#(unescaped: Self.primaryKey) IN (\#(ids))
                RETURNING \#(unescaped: Self.primaryKey);
                """#
        ) { sequence in
            try await sequence.collect()
                .map {
                    try $0.decode(
                        column: Self.primaryKey,
                        as: String.self
                    )
                }
        }
    }
}
