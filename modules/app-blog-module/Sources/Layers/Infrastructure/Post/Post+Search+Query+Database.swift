public import BlogApplication
public import BlogModule
import FeatherApplication
import FeatherDBAL
public import FeatherInfrastructure

extension Post.Search.Query {
    public struct Database: Interface {
        let context: DatabaseQueryContext
        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func search(
            query: Post.Search.Input.Query
        ) async throws -> Post.Search.Output {
            let page = query.page.normalized()
            let pageIndex = page.number - 1
            let offset =
                pageIndex > Int.max / page.size
                ? Int.max
                : pageIndex * page.size
            let rows = try await DatabaseAccessLayer<Post.Table>(
                context: context
            )
            .select(as: Post.Table.List.self) { initial in
                var result = initial
                if let search = query.search {
                    result = result.where(
                        searchText: search,
                        columns: [
                            DatabaseQueryTextColumn<Post.Table>(\.id),
                            DatabaseQueryTextColumn<Post.Table>(\.title),
                            DatabaseQueryTextColumn<Post.Table>(\.excerpt),
                            DatabaseQueryTextColumn<Post.Table>(\.content),
                        ]
                    )
                }
                let orders = query.sort.map { sort in
                    let direction: DatabaseQueryDirection =
                        sort.direction == .asc ? .ascending : .descending
                    return switch sort.field {
                    case .id:
                        DatabaseQueryOrder<Post.Table>(by: \.id, direction)
                    case .title:
                        DatabaseQueryOrder<Post.Table>(by: \.title, direction)
                    case .createdAt:
                        DatabaseQueryOrder<Post.Table>(
                            by: \.createdAt,
                            direction
                        )
                    case .updatedAt:
                        DatabaseQueryOrder<Post.Table>(
                            by: \.updatedAt,
                            direction
                        )
                    }
                }
                return
                    result
                    .order(by: orders + [.init(by: \.id, .ascending)])
                    .limit(page.size)
                    .offset(offset)
            }
            let total = try await DatabaseAccessLayer<Post.Table>(
                context: context
            )
            .selectCount { initial in
                guard let search = query.search else { return initial }
                return initial.where(
                    searchText: search,
                    columns: [
                        DatabaseQueryTextColumn<Post.Table>(\.id),
                        DatabaseQueryTextColumn<Post.Table>(\.title),
                        DatabaseQueryTextColumn<Post.Table>(\.excerpt),
                        DatabaseQueryTextColumn<Post.Table>(\.content),
                    ]
                )
            }
            let items = rows.map { item in
                Post.Search.Output.Item(
                    id: item.id,
                    title: item.title,
                    excerpt: item.excerpt,
                    imageAssetId: item.imageAssetId,
                    createdAt: item.createdAt,
                    updatedAt: item.updatedAt
                )
            }
            return .init(items: items, total: total)
        }
    }
}
