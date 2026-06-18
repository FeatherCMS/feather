struct AdminAddUserAccountDefaultInteractor: AdminAddUserAccountInteractor {
    let repository: any AdminAddUserAccountRepository

    func execute(
        entity: AdminAddUserAccountModel
    ) async throws {
        try await repository.create(payload: entity.payload)
    }
}
