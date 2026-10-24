public import BlogAdminAPI
import BlogApplication
import FeatherApplication
import FeatherModuleKit
import Foundation

extension AdminAPIGateway {

    public func blogAuthorLinkQuery(
        _ input: Operations.BlogAuthorLinkQuery.Input
    ) async throws -> Operations.BlogAuthorLinkQuery.Output {
        let query:
            Components.Schemas.AuthorLinkQueryItemSearchRequestQuerySchema
        switch input.body {
        case .json(let value):
            query = value
        }

        let useCase = self.useCases.makeSearchAuthorLinks()
        let pageDefaults = Search.Page()
        let objectQuery = AuthorLink.Search.Input.Query(
            page: Search.Page(
                size: query.page?.size ?? pageDefaults.size,
                number: query.page?.number ?? pageDefaults.number
            ).normalized(),
            sort: (query.sort ?? []).map { item in
                let field: AuthorLink.Search.Input.Query.Sort.Field
                switch item.field {
                case .id: field = .id
                case .label: field = .label
                case .url: field = .url
                case .priority: field = .priority
                case .permission: field = .permission
                case .createdAt: field = .createdAt
                case .updatedAt: field = .updatedAt
                }
                let direction: Search.SortDirection
                switch item.direction {
                case .asc: direction = .asc
                case .desc: direction = .desc
                }
                return .init(field: field, direction: direction)
            },
            search: query.filters.search
        )
        let subject = try await CurrentSubject.require()

        let result = try await useCase.execute(
            subject: subject,
            input: .init(authorId: input.path.blogAuthorId, query: objectQuery)
        )

        return .ok(
            .init(
                body: .json(
                    .init(
                        query: .init(
                            page: .init(
                                size: objectQuery.page.size,
                                number: objectQuery.page.number
                            ),
                            sort: query.sort?.map { item in
                                let field: Components.Schemas
                                    .AuthorLinkQueryItemSearchResponseQuerySchema
                                    .SortPayloadPayload.FieldPayload
                                switch item.field {
                                case .id: field = .id
                                case .label: field = .label
                                case .priority: field = .priority
                                case .url: field = .url
                                case .permission: field = .permission
                                case .createdAt: field = .createdAt
                                case .updatedAt: field = .updatedAt
                                }
                                return .init(
                                    field: field,
                                    direction: item.direction
                                )
                            },
                            filters: .init(search: query.filters.search)
                        ),
                        data: .init(
                            items: result.items.map(mapAuthorLinkSearchItem),
                            total: result.total
                        )
                    )
                )
            )
        )
    }

    private func mapAuthorLinkSearchItem(
        _ item: AuthorLink.Search.Output.Item
    ) -> Components.Schemas.AuthorLinkQueryItemSchema {
        .init(
            id: item.id,
            menuId: item.authorId,
            label: item.label,
            url: item.url,
            priority: item.priority,
            isBlank: item.isBlank,
            permission: item.permission,
            createdAt: item.createdAt.timeIntervalSince1970,
            updatedAt: item.updatedAt.timeIntervalSince1970
        )
    }
}
