import WebAdminAPI

extension AdminAPIGateway {

    public func webPageList(
        _ input: Operations.WebPageList.Input
    ) async throws -> Operations.WebPageList.Output {
        .ok(.init(body: .json(.init())))
    }
}
