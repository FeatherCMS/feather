protocol AdminRemoveAuthCredentialRepository: Sendable {
    func get(id: String) async throws -> AuthCredentialDetailsModel
    func delete(id: String) async throws
}
