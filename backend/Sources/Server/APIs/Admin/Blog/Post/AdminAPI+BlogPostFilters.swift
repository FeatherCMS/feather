import AdminOpenAPI

extension AdminAPI {

    func blogPostFilters(
        _ input: Operations.BlogPostFilters.Input
    ) async throws -> Operations.BlogPostFilters.Output {
        .ok(.init(body: .json(.init())))
    }
}
