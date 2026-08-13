import UserAdminAPI
import UserApplication

extension UserBackend {

    public func userRoleFilters(
        _ input: Operations.UserRoleFilters.Input
    ) async throws -> Operations.UserRoleFilters.Output {
        .ok(
            .init(
                body: .json(.init())
            )
        )
    }
}
