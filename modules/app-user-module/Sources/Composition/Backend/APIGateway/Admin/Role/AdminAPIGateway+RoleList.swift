import UserAdminAPI
import UserApplication

extension AdminAPIGateway {

    public func userRoleList(
        _ input: Operations.UserRoleList.Input
    ) async throws -> Operations.UserRoleList.Output {
        .ok(
            .init(
                body: .json(.init())
            )
        )
    }
}
