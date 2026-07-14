struct AdminManageNewslettersDefaultInteractor: AdminManageNewslettersInteractor {
    let repository: AdminManageNewslettersOpenAPIRepository
    func list() async throws -> [AdminManageNewsletterItem] { try await repository.list() }
    func bulkRemove(ids: [String]) async throws { try await repository.bulkRemove(ids: ids) }
    func get(id: String) async throws -> AdminManageNewsletterItem { try await repository.get(id: id) }
    func update(id: String, name: String) async throws -> AdminManageNewsletterItem { try await repository.update(id: id, name: name) }
    func remove(id: String) async throws { try await repository.remove(id: id) }
}
