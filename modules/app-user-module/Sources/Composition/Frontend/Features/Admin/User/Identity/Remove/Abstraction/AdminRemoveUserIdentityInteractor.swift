import FeatherAdmin

protocol AdminRemoveUserIdentityInteractor: Sendable {

    func delete(
        ids: [String]
    ) async throws
}
