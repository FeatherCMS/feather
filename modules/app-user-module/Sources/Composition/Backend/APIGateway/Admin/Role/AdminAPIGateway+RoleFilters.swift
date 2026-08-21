import UserAdminAPI
import UserApplication

extension AdminAPIGateway {

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
