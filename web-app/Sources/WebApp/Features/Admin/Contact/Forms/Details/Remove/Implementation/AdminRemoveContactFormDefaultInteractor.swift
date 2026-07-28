struct AdminRemoveContactFormDefaultInteractor: AdminRemoveContactFormInteractor
{
    let repository: AdminRemoveContactFormOpenAPIRepository

    func get(id: String) async throws -> AdminContactFormDetailsItem {
        try await repository.get(id: id)
    }
    func remove(id: String) async throws { try await repository.remove(id: id) }
    func bulkRemove(ids: [String]) async throws {
        for id in ids { try await repository.remove(id: id) }
    }
}
