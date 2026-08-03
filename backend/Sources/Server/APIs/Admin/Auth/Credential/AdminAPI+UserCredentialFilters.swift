import AdminOpenAPI

extension AdminAPI {

    func userCredentialFilters(
        _ input: Operations.UserCredentialFilters.Input
    ) async throws -> Operations.UserCredentialFilters.Output {
        .ok(
            .init(
                body: .json(
                    .init(
                        search: "",
                        accountID: nil
                    )
                )
            )
        )
    }
}
