public import BlogAppAPI
import BlogApplication

extension AppAPIGateway {
    public func blogPostList(
        _ input: Operations.BlogPostList.Input
    ) async throws -> Operations.BlogPostList.Output {
        let items = try await self.useCases.makeListPublicPosts()
            .execute(input: .init()).items
        var result: [Components.Schemas.BlogPostSummarySchema] = []
        result.reserveCapacity(items.count)
        for item in items {
            result.append(await mapPublicPostSummary(item))
        }
        return .ok(
            .init(
                body: .json(
                    result
                )
            )
        )
    }
}
