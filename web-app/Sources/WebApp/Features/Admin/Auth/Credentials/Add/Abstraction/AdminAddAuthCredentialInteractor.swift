protocol AdminAddAuthCredentialInteractor: Sendable {
    func execute(accountID: String, payload: AuthCredentialFormPayloadModel) async throws
}
