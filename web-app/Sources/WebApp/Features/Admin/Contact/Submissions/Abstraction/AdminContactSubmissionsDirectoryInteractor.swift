protocol AdminContactSubmissionsDirectoryInteractor: Sendable {
    func list() async throws -> [AdminContactSubmissionDirectoryItem]
    func bulkRemove(ids: [String]) async throws
}
