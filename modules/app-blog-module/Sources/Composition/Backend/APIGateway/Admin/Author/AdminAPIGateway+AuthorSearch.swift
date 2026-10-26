public import BlogAdminAPI
import BlogApplication
import BlogModule
import FeatherApplication
import FeatherModuleKit
import Foundation
import WebApplication

extension AdminAPIGateway {

    public func blogAuthorQuery(
        _ input: Operations.BlogAuthorQuery.Input
    ) async throws -> Operations.BlogAuthorQuery.Output {
        let query: Components.Schemas.AuthorQueryItemSearchRequestQuerySchema
        switch input.body {
        case .json(let value):
            query = value
        }

        let useCase = self.useCases.makeSearchAuthors()
        let pageDefaults = Search.Page()
        let objectQuery = Author.Search.Input.Query(
            page:
                Search.Page(
                    size: query.page?.size ?? pageDefaults.size,
                    number: query.page?.number ?? pageDefaults.number
                )
                .normalized(),
            sort: (query.sort ?? [])
                .map { item in
                    let field: Author.Search.Input.Query.Sort.Field
                    switch item.field {
                    case .id: field = .id
                    case .key: field = .key
                    case .name: field = .name
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

        let list = try await useCase.execute(
            subject: subject,
            input: .init(query: objectQuery)
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
                            sort: query.sort?
                                .map { item in
                                    let field:
                                        Components.Schemas
                                            .AuthorQueryItemSearchResponseQuerySchema
                                            .SortPayloadPayload.FieldPayload
                                    switch item.field {
                                    case .id: field = .id
                                    case .key: field = .key
                                    case .name: field = .name
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
                            items: list.items.map(mapAuthorSearchItem),
                            total: list.total
                        )
                    )
                )
            )
        )
    }

    private func mapAuthorSearchItem(
        _ item: Author.Search.Output.Item
    ) -> Components.Schemas.AuthorQueryItemSchema {
        .init(
            id: item.id,
            name: item.name,
            excerpt: item.excerpt,
            profileImageAssetId: item.profileImageAssetId,
            createdAt: item.createdAt.timeIntervalSince1970,
            updatedAt: item.updatedAt.timeIntervalSince1970
        )
    }
}
