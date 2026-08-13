import AuthAdminAPI

extension AuthBackend {

    public func authMagicLinkFilters(
        _ input: Operations.AuthMagicLinkFilters.Input
    ) async throws -> Operations.AuthMagicLinkFilters.Output {
        .ok(
            .init(
                body: .json(.init())
            )
        )
    }
}
