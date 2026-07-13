protocol AdminContactSubmissionsDirectoryInteractor: Sendable {
    func list() async throws -> [AdminContactSubmissionDirectoryItem]
}
