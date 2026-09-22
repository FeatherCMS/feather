import FeatherAdmin

protocol AdminViewUserRoleInteractor: Sendable {

    func load(
        id: String
    ) async throws -> UserRoleDetailsModel
}
