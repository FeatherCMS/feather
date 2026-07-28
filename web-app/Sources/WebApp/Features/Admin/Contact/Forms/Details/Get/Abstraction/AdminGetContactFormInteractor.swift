protocol AdminGetContactFormInteractor: Sendable {
    func get(id: String) async throws -> AdminContactFormDetailsItem
}
