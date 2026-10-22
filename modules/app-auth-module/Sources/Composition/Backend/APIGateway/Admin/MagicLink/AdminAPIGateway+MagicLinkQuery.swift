public import AuthAdminAPI
import AuthApplication
import FeatherModuleKit

extension AdminAPIGateway {

    public func authMagicLinkQuery(
        _ input: Operations.AuthMagicLinkQuery.Input
    ) async throws -> Operations.AuthMagicLinkQuery.Output {
        let query:
            Components.Schemas.AuthMagicLinkQueryItemSearchRequestQuerySchema
        switch input.body {
        case .json(let value):
            query = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = self.useCases.makeListMagicLinks()
        let objectQuery = map(query)

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
                        query: responseQuery(query),
                        data: .init(
                            items: list.items.map(mapQuery),
                            total: total
                        )
                    )
                )
            )
        )
    }
}
