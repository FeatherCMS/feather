protocol AdminListContactFormEmailsInteractor: Sendable {
    func get(id: String) async throws -> AdminContactFormDetailsItem
}
