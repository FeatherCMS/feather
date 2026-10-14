protocol AdminRemoveUserRoleRepository: Sendable {

    func delete(
        ids: [String]
    ) async throws
}
