import BlogAdminAPI

extension AdminAPIGateway {

    public func blogAuthorList(
        _ input: Operations.BlogAuthorList.Input
    ) async throws -> Operations.BlogAuthorList.Output {
        .ok(.init(body: .json(.init())))
    }
}
