public import AuthAdminAPI
import AuthApplication
import AuthModule
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
        let useCase = self.useCases.makeSearchCredentials()
        let listQuery = map(query)
        let objectQuery = Credential.Search.Input.Query(
            page: listQuery.page,
            sort: listQuery.sort.map {
                .init(
                    field: .init(rawValue: $0.field.rawValue) ?? .userId,
                    direction: $0.direction
                )
            },
            search: listQuery.search
        )
        let userId =
            query.filters.userId?.isEmpty == true
            ? nil
            : query.filters.userId

        let result = try await useCase.execute(
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
                            items: result.items.map(mapQuery),
                            total: result.total
                        )
                    )
                )
            )
        )
    }
}

extension AdminAPIGateway {
    fileprivate func mapQuery(
        _ item: Credential.Search.Output.Item
    ) -> Components.Schemas.AuthCredentialQueryItemSchema {
        .init(
            id: item.id,
            userId: item.userId,
            identityName: item.identityName,
            email: item.email
        )
    }
}
