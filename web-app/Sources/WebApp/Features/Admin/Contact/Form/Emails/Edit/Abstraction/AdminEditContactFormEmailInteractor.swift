protocol AdminEditContactFormEmailInteractor: Sendable {
    func get(id: String) async throws -> AdminContactFormDetailsItem
    func update(id: String, email: AdminContactFormEmail) async throws
}
