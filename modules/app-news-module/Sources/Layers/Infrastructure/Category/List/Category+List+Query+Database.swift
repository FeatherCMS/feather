import FeatherApplication
import FeatherDBAL
public import FeatherInfrastructure
public import NewsApplication
public import NewsModule

extension Category.Table.List {
    var asListItem: Category.List.Output.Item {
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

extension Category.List.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func list(
            query: Category.List.Input.Query
        ) async throws -> Category.List.Output {
            let page = query.page.normalized()
            let pageIndex = page.number - 1
            let offset =
                pageIndex > Int.max / page.size
                ? Int.max
                : pageIndex * page.size
            let accessLayer = DatabaseAccessLayer<Category.Table>(
                context: context
            )

            let items =
                try await accessLayer
                .select(as: Category.Table.List.self) { initial in
                    var result = initial
                    if let search = query.search {
                        result = result.where(
                            searchText: search,
                            columns: [
                                DatabaseQueryTextColumn<Category.Table>(\.id),
                                DatabaseQueryTextColumn<Category.Table>(
                                    \.title
                                ),
                                DatabaseQueryTextColumn<Category.Table>(
                                    \.excerpt
                                ),
                                DatabaseQueryTextColumn<Category.Table>(
                                    \.content
                                ),
                            ]
                        )
                    }
                    let orders = query.sort.map { rule in
                        let direction: DatabaseQueryDirection =
                            rule.direction == .asc ? .ascending : .descending
                        return switch rule.field {
                        case .id:
                            DatabaseQueryOrder<Category.Table>(
                                by: \.id,
                                direction
                            )
                        case .title:
                            DatabaseQueryOrder<Category.Table>(
                                by: \.title,
                                direction
                            )
                        case .createdAt:
                            DatabaseQueryOrder<Category.Table>(
                                by: \.createdAt,
                                direction
                            )
                        case .updatedAt:
                            DatabaseQueryOrder<Category.Table>(
                                by: \.updatedAt,
                                direction
                            )
                        }
                    }
                    let finalOrders =
                        query.sort.contains(where: { $0.field == .id })
                        ? orders
                        : orders + [.init(by: \.id, .ascending)]
                    return result.order(by: finalOrders)
                        .limit(page.size)
                        .offset(offset)
                }
                .map(\.asListItem)

            return .init(items: items)
        }

        public func count(query: Category.List.Input.Query) async throws -> Int
        {
            try await DatabaseAccessLayer<Category.Table>(context: context)
                .selectCount { initial in
                    guard let search = query.search else { return initial }
                    return initial.where(
                        searchText: search,
                        columns: [
                            DatabaseQueryTextColumn<Category.Table>(\.id),
                            DatabaseQueryTextColumn<Category.Table>(\.title),
                            DatabaseQueryTextColumn<Category.Table>(\.excerpt),
                            DatabaseQueryTextColumn<Category.Table>(\.content),
                        ]
                    )
                }
        }
    }
}
