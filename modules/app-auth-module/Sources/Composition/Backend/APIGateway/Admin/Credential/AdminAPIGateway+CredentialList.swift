import AuthAdminAPI

extension AdminAPIGateway {

    public func authCredentialList(
        _ input: Operations.AuthCredentialList.Input
    ) async throws -> Operations.AuthCredentialList.Output {
        .ok(
            .init(
                body: .json(
                    []
                )
            )
        )
    }
}
