struct AdminContactSubmissionsDirectoryDefaultInteractor: AdminContactSubmissionsDirectoryInteractor {
    let repository: AdminContactSubmissionsDirectoryOpenAPIRepository

    func list() async throws -> [AdminContactSubmissionDirectoryItem] {
        try await repository.list()
    }

    func bulkRemove(ids: [String]) async throws {
        try await repository.bulkRemove(ids: ids)
    }
}
