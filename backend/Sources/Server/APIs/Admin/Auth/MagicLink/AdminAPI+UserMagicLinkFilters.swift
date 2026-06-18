import AdminOpenAPI

extension AdminAPI {

    func userMagicLinkFilters(
        _ input: Operations.UserMagicLinkFilters.Input
    ) async throws -> Operations.UserMagicLinkFilters.Output {
        .ok(
            .init(
                body: .json(.init())
            )
        )
    }
}
