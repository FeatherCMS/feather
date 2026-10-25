public import BlogApplication
public import BlogModule
import FeatherApplication
import FeatherDBAL
public import FeatherInfrastructure

extension Author.Table.List {
    var asSearchItem: Author.Search.Output.Item {
        .init(
            id: id,
            name: name,
            excerpt: excerpt,
            profileImageAssetId: profileImageAssetId,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

extension Author.Search.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func search(query: Author.Search.Input.Query) async throws
            -> Author.Search.Output
        {
            let accessLayer = DatabaseAccessLayer<Author.Table>(
                context: context
            )
            let page = query.page.normalized()
            let pageIndex = page.number - 1
            let offset =
                pageIndex > Int.max / page.size
                ? Int.max : pageIndex * page.size
            let items = try await accessLayer.select(as: Author.Table.List.self)
            { initial in
                var result = initial
                if let search = query.search {
                    result = result.where(
                        searchText: search,
                        columns: [
                            DatabaseQueryTextColumn<Author.Table>(\.id),
                            DatabaseQueryTextColumn<Author.Table>(\.name),
                            DatabaseQueryTextColumn<Author.Table>(\.excerpt),
                            DatabaseQueryTextColumn<Author.Table>(\.content),
                        ]
                    )
                }
                let orders = query.sort.map { sort in
                    let direction: DatabaseQueryDirection =
                        sort.direction == .asc ? .ascending : .descending
                    return switch sort.field {
                    case .id:
                        DatabaseQueryOrder<Author.Table>(by: \.id, direction)
                    case .key:
                        DatabaseQueryOrder<Author.Table>(by: \.key, direction)
                    case .name:
                        DatabaseQueryOrder<Author.Table>(by: \.name, direction)
                    case .createdAt:
                        DatabaseQueryOrder<Author.Table>(
                            by: \.createdAt,
                            direction
                        )
                    case .updatedAt:
                        DatabaseQueryOrder<Author.Table>(
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
            let total = try await DatabaseAccessLayer<Author.Table>(
                context: context
            )
            .selectCount { initial in
                guard let search = query.search else { return initial }
                return initial.where(
                    searchText: search,
                    columns: [
                        DatabaseQueryTextColumn<Author.Table>(\.id),
                        DatabaseQueryTextColumn<Author.Table>(\.name),
                        DatabaseQueryTextColumn<Author.Table>(\.excerpt),
                        DatabaseQueryTextColumn<Author.Table>(\.content),
                    ]
                )
            }
            return .init(items: items.map(\.asSearchItem), total: total)
        }
    }
}
