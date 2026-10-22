public import BlogAdminAPI
import BlogApplication
import FeatherModuleKit

extension AdminAPIGateway {

    public func blogPostQuery(
        _ input: Operations.BlogPostQuery.Input
    ) async throws -> Operations.BlogPostQuery.Output {
        let query: Components.Schemas.BlogPostQueryItemSearchRequestQuerySchema
        switch input.body {
        case .json(let value):
            query = value
        }

        let useCase = self.useCases.makeSearchPosts()
        let objectQuery = map(query)
        let subject = try await CurrentSubject.require()

        let list = try await useCase.execute(
            subject: subject,
            input: .init(query: objectQuery)
        )
        return .ok(
            .init(
                body: .json(
                    .init(
                        query: responseQuery(from: query),
                        data: .init(
                            items: list.items.map(mapQuery),
                            total: list.total
                        )
                    )
                )
            )
        )
    }
}
