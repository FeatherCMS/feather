public import BlogAdminAPI
import BlogApplication
import BlogModule
import FeatherApplication
import FeatherModuleKit
import Foundation

extension AdminAPIGateway {

    public func blogPostQuery(
        _ input: Operations.BlogPostQuery.Input
    ) async throws -> Operations.BlogPostQuery.Output {
        let query: Components.Schemas.PostQueryItemSearchRequestQuerySchema
        switch input.body {
        case .json(let value):
            query = value
        }

        let useCase = self.useCases.makeSearchPosts()
        let pageDefaults = Search.Page()
        let objectQuery = Post.Search.Input.Query(
            page:
                Search.Page(
                    size: query.page?.size ?? pageDefaults.size,
                    number: query.page?.number ?? pageDefaults.number
                )
                .normalized(),
            sort: (query.sort ?? [])
                .map { item in
                    let field: Post.Search.Input.Query.Sort.Field
                    switch item.field {
                    case .id: field = .id
                    case .title: field = .title
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
                                            .PostQueryItemSearchResponseQuerySchema
                                            .SortPayloadPayload.FieldPayload
                                    switch item.field {
                                    case .id: field = .id
                                    case .title: field = .title
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
                            items: list.items.map(mapPostSearchItem),
                            total: list.total
                        )
                    )
                )
            )
        )
    }

    private func mapPostSearchItem(
        _ item: Post.Search.Output.Item
    ) -> Components.Schemas.PostQueryItemSchema {
        .init(
            id: item.id,
            title: item.title,
            excerpt: item.excerpt,
            imageAssetId: item.imageAssetId,
            createdAt: item.createdAt.timeIntervalSince1970,
            updatedAt: item.updatedAt.timeIntervalSince1970
        )
    }
}
