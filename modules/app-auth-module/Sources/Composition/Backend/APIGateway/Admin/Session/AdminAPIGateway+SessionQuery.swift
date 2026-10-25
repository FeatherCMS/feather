public import AuthAdminAPI
import AuthApplication
import AuthModule
import FeatherApplication
import FeatherModuleKit

extension AdminAPIGateway {
    public func userIdentitySessionQuery(
        _ input: Operations.UserIdentitySessionQuery.Input
    ) async throws -> Operations.UserIdentitySessionQuery.Output {
        let requestQuery:
            Components.Schemas
                .UserIdentitySessionQueryItemSearchRequestQuerySchema
        switch input.body {
        case .json(let value):
            requestQuery = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeSearchSessions()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                identityId: input.path.userIdentityId,
                query: mapSessionSearchQuery(requestQuery)
            )
        )

        return .ok(
            .init(
                body: .json(
                    .init(
                        query: sessionSearchResponseQuery(requestQuery),
                        data: .init(
                            items: result.items.map(mapSessionQueryItem),
                            total: result.total
                        )
                    )
                )
            )
        )
    }
}

extension AdminAPIGateway {
    private func mapSessionSearchQuery(
        _ query: Components.Schemas
            .UserIdentitySessionQueryItemSearchRequestQuerySchema
    ) -> Session.Search.Input.Query {
        .init(
            page: .init(
                size: query.page?.size ?? 20,
                number: query.page?.number ?? 1
            ),
            sort: (query.sort ?? []).map { rule in
                let field: Session.Search.Input.Query.Sort.Field
                switch rule.field {
                case .id: field = .id
                case .createdAt: field = .createdAt
                }
                return .init(
                    field: field,
                    direction: mapSessionSortDirection(rule.direction)
                )
            },
            search: query.filters.search
        )
    }

    private func sessionSearchResponseQuery(
        _ query: Components.Schemas
            .UserIdentitySessionQueryItemSearchRequestQuerySchema
    ) -> Components.Schemas
        .UserIdentitySessionQueryItemSearchResponseQuerySchema
    {
        let page = Search.Page(
            size: query.page?.size ?? 20,
            number: query.page?.number ?? 1
        )
        .normalized()
        let sort = query.sort?.map { rule in
            let field: Components.Schemas
                .UserIdentitySessionQueryItemSearchResponseQuerySchema
                .SortPayloadPayload.FieldPayload
            switch rule.field {
            case .id: field = .id
            case .createdAt: field = .createdAt
            }
            return Components.Schemas
                .UserIdentitySessionQueryItemSearchResponseQuerySchema
                .SortPayloadPayload(field: field, direction: rule.direction)
        }
        return .init(
            page: .init(size: page.size, number: page.number),
            sort: sort,
            filters: .init(search: query.filters.search)
        )
    }

    private func mapSessionSortDirection(
        _ direction: Components.Schemas.SortDirection
    ) -> Search.SortDirection {
        switch direction {
        case .asc: .asc
        case .desc: .desc
        }
    }

    private func mapSessionQueryItem(
        _ item: Session.Search.Output.Item
    ) -> Components.Schemas.UserIdentitySessionQueryItem {
        .init(
            id: item.id,
            authenticationType: item.authenticationType,
            authenticationReference: item.authenticationReference,
            expiresAt: item.expiresAt.timeIntervalSince1970,
            isPersistent: item.isPersistent,
            createdAt: item.createdAt.timeIntervalSince1970,
            updatedAt: item.updatedAt.timeIntervalSince1970
        )
    }
}
