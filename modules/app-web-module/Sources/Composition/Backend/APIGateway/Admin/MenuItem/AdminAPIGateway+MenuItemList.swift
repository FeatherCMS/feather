import WebAdminAPI

extension AdminAPIGateway {

    public func webMenuItemList(
        _ input: Operations.WebMenuItemList.Input
    ) async throws -> Operations.WebMenuItemList.Output {
        .ok(.init(body: .json(.init())))
    }
}
