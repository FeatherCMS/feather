protocol AdminListContactSubmissionsInteractor: Sendable {
    func list() async throws -> [AdminContactSubmissionDirectoryItem]
}
