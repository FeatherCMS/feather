import UserAdminAPI

extension AdminAPIGateway {

    public func userIdentityList(
        _ input: Operations.UserIdentityList.Input
    ) async throws -> Operations.UserIdentityList.Output {
        .ok(
            .init(
                body: .json(.init())
            )
        )
    }
}
