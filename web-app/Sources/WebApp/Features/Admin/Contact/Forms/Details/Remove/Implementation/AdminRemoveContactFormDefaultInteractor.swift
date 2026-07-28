struct AdminRemoveContactFormDefaultInteractor: AdminRemoveContactFormInteractor
{
    let repository: AdminRemoveContactFormOpenAPIRepository

    func get(id: String) async throws -> AdminContactFormDetailsItem {
        try await repository.get(id: id)
    }
    func bulkRemove(ids: [String]) async throws {
        try await repository.bulkRemove(ids: ids)
    }
}
