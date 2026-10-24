import FeatherDBAL
public import FeatherInfrastructure
public import WebApplication
import WebDomain
public import WebModule

extension Page.Table.List {
    var asSearchItem: Page.Search.Output.Item {
        .init(
            id: id,
            title: title,
            excerpt: excerpt,
            imageAssetId: imageAssetId,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

extension Page.Search.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func search(
            query: Page.Search.Input.Query
        ) async throws -> Page.Search.Output {
            let page = query.page.normalized()
            let offset = (page.number - 1) * page.size
            let accessLayer = PageSearchQuery(
                connection: context.connection
            )
            let rows = try await context.connection.run(
                query: accessLayer.searchPages(
                    search: query.search,
                    query: query,
                    limit: page.size,
                    offset: offset
                )
            ) { sequence in
                try await sequence.collect().map(Page.Table.List.init(row:))
            }
            let total = try await context.connection.run(
                query: accessLayer.countPages(search: query.search)
            ) { sequence in
                guard let row = try await sequence.first() else { return 0 }
                return try row.decode(column: "count", as: Int.self)
            }
            return .init(items: rows.map(\.asSearchItem), total: total)
        }
    }
}
