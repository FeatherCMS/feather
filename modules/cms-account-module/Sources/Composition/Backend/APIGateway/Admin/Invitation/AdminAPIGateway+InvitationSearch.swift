public import AccountAdminAPI
import AccountApplication
import AccountModule
import FeatherApplication
import FeatherModuleKit
import Foundation

extension AdminAPIGateway {

    public func accountInvitationQuery(
        _ input: Operations.AccountInvitationQuery.Input
    ) async throws -> Operations.AccountInvitationQuery.Output {
        let query:
            Components.Schemas
                .InvitationQuerySchemasItemSearchRequestQuerySchema
        switch input.body {
        case .json(let value):
            query = value
        }

        let subject = try await CurrentSubject.require()
        let useCase = useCases.makeSearchInvitations()
        let objectQuery = Invitation.Search.Input.Query(
            page: .init(
                size: query.page?.size ?? 20,
                number: query.page?.number ?? 1
            ),
            sort: (query.sort ?? [])
                .map { rule in
                    let field: Invitation.Search.Input.Query.Sort.Field =
                        switch rule.field {
                        case .id: .id
                        case .email: .email
                        case .token: .token
                        case .expiresAt: .expiresAt
                        }

                    let direction: Search.SortDirection =
                        switch rule.direction {
                        case .asc: .asc
                        case .desc: .desc
                        }

                    return .init(field: field, direction: direction)
                },
            search: query.filters.search
        )

        let result = try await useCase.execute(
            subject: subject,
            input: .init(query: objectQuery)
        )

        let responseQuery = Components.Schemas
            .InvitationQuerySchemasItemSearchResponseQuerySchema(
                page: .init(
                    size: query.page?.size ?? 20,
                    number: query.page?.number ?? 1
                ),
                sort: query.sort?
                    .map { sort in
                        .init(
                            field: .init(rawValue: sort.field.rawValue)!,
                            direction: sort.direction
                        )
                    },
                filters: .init(search: query.filters.search)
            )

        return .ok(
            .init(
                body: .json(
                    .init(
                        query: responseQuery,
                        data: .init(
                            items: result.items.map { item in
                                .init(
                                    id: item.id,
                                    email: item.email,
                                    token: item.token,
                                    roleIds: item.roleIDs,
                                    expiresAt: item.expiresAt
                                        .timeIntervalSince1970
                                )
                            },
                            total: result.total
                        )
                    )
                )
            )
        )
    }
}
