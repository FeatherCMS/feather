import AdminOpenAPI

extension AdminAPI {

    func blogAuthorLinkFilters(
        _ input: Operations.BlogAuthorLinkFilters.Input
    ) async throws -> Operations.BlogAuthorLinkFilters.Output {
        .ok(.init(body: .json(.init())))
    }
}
