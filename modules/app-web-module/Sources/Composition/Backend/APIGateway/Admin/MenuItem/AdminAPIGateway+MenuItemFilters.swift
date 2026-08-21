import WebAdminAPI

extension AdminAPIGateway {

    public func webMenuItemFilters(
        _ input: Operations.WebMenuItemFilters.Input
    ) async throws -> Operations.WebMenuItemFilters.Output {
        .ok(.init(body: .json(.init())))
    }
}
