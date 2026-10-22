public import AuthAdminAPI
import AuthApplication
import FeatherModuleKit

extension AdminAPIGateway {

    public func authCredentialQuery(
        _ input: Operations.AuthCredentialQuery.Input
    ) async throws -> Operations.AuthCredentialQuery.Output {
        let query:
            Components.Schemas.AuthCredentialQueryItemSearchRequestQuerySchema
        switch input.body {
        case .json(let value):
            query = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = self.useCases.makeListCredential()
        let objectQuery = map(query)
        let userId =
            query.filters.userId?.isEmpty == true
            ? nil
            : query.filters.userId

        let list = try await useCase.execute(
            subject: subject,
            input: .init(
                query: objectQuery,
                userId: userId
            )
        )
        let total = try await useCase.count(
            subject: subject,
            input: .init(
                query: objectQuery,
                userId: userId
            )
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
