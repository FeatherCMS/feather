import AdminOpenAPI

extension AdminAPI {

    func blogAuthorFilters(
        _ input: Operations.BlogAuthorFilters.Input
    ) async throws -> Operations.BlogAuthorFilters.Output {
        .ok(.init(body: .json(.init())))
    }
}
