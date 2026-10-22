public import BlogAppAPI
import BlogApplication

extension AppAPIGateway {
    public func blogAuthorList(
        _ input: Operations.BlogAuthorList.Input
    ) async throws -> Operations.BlogAuthorList.Output {
        let items = try await self.useCases.makeListPublicAuthors()
            .execute(input: .init()).items
        var result: [Components.Schemas.BlogAuthorSummarySchema] = []
        result.reserveCapacity(items.count)
        for item in items {
            result.append(await mapPublicAuthorSummary(item))
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
