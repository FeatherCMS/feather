public import BlogAdminAPI
import BlogApplication
import FeatherModuleKit

extension AdminAPIGateway {

    public func blogAuthorQuery(
        _ input: Operations.BlogAuthorQuery.Input
    ) async throws -> Operations.BlogAuthorQuery.Output {
        let query: Components.Schemas.AuthorQueryItemSearchRequestQuerySchema
        switch input.body {
        case .json(let value):
            query = value
        }

        let useCase = self.useCases.makeSearchAuthors()
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
                            items: list.items.map(map),
                            total: list.total
                        )
                    )
                )
            )
        )
    }
}
