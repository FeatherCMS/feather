protocol AdminAddUserIdentityRoleRepository: Sendable {

    func list() async throws -> [UserIdentityAddRoleOptionModel]
}
