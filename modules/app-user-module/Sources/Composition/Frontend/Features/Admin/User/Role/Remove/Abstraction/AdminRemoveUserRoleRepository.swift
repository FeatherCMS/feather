import FeatherAdmin

protocol AdminRemoveUserRoleRepository: Sendable {

    func names(ids: [String]) async throws -> [String]

    func delete(
        ids: [String]
    ) async throws
}
