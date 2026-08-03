struct AdminAddAuthCredentialDefaultInteractor: AdminAddAuthCredentialInteractor {
    let repository: any AdminAddAuthCredentialRepository

    func execute(accountID: String, payload: AuthCredentialFormPayloadModel) async throws {
        try await repository.create(accountID: accountID, payload: payload)
    }
}
