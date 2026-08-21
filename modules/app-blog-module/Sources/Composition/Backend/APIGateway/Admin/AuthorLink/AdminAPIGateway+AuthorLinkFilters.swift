import BlogAdminAPI

extension AdminAPIGateway {

    public func blogAuthorLinkFilters(
        _ input: Operations.BlogAuthorLinkFilters.Input
    ) async throws -> Operations.BlogAuthorLinkFilters.Output {
        .ok(.init(body: .json(.init())))
    }
}
