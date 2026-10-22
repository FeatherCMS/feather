public import BlogAdminAPI
import BlogApplication
import FeatherModuleKit

extension AdminAPIGateway {

    public func blogAuthorLinkQuery(
        _ input: Operations.BlogAuthorLinkQuery.Input
    ) async throws -> Operations.BlogAuthorLinkQuery.Output {
        let query:
            Components.Schemas.AuthorLinkQueryItemSearchRequestQuerySchema
        switch input.body {
        case .json(let value):
            query = value
        }

        let useCase = self.useCases.makeSearchAuthorLinks()
        let objectQuery = map(query)
        let subject = try await CurrentSubject.require()

        let result = try await useCase.execute(
            subject: subject,
            input: .init(authorId: input.path.blogAuthorId, query: objectQuery)
        )

        return .ok(
            .init(
                body: .json(
                    .init(
                        query: responseQuery(from: query),
                        data: .init(
                            items: result.items.map(mapQuery),
                            total: result.total
                        )
                    )
                )
            )
        )
    }
}
