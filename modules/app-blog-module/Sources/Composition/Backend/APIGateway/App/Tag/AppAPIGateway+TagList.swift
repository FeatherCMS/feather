public import BlogAppAPI
import BlogApplication

extension AppAPIGateway {
    public func blogTagList(
        _ input: Operations.BlogTagList.Input
    ) async throws -> Operations.BlogTagList.Output {
        let items = try await self.useCases.makeListPublicTags()
            .execute(input: .init()).items
        var result: [Components.Schemas.BlogTagSummarySchema] = []
        result.reserveCapacity(items.count)
        for item in items {
            result.append(await mapPublicTagSummary(item))
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
