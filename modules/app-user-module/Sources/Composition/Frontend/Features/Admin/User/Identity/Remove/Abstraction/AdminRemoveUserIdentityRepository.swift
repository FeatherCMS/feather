import FeatherAdmin

protocol AdminRemoveUserIdentityRepository: Sendable {

    func delete(
        ids: [String]
    ) async throws
}
