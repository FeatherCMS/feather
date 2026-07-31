protocol AdminAddContactFormEmailInteractor: Sendable {
    func get(id: String) async throws -> AdminContactFormDetailsItem
    func add(id: String, email: AdminContactFormEmail) async throws
}
