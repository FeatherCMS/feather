struct AdminRemoveContactFieldDefaultInteractor:
    AdminRemoveContactFieldInteractor
{
    let repository: AdminRemoveContactFieldOpenAPIRepository
    func get(id: String) async throws -> AdminContactFieldRow
    { try await repository.get(id: id) }
    func remove(id: String) async throws {
        try await repository.remove(id: id)
    }
    func bulkRemove(ids: [String]) async throws {
        try await repository.bulkRemove(ids: ids)
    }
}
