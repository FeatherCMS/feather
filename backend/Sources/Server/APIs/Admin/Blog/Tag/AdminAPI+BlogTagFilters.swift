import AdminOpenAPI

extension AdminAPI {

    func blogTagFilters(
        _ input: Operations.BlogTagFilters.Input
    ) async throws -> Operations.BlogTagFilters.Output {
        .ok(.init(body: .json(.init())))
    }
}
