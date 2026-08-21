import UserAdminAPI
import UserApplication

extension AdminAPIGateway {

    public func userIdentityFilters(
        _ input: Operations.UserIdentityFilters.Input
    ) async throws -> Operations.UserIdentityFilters.Output {
        .ok(
            .init(
                body: .json(.init())
            )
        )
    }
}
