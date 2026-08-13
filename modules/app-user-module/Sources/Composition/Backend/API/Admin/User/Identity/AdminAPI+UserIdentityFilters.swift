import UserAdminAPI
import UserApplication

extension UserBackend {

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
