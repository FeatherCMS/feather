public protocol DatabaseTableWithBulkDelete: DatabaseTableWithPrimaryKey {
    func delete(ids: [String]) async throws -> [String]
}
