import BlogAdminAPI

extension AdminAPIGateway {

    public func blogTagList(
        _ input: Operations.BlogTagList.Input
    ) async throws -> Operations.BlogTagList.Output {
        .ok(.init(body: .json(.init())))
    }
}
