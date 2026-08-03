struct AdminEditAuthCredentialDefaultInteractor: AdminEditAuthCredentialInteractor {
    let repository: any AdminEditAuthCredentialRepository

    func get(id: String) async throws -> AuthCredentialDetailsModel {
        try await repository.get(id: id)
    }

    func execute(id: String, payload: AuthCredentialFormPayloadModel) async throws {
        try await repository.update(id: id, payload: payload)
    }
}
