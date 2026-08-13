import BlogAdminAPI
import BlogApplication
import FeatherApplication
import FeatherContracts

extension BlogBackend {

    public func blogAuthorLinkSearch(
        _ input: Operations.BlogAuthorLinkSearch.Input
    ) async throws -> Operations.BlogAuthorLinkSearch.Output {
        let query: Components.Schemas.BlogAuthorLinkListItemSearchQuerySchema
        switch input.body {
        case .json(let value):
            query = value
        }

        let useCase = self.makeListAuthorLinks()
        let objectQuery = map(query)
        let subject = try await CurrentSubject.require()

        let list = try await useCase.execute(
            subject: subject,
            input: .init(authorId: input.path.blogAuthorId, query: objectQuery)
        )
        let total = try await useCase.count(
            subject: subject,
            input: .init(authorId: input.path.blogAuthorId, query: objectQuery)
        )

        return .ok(
            .init(
                body: .json(
                    .init(
                        query: query,
                        data: .init(items: list.items.map(map), total: total)
                    )
                )
            )
        )
    }
}
