import AdminOpenAPI
import BlogApplication
import Application

extension AdminAPI {

    func blogAuthorSearch(
        _ input: Operations.BlogAuthorSearch.Input
    ) async throws -> Operations.BlogAuthorSearch.Output {
        let query: Components.Schemas.BlogAuthorListItemSearchQuerySchema
        switch input.body {
        case let .json(value):
            query = value
        }

        let useCase = modules.blog.makeListAuthors()
        let objectQuery = map(query)
        let subject = try await CurrentSubject.require()

        let list = try await useCase.execute(
            subject: subject,
            input: .init(query: objectQuery)
        )
        let total = try await useCase.count(
            subject: subject,
            input: .init(query: objectQuery)
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
