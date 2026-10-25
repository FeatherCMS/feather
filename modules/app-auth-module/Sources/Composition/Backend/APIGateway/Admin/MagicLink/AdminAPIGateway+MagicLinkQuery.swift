public import AuthAdminAPI
import AuthApplication
import AuthModule
import FeatherApplication
import FeatherModuleKit
import Foundation

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
        let useCase = self.useCases.makeSearchMagicLinks()
        let searchQuery = mapMagicLinkSearchQuery(query)

        let result = try await useCase.execute(
            subject: subject,
            input: .init(query: searchQuery)
        )

        return .ok(
            .init(
                body: .json(
                    .init(
                        query: magicLinkSearchResponseQuery(query),
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
        _ item: MagicLink.Search.Output.Item
    ) -> Components.Schemas.AuthMagicLinkQueryItemSchema {
        .init(
            id: item.id,
            credentialId: item.authEmailId,
            token: item.token,
            expiresAt: item.expiresAt.timeIntervalSince1970,
            isPersistent: item.isPersistent,
            isUsed: item.isUsed
        )
    }
}

extension AdminAPIGateway {
    private func mapMagicLinkSearchQuery(
        _ query: Components.Schemas
            .AuthMagicLinkQueryItemSearchRequestQuerySchema
    ) -> MagicLink.Search.Input.Query {
        .init(
            page: .init(
                size: query.page?.size ?? 20,
                number: query.page?.number ?? 1
            ),
            sort: (query.sort ?? [])
                .map { rule in
                    let field: MagicLink.Search.Input.Query.Sort.Field
                    switch rule.field {
                    case .id, .credentialId, .token, .expiresAt, .isPersistent,
                        .isUsed:
                        field = .init(rawValue: rule.field.rawValue) ?? .id
                    }
                    return .init(
                        field: field,
                        direction: mapMagicLinkSortDirection(rule.direction)
                    )
                },
            search: query.filters.search,
            userId: query.filters.userId
        )
    }

    private func magicLinkSearchResponseQuery(
        _ query: Components.Schemas
            .AuthMagicLinkQueryItemSearchRequestQuerySchema
    ) -> Components.Schemas.AuthMagicLinkQueryItemSearchResponseQuerySchema {
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
                        .AuthMagicLinkQueryItemSearchResponseQuerySchema
                        .SortPayloadPayload.FieldPayload
                switch rule.field {
                case .id: field = .id
                case .credentialId: field = .credentialId
                case .token: field = .token
                case .expiresAt: field = .expiresAt
                case .isPersistent: field = .isPersistent
                case .isUsed: field = .isUsed
                }
                return Components.Schemas
                    .AuthMagicLinkQueryItemSearchResponseQuerySchema
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

    private func mapMagicLinkSortDirection(
        _ direction: Components.Schemas.SortDirection
    ) -> Search.SortDirection {
        switch direction {
        case .asc: .asc
        case .desc: .desc
        }
    }
}
