import FeatherAdmin

protocol AdminViewUserIdentityRoleRepository: Sendable {

    func names(for ids: [String]) async throws -> [String]
}
