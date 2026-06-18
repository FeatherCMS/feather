import AdminOpenAPI
import BlogApplication
import Application

extension AdminAPI {

    func blogAuthorLinkSearch(
        _ input: Operations.BlogAuthorLinkSearch.Input
    ) async throws -> Operations.BlogAuthorLinkSearch.Output {
        let query: Components.Schemas.BlogAuthorLinkListItemSearchQuerySchema
        switch input.body {
        case let .json(value):
            query = value
        }

        let useCase = modules.blog.makeListAuthorLinks()
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
