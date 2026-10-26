import FeatherApplication
import FeatherModuleKit
import Foundation
public import WebAdminAPI
import WebApplication
import WebModule

extension AdminAPIGateway {

    public func pageQuery(
        _ input: Operations.PageQuery.Input
    ) async throws -> Operations.PageQuery.Output {
        let query: Components.Schemas.PageQueryItemSearchRequestQuerySchema
        switch input.body {
        case .json(let value):
            query = value
        }

        let useCase = useCases.makeSearchPages()
        let objectQuery = mapPageSearchQuery(query)
        let subject = try await CurrentSubject.require()

        let result = try await useCase.execute(
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
                            sort: objectQuery.sort.map { sort in
                                let field:
                                    Components.Schemas
                                        .PageQueryItemSearchResponseQuerySchema
                                        .SortPayloadPayload.FieldPayload
                                switch sort.field {
                                case .id: field = .id
                                case .title: field = .title
                                case .createdAt: field = .createdAt
                                case .updatedAt: field = .updatedAt
                                }
                                return .init(
                                    field: field,
                                    direction: sort.direction == .asc
                                        ? .asc : .desc
                                )
                            },
                            filters: .init(search: objectQuery.search)
                        ),
                        data: .init(
                            items: result.items.map(mapPageSearchItem),
                            total: result.total
                        )
                    )
                )
            )
        )
    }

    private func mapPageSearchQuery(
        _ query: Components.Schemas.PageQueryItemSearchRequestQuerySchema
    ) -> Page.Search.Input.Query {
        .init(
            page: .init(
                size: query.page?.size ?? 20,
                number: query.page?.number ?? 1
            ),
            sort: query.sort?
                .compactMap { sort in
                    guard
                        let field = Page.Search.Input.Query.Sort.Field(
                            rawValue: sort.field.rawValue
                        )
                    else {
                        return nil
                    }
                    return .init(
                        field: field,
                        direction: sort.direction == .asc ? .asc : .desc
                    )
                } ?? [],
            search: query.filters.search
        )
    }

    private func mapPageSearchItem(
        _ item: Page.Search.Output.Item
    ) -> Components.Schemas.PageQueryItemSchema {
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
