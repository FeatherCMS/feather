struct AdminRemoveContactSubmissionsDefaultInteractor:
    AdminRemoveContactSubmissionsInteractor
{
    let repository: AdminRemoveContactSubmissionsOpenAPIRepository
    func bulkRemove(ids: [String]) async throws {
        try await repository.bulkRemove(ids: ids)
    }
}
