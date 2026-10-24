public import AuthAdminAPI
import AuthApplication
import AuthModule
import FeatherApplication
import FeatherModuleKit
import Foundation

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
                input: .init(query: mapEmailSearchQuery(query))
            )
        return .ok(
            .init(
                body: .json(
                    .init(
                        query: emailSearchResponseQuery(query),
                        data: .init(
                            items: result.items.map(mapEmailSearchItem),
                            total: result.total
                        )
                    )
                )
            )
        )
    }
}

extension AdminAPIGateway {
    private func mapEmailSearchQuery(
        _ query: Components.Schemas
            .AuthEmailQuerySchemasItemSearchRequestQuerySchema
    ) -> Email.Search.Input.Query {
        .init(
            page: .init(
                size: query.page?.size ?? 20,
                number: query.page?.number ?? 1
            ),
            sort: (query.sort ?? [])
                .map { rule in
                    let field: Email.Search.Input.Query.Sort.Field
                    switch rule.field {
                    case .identityId: field = .identityId
                    case .email: field = .email
                    }
                    return .init(
                        field: field,
                        direction: mapEmailSortDirection(rule.direction)
                    )
                },
            search: query.filters.search,
            identityId: query.filters.identityId
        )
    }

    private func emailSearchResponseQuery(
        _ query: Components.Schemas
            .AuthEmailQuerySchemasItemSearchRequestQuerySchema
    ) -> Components.Schemas.AuthEmailQuerySchemasItemSearchResponseQuerySchema {
        let page = mapEmailSearchQuery(query).page.normalized()
        let sort = query.sort?
            .map { rule in
                let field:
                    Components.Schemas
                        .AuthEmailQuerySchemasItemSearchResponseQuerySchema
                        .SortPayloadPayload.FieldPayload
                switch rule.field {
                case .identityId: field = .identityId
                case .email: field = .email
                }
                return Components.Schemas
                    .AuthEmailQuerySchemasItemSearchResponseQuerySchema
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
                identityId: query.filters.identityId
            )
        )
    }

    private func mapEmailSearchItem(
        _ item: Email.Search.Output.Item
    ) -> Components.Schemas.AuthEmailQuerySchemasItem {
        .init(id: item.id, identityId: item.identityId, email: item.email)
    }

    private func mapEmailSortDirection(
        _ direction: Components.Schemas.SortDirection
    ) -> Search.SortDirection {
        switch direction {
        case .asc: .asc
        case .desc: .desc
        }
    }
}
