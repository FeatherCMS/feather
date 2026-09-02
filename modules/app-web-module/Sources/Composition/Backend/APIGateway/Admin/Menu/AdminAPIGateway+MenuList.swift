import WebAdminAPI

extension AdminAPIGateway {

    public func webMenuList(
        _ input: Operations.WebMenuList.Input
    ) async throws -> Operations.WebMenuList.Output {
        .ok(.init(body: .json(.init())))
    }
}
