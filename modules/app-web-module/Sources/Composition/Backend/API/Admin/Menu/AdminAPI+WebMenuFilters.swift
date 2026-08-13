import WebAdminAPI

extension WebBackend {

    public func webMenuFilters(
        _ input: Operations.WebMenuFilters.Input
    ) async throws -> Operations.WebMenuFilters.Output {
        .ok(.init(body: .json(.init())))
    }
}
