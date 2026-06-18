import AdminOpenAPI

extension AdminAPI {

    func webPageFilters(
        _ input: Operations.WebPageFilters.Input
    ) async throws -> Operations.WebPageFilters.Output {
        .ok(.init(body: .json(.init())))
    }
}
