import AuthAdminAPI

extension AdminAPIGateway {

    public func authCredentialFilters(
        _ input: Operations.AuthCredentialFilters.Input
    ) async throws -> Operations.AuthCredentialFilters.Output {
        .ok(
            .init(
                body: .json(
                    .init(
                        search: "",
                        userId: nil
                    )
                )
            )
        )
    }
}
