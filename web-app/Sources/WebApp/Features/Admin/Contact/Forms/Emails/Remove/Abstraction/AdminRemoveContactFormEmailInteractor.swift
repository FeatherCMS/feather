protocol AdminRemoveContactFormEmailInteractor: Sendable {
    func get(id: String) async throws -> AdminContactFormDetailsItem
    func remove(id: String, emailId: String) async throws
}
