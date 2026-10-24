public import AuthAdminAPI
import AuthApplication
import AuthModule
import FeatherApplication
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
        let listQuery = mapCredentialSearchQuery(query)
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
                        query: credentialSearchResponseQuery(query),
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
    private func mapQuery(
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

extension AdminAPIGateway {
    private func mapCredentialSearchQuery(
        _ query: Components.Schemas
            .AuthCredentialQueryItemSearchRequestQuerySchema
    ) -> Credential.List.Input.Query {
        .init(
            page: .init(
                size: query.page?.size ?? 20,
                number: query.page?.number ?? 1
            ),
            sort: (query.sort ?? [])
                .map { rule in
                    let field: Credential.List.Input.Query.Sort.Field
                    switch rule.field {
                    case .userId: field = .userId
                    case .email: field = .email
                    }
                    return .init(
                        field: field,
                        direction: mapCredentialSortDirection(rule.direction)
                    )
                },
            search: query.filters.search
        )
    }

    private func credentialSearchResponseQuery(
        _ query: Components.Schemas
            .AuthCredentialQueryItemSearchRequestQuerySchema
    ) -> Components.Schemas.AuthCredentialQueryItemSearchResponseQuerySchema {
        let page =
            Search.Page(
                size: query.page?.size ?? 20,
                number: query.page?.number ?? 1
            )
            .normalized()
        let sort = query.sort?
            .map { rule in
                let field:
                    Components.Schemas
                        .AuthCredentialQueryItemSearchResponseQuerySchema
                        .SortPayloadPayload.FieldPayload
                switch rule.field {
                case .userId: field = .userId
                case .email: field = .email
                }
                return Components.Schemas
                    .AuthCredentialQueryItemSearchResponseQuerySchema
                    .SortPayloadPayload(
                        field: field,
                        direction: rule.direction
                    )
            }
        return .init(
            page: .init(size: page.size, number: page.number),
            sort: sort,
            filters: .init(
                search: query.filters.search,
                userId: query.filters.userId
            )
        )
    }

    private func mapCredentialSortDirection(
        _ direction: Components.Schemas.SortDirection
    ) -> Search.SortDirection {
        switch direction {
        case .asc: .asc
        case .desc: .desc
        }
    }
}
