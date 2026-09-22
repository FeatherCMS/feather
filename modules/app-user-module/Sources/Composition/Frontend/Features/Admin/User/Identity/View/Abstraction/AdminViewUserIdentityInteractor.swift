import FeatherAdmin

protocol AdminViewUserIdentityInteractor: Sendable {
    func roleNames(for ids: [String]) async throws -> [String]

    func load(
        id: String
    ) async throws -> AdminViewUserIdentityModel
}
