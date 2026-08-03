protocol AdminAddAuthCredentialRepository: Sendable {
    func create(accountID: String, payload: AuthCredentialFormPayloadModel) async throws
}
