import FeatherApplication
import FeatherDBAL
public import FeatherInfrastructure
public import NewsApplication
import NewsDomain
public import NewsModule

extension Article.Table.List {
    var asQueryListItem: Article.List.Output.Item {
        .init(
            id: id,
            title: title,
            excerpt: excerpt,
            content: content,
            imageAssetId: imageAssetId,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

extension Article.List.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func list(
            query: Article.List.Input.Query
        ) async throws -> Article.List.Output {
            let page = query.page.normalized()
            let pageIndex = page.number - 1
            let offset =
                pageIndex > Int.max / page.size
                ? Int.max
                : pageIndex * page.size
            let items = try await DatabaseAccessLayer<Article.Table>(
                context: context
            )
            .select(as: Article.Table.List.self) { initial in
                var result = initial
                if let search = query.search {
                    result = result.where(
                        searchText: search,
                        columns: [
                            DatabaseQueryTextColumn<Article.Table>(\.id),
                            DatabaseQueryTextColumn<Article.Table>(\.title),
                            DatabaseQueryTextColumn<Article.Table>(\.excerpt),
                            DatabaseQueryTextColumn<Article.Table>(\.content),
                        ]
                    )
                }
                var orders = query.sort.map { rule in
                    let direction: DatabaseQueryDirection =
                        rule.direction == .asc ? .ascending : .descending
                    return switch rule.field {
                    case .id:
                        DatabaseQueryOrder<Article.Table>(by: \.id, direction)
                    case .title:
                        DatabaseQueryOrder<Article.Table>(
                            by: \.title,
                            direction
                        )
                    case .createdAt:
                        DatabaseQueryOrder<Article.Table>(
                            by: \.createdAt,
                            direction
                        )
                    case .updatedAt:
                        DatabaseQueryOrder<Article.Table>(
                            by: \.updatedAt,
                            direction
                        )
                    }
                }
                if !query.sort.contains(where: { $0.field == .id }) {
                    orders.append(.init(by: \.id, .ascending))
                }
                return result.order(by: orders).limit(page.size).offset(offset)
            }
            .map(\.asQueryListItem)
            return .init(items: items)
        }

        public func count(query: Article.List.Input.Query) async throws -> Int {
            try await DatabaseAccessLayer<Article.Table>(context: context)
                .selectCount { initial in
                    guard let search = query.search else { return initial }
                    return initial.where(
                        searchText: search,
                        columns: [
                            DatabaseQueryTextColumn<Article.Table>(\.id),
                            DatabaseQueryTextColumn<Article.Table>(\.title),
                            DatabaseQueryTextColumn<Article.Table>(\.excerpt),
                            DatabaseQueryTextColumn<Article.Table>(\.content),
                        ]
                    )
                }
        }
    }
}
