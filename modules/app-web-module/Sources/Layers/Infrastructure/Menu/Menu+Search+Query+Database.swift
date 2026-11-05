import FeatherApplication
import FeatherDBAL
public import FeatherInfrastructure
public import WebApplication
import WebDomain
public import WebModule

extension Menu.Table.List {
    var asSearchItem: Menu.Search.Output.Item {
        .init(
            id: id,
            key: key,
            name: name,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

extension Menu.Search.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func search(
            query: Menu.Search.Input.Query
        ) async throws -> Menu.Search.Output {
            let accessLayer = DatabaseAccessLayer<Menu.Table>(context: context)
            let page = query.page.normalized()
            let pageIndex = page.number - 1
            let offset =
                pageIndex > Int.max / page.size
                ? Int.max : pageIndex * page.size
            let items =
                try await accessLayer.select { initial in
                    var result = initial
                    if let search = query.search {
                        result = result.where(
                            searchText: search,
                            columns: [
                                DatabaseQueryTextColumn<Menu.Table>(\.id),
                                DatabaseQueryTextColumn<Menu.Table>(\.key),
                                DatabaseQueryTextColumn<Menu.Table>(\.name),
                                DatabaseQueryTextColumn<Menu.Table>(\.notes),
                            ]
                        )
                    }
                    let orders = query.sort.map { sort in
                        let direction: DatabaseQueryDirection =
                            sort.direction == .asc ? .ascending : .descending
                        return switch sort.field {
                        case .id:
                            DatabaseQueryOrder<Menu.Table>(by: \.id, direction)
                        case .key:
                            DatabaseQueryOrder<Menu.Table>(by: \.key, direction)
                        case .name:
                            DatabaseQueryOrder<Menu.Table>(
                                by: \.name,
                                direction
                            )
                        case .createdAt:
                            DatabaseQueryOrder<Menu.Table>(
                                by: \.createdAt,
                                direction
                            )
                        case .updatedAt:
                            DatabaseQueryOrder<Menu.Table>(
                                by: \.updatedAt,
                                direction
                            )
                        }
                    }
                    return
                        result.order(by: orders + [.init(by: \.id, .ascending)])
                        .limit(page.size)
                        .offset(offset)
                }
                .map(\.asSearchItem)
            let total = try await accessLayer.selectCount { initial in
                guard let search = query.search else { return initial }
                return initial.where(
                    searchText: search,
                    columns: [
                        DatabaseQueryTextColumn<Menu.Table>(\.id),
                        DatabaseQueryTextColumn<Menu.Table>(\.key),
                        DatabaseQueryTextColumn<Menu.Table>(\.name),
                        DatabaseQueryTextColumn<Menu.Table>(\.notes),
                    ]
                )
            }
            return .init(items: items, total: total)
        }
    }
}
