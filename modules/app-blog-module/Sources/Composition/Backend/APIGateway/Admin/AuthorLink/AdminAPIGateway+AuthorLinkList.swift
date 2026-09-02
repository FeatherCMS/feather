import BlogAdminAPI

extension AdminAPIGateway {

    public func blogAuthorLinkList(
        _ input: Operations.BlogAuthorLinkList.Input
    ) async throws -> Operations.BlogAuthorLinkList.Output {
        .ok(.init(body: .json(.init())))
    }
}
