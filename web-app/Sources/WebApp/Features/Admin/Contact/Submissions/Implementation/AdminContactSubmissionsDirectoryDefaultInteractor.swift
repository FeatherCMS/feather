struct AdminContactSubmissionsDirectoryDefaultInteractor: AdminContactSubmissionsDirectoryInteractor {
    let repository: AdminContactSubmissionsDirectoryOpenAPIRepository

    func list() async throws -> [AdminContactSubmissionDirectoryItem] {
        try await repository.list()
    }
}
