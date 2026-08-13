import WebAdminAPI

extension WebBackend {

    public func webPageFilters(
        _ input: Operations.WebPageFilters.Input
    ) async throws -> Operations.WebPageFilters.Output {
        .ok(.init(body: .json(.init())))
    }
}
