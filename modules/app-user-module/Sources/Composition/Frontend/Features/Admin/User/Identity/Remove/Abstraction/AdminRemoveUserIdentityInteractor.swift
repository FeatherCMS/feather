import FeatherAdmin

protocol AdminRemoveUserIdentityInteractor: Sendable {

    func names(
        ids: [String]
    ) async throws -> [String]

    func delete(
        ids: [String]
    ) async throws
}
