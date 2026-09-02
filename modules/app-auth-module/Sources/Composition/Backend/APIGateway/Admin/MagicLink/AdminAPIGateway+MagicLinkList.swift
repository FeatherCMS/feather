import AuthAdminAPI

extension AdminAPIGateway {

    public func authMagicLinkList(
        _ input: Operations.AuthMagicLinkList.Input
    ) async throws -> Operations.AuthMagicLinkList.Output {
        .ok(
            .init(
                body: .json(.init())
            )
        )
    }
}
