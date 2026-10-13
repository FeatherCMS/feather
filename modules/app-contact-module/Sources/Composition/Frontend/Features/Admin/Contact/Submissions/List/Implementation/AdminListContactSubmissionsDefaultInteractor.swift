struct AdminListContactSubmissionsDefaultInteractor:
    AdminListContactSubmissionsInteractor
{
    let repository: AdminListContactSubmissionsOpenAPIRepository
    func list() async throws -> [AdminContactSubmissionDirectoryItem] {
        try await repository.list()
    }
}
