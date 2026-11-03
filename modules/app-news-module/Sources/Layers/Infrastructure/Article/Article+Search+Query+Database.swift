import FeatherApplication
import FeatherDBAL
import FeatherDatabase
public import FeatherInfrastructure
public import NewsApplication
import NewsDomain
public import NewsModule

extension Article.Search.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func search(
            query: Article.Search.Input.Query
        ) async throws -> Article.Search.Output {
            let page = query.page.normalized()
            let pageIndex = page.number - 1
            let offset =
                pageIndex > Int.max / page.size
                ? Int.max
                : pageIndex * page.size
            let accessLayer = AccessLayer(
                connection: context.connection
            )
            let rows = try await context.connection.run(
                query: accessLayer.searchArticles(
                    search: query.search,
                    query: query,
                    limit: page.size,
                    offset: offset
                )
            ) { sequence in
                try await sequence.collect().map(Article.Table.List.init(row:))
            }
            let total = try await context.connection.run(
                query: accessLayer.countArticles(search: query.search)
            ) { sequence in
                guard let row = try await sequence.first() else { return 0 }
                return try row.decode(column: "count", as: Int.self)
            }
            return .init(
                items: rows.map {
                    .init(
                        id: $0.id,
                        title: $0.title,
                        excerpt: $0.excerpt,
                        content: $0.content,
                        imageAssetId: $0.imageAssetId,
                        createdAt: $0.createdAt,
                        updatedAt: $0.updatedAt
                    )
                },
                total: total
            )
        }
    }
}
