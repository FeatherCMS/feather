protocol AdminManageNewslettersInteractor: Sendable {
    func list() async throws -> [AdminManageNewsletterItem]
    func bulkRemove(ids: [String]) async throws
    func get(id: String) async throws -> AdminManageNewsletterItem
    func update(id: String, name: String, fromEmail: String) async throws -> AdminManageNewsletterItem
    func remove(id: String) async throws
}
