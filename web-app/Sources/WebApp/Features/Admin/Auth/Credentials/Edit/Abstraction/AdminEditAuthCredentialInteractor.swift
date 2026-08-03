protocol AdminEditAuthCredentialInteractor: Sendable {
    func get(id: String) async throws -> AuthCredentialDetailsModel
    func execute(id: String, payload: AuthCredentialFormPayloadModel) async throws
}
