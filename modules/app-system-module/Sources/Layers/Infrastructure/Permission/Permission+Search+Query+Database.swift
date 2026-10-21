import FeatherApplication
import FeatherDBAL
public import FeatherInfrastructure
public import SystemApplication
public import SystemModule

extension SystemModule.Permission.Search.Query {
    public struct Database: Interface {
        private let accessLayer: DatabaseAccessLayer<Permission.Table>

        public init(context: any DatabaseContext) {
            self.accessLayer = .init(context: context)
        }

        public func search(
            query: SystemModule.Permission.Search.Input.Query
        ) async throws -> SystemModule.Permission.Search.Output {
            let items =
                try await accessLayer
                .select(as: Permission.Table.List.self) { initial in
                    paginatedQuery(
                        applyFilters(query, to: initial)
                            .order(by: databaseOrders(for: query.sort)),
                        using: query.page
                    )
                }
                .map {
                    SystemModule.Permission.Search.Output.Item(
                        id: $0.id,
                        key: $0.key,
                        name: $0.name,
                        notes: $0.notes
                    )
                }

            let total = try await accessLayer.selectCount { initial in
                applyFilters(query, to: initial)
            }
            return .init(items: items, total: total)
        }

        private func applyFilters(
            _ query: SystemModule.Permission.Search.Input.Query,
            to initial: DatabaseQuerySelect<Permission.Table>
        ) -> DatabaseQuerySelect<Permission.Table> {
            var result = initial
            if let ids = query.ids, !ids.isEmpty {
                result = result.where(\.id, in: ids)
            }
            if let search = query.search {
                result = result.where(
                    searchText: search,
                    columns: [
                        DatabaseQueryTextColumn<Permission.Table>(\.key),
                        DatabaseQueryTextColumn<Permission.Table>(\.name),
                        DatabaseQueryTextColumn<Permission.Table>(\.notes),
                    ]
                )
            }
            return result
        }

        private func databaseOrders(
            for rules: [SystemModule.Permission.Search.Input.Query.Sort]
        ) -> [DatabaseQueryOrder<Permission.Table>] {
            var orders = rules.map { rule in
                let direction: DatabaseQueryDirection =
                    rule.direction == .asc ? .ascending : .descending
                return switch rule.field {
                case .key:
                    DatabaseQueryOrder<Permission.Table>(by: \.key, direction)
                case .name:
                    DatabaseQueryOrder<Permission.Table>(by: \.name, direction)
                case .notes:
                    DatabaseQueryOrder<Permission.Table>(
                        by: \.notes,
                        direction
                    )
                }
            }
            if !rules.contains(where: { $0.field == .key }) {
                orders.append(.init(by: \.key, .ascending))
            }
            return orders
        }

        private func paginatedQuery(
            _ query: DatabaseQuerySelect<Permission.Table>,
            using page: Search.Page
        ) -> DatabaseQuerySelect<Permission.Table> {
            let page = page.normalized()
            let pageIndex = page.number - 1
            let offset =
                pageIndex > Int.max / page.size
                ? Int.max
                : pageIndex * page.size
            return query.limit(page.size).offset(offset)
        }
    }
}
