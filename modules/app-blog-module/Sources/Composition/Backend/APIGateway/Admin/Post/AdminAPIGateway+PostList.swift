import BlogAdminAPI

extension AdminAPIGateway {

    public func blogPostList(
        _ input: Operations.BlogPostList.Input
    ) async throws -> Operations.BlogPostList.Output {
        .ok(.init(body: .json(.init())))
    }
}
