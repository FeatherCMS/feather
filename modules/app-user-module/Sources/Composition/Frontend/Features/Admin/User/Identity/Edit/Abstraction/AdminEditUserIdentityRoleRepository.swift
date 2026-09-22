
protocol AdminEditUserIdentityRoleRepository: Sendable {

    func list() async throws -> [UserIdentityEditRoleOptionModel]
}
