public import BlogAdminAPI
import BlogApplication
import BlogModule
import FeatherApplication
import FeatherModuleKit
import Foundation

extension AdminAPIGateway {

    public func blogTagQuery(
        _ input: Operations.BlogTagQuery.Input
    ) async throws -> Operations.BlogTagQuery.Output {
        let query: Components.Schemas.TagQueryItemSearchRequestQuerySchema
        switch input.body {
        case .json(let value):
            query = value
        }

        let useCase = self.useCases.makeSearchTags()
        let objectQuery = mapSearchQuery(query)
        let subject = try await CurrentSubject.require()

        let result = try await useCase.execute(
            subject: subject,
            input: .init(query: objectQuery)
        )

        return .ok(
            .init(
                body: .json(
                    .init(
                        query: searchResponseQuery(from: query),
                        data: .init(
                            items: result.items.map(mapSearchItem),
                            total: result.total
                        )
                    )
                )
            )
        )
    }
}

extension AdminAPIGateway {
    private func mapSearchQuery(
        _ query: Components.Schemas.TagQueryItemSearchRequestQuerySchema
    ) -> Tag.Search.Input.Query {
        let sort = (query.sort ?? [])
            .map { item in
                let field: Tag.Search.Input.Query.Sort.Field
                switch item.field {
                case .id: field = .id
                case .title: field = .title
                case .createdAt: field = .createdAt
                case .updatedAt: field = .updatedAt
                }
                return Tag.Search.Input.Query.Sort(
                    field: field,
                    direction: mapTagSortDirection(item.direction)
                )
            }
        return .init(
            page: mapPage(query.page),
            sort: sort,
            search: query.filters.search
        )
    }

    private func searchResponseQuery(
        from query: Components.Schemas.TagQueryItemSearchRequestQuerySchema
    ) -> Components.Schemas.TagQueryItemSearchResponseQuerySchema {
        let page = mapPage(query.page)
        let sort = query.sort?
            .map { item in
                let field:
                    Components.Schemas.TagQueryItemSearchResponseQuerySchema
                        .SortPayloadPayload.FieldPayload
                switch item.field {
                case .id: field = .id
                case .title: field = .title
                case .createdAt: field = .createdAt
                case .updatedAt: field = .updatedAt
                }
                return Components.Schemas.TagQueryItemSearchResponseQuerySchema
                    .SortPayloadPayload(
                        field: field,
                        direction: item.direction
                    )
            }
        return .init(
            page: .init(size: page.size, number: page.number),
            sort: sort,
            filters: .init(search: query.filters.search)
        )
    }

    private func mapSearchItem(
        _ item: Tag.Search.Output.Item
    ) -> Components.Schemas.TagQueryItemSchema {
        .init(
            id: item.id,
            title: item.title,
            excerpt: item.excerpt,
            imageAssetId: item.imageAssetId,
            createdAt: item.createdAt.timeIntervalSince1970,
            updatedAt: item.updatedAt.timeIntervalSince1970
        )
    }

    private func mapPage(_ page: Components.Schemas.SearchPageSchema?)
        -> Search.Page
    {
        let defaults = Search.Page()
        return
            Search.Page(
                size: page?.size ?? defaults.size,
                number: page?.number ?? defaults.number
            )
            .normalized()
    }

    private func mapTagSortDirection(
        _ direction: Components.Schemas.SortDirection
    ) -> Search.SortDirection {
        switch direction {
        case .asc: .asc
        case .desc: .desc
        }
    }
}
