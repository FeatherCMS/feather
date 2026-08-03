struct AdminRemoveAuthCredentialDefaultInteractor: AdminRemoveAuthCredentialInteractor {
    let repository: any AdminRemoveAuthCredentialRepository

    func get(id: String) async throws -> AuthCredentialDetailsModel {
        try await repository.get(id: id)
    }

    func delete(id: String) async throws {
        try await repository.delete(id: id)
    }
}
