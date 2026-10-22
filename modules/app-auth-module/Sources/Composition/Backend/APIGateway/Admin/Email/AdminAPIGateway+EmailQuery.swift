public import AuthAdminAPI
import AuthApplication
import FeatherModuleKit

extension AdminAPIGateway {
    public func authEmailQuery(
        _ input: Operations.AuthEmailQuery.Input
    ) async throws -> Operations.AuthEmailQuery.Output {
        let query:
            Components.Schemas.AuthEmailQuerySchemasItemSearchRequestQuerySchema
        switch input.body {
        case .json(let value): query = value
        }

        let result = try await useCases.makeSearchAuthEmails()
            .execute(
                subject: try await CurrentSubject.require(),
                input: .init(query: map(query))
            )
        return .ok(
            .init(
                body: .json(
                    .init(
                        query: responseQuery(query),
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
