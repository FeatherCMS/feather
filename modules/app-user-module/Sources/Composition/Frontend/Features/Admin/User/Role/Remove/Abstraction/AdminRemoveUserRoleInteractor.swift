protocol AdminRemoveUserRoleInteractor: Sendable {

    func delete(
        ids: [String]
    ) async throws
}
