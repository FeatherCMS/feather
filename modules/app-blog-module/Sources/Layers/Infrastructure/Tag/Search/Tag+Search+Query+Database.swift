public import BlogApplication
public import BlogModule
import FeatherApplication
import FeatherDBAL
public import FeatherInfrastructure

extension Tag.Search.Query {
    public struct Database: Interface {
        let context: DatabaseQueryContext
        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func search(
            query: Tag.Search.Input.Query
        ) async throws -> Tag.Search.Output {
            let page = query.page.normalized()
            let pageIndex = page.number - 1
            let offset =
                pageIndex > Int.max / page.size
                ? Int.max
                : pageIndex * page.size
            let accessLayer = DatabaseAccessLayer<Tag.Table>(context: context)
            let items = try await accessLayer.select(as: Tag.Table.List.self) {
                initial in
                var result = initial
                if let search = query.search {
                    result = result.where(
                        searchText: search,
                        columns: [
                            DatabaseQueryTextColumn<Tag.Table>(\.id),
                            DatabaseQueryTextColumn<Tag.Table>(\.title),
                            DatabaseQueryTextColumn<Tag.Table>(\.excerpt),
                            DatabaseQueryTextColumn<Tag.Table>(\.content),
                        ]
                    )
                }
                let orders = query.sort.map { sort in
                    let direction: DatabaseQueryDirection =
                        sort.direction == .asc ? .ascending : .descending
                    return switch sort.field {
                    case .id:
                        DatabaseQueryOrder<Tag.Table>(by: \.id, direction)
                    case .title:
                        DatabaseQueryOrder<Tag.Table>(by: \.title, direction)
                    case .createdAt:
                        DatabaseQueryOrder<Tag.Table>(
                            by: \.createdAt,
                            direction
                        )
                    case .updatedAt:
                        DatabaseQueryOrder<Tag.Table>(
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
            let total = try await accessLayer.selectCount { initial in
                guard let search = query.search else { return initial }
                return initial.where(
                    searchText: search,
                    columns: [
                        DatabaseQueryTextColumn<Tag.Table>(\.id),
                        DatabaseQueryTextColumn<Tag.Table>(\.title),
                        DatabaseQueryTextColumn<Tag.Table>(\.excerpt),
                        DatabaseQueryTextColumn<Tag.Table>(\.content),
                    ]
                )
            }
            let outputItems = items.map {
                Tag.Search.Output.Item(
                    id: $0.id,
                    title: $0.title,
                    excerpt: $0.excerpt,
                    imageAssetId: $0.imageAssetId,
                    createdAt: $0.createdAt,
                    updatedAt: $0.updatedAt
                )
            }
            return .init(items: outputItems, total: total)
        }
    }
}
