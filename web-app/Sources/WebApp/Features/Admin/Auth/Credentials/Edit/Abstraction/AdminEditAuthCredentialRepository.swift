protocol AdminEditAuthCredentialRepository: Sendable {
    func get(id: String) async throws -> AuthCredentialDetailsModel
    func update(id: String, payload: AuthCredentialFormPayloadModel) async throws
}
