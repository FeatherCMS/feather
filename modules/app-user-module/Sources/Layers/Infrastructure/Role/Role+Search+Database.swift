import FeatherApplication
import FeatherDBAL
public import FeatherInfrastructure
public import UserApplication
public import UserModule

extension Role.Table.Row {
    var asSearchItem: Role.Search.Output.Item {
        .init(
            id: id,
            key: key,
            name: name,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

extension Role.Search {
    public struct Database: Role.Search.Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func search(query: Role.Search.Input.Query) async throws
            -> Role.Search.Output
        {
            let accessLayer = DatabaseAccessLayer<Role.Table>(context: context)
            let items =
                try await accessLayer.select(as: Role.Table.Row.self) {
                    initial in
                    var result = initial
                    if let search = query.search {
                        result = result.where(
                            searchText: search,
                            columns: [
                                DatabaseQueryTextColumn<Role.Table>(\.id),
                                DatabaseQueryTextColumn<Role.Table>(\.key),
                                DatabaseQueryTextColumn<Role.Table>(\.name),
                                DatabaseQueryTextColumn<Role.Table>(\.notes),
                            ]
                        )
                    }
                    let page = query.page.normalized()
                    let pageIndex = page.number - 1
                    let offset =
                        pageIndex > Int.max / page.size
                        ? Int.max : pageIndex * page.size
                    return
                        result
                        .order(by: databaseOrders(query.sort))
                        .limit(page.size)
                        .offset(offset)
                }
                .map(\.asSearchItem)

            let total = try await accessLayer.selectCount { initial in
                guard let search = query.search else { return initial }
                return initial.where(
                    searchText: search,
                    columns: [
                        DatabaseQueryTextColumn<Role.Table>(\.id),
                        DatabaseQueryTextColumn<Role.Table>(\.key),
                        DatabaseQueryTextColumn<Role.Table>(\.name),
                        DatabaseQueryTextColumn<Role.Table>(\.notes),
                    ]
                )
            }
            return .init(items: items, total: total)
        }

        private func databaseOrders(
            _ rules: [Role.Search.Input.Query.Sort]
        ) -> [DatabaseQueryOrder<Role.Table>] {
            var orders = rules.map { rule -> DatabaseQueryOrder<Role.Table> in
                let direction: DatabaseQueryDirection =
                    rule.direction == .asc ? .ascending : .descending
                return switch rule.field {
                case .id: DatabaseQueryOrder<Role.Table>(by: \.id, direction)
                case .name:
                    DatabaseQueryOrder<Role.Table>(by: \.name, direction)
                case .notes:
                    DatabaseQueryOrder<Role.Table>(by: \.notes, direction)
                }
            }
            if !rules.contains(where: { $0.field == .id }) {
                orders.append(DatabaseQueryOrder<Role.Table>(by: \.id))
            }
            return orders
        }
    }
}
