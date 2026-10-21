import FeatherApplication
import FeatherDBAL
public import FeatherInfrastructure
public import SystemApplication
public import SystemModule

extension SystemModule.Variable.Search.Query {
    public struct Database: SystemModule.Variable.Search.Query.Interface {
        private let accessLayer: DatabaseAccessLayer<Variable.Table>

        public init(context: any DatabaseContext) {
            self.accessLayer = .init(context: context)
        }

        public func search(
            query: SystemModule.Variable.Search.Input.Query
        ) async throws -> SystemModule.Variable.Search.Output {
            let items =
                try await accessLayer
                .select(as: Variable.Table.List.self) { initial in
                    paginatedQuery(
                        applyFilters(query, to: initial)
                            .order(by: databaseOrders(for: query.sort)),
                        using: query.page
                    )
                }
                .map {
                    SystemModule.Variable.Search.Output.Item(
                        id: $0.id,
                        key: $0.key,
                        value: $0.value,
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
            _ query: SystemModule.Variable.Search.Input.Query,
            to initial: DatabaseQuerySelect<Variable.Table>
        ) -> DatabaseQuerySelect<Variable.Table> {
            var result = initial
            if let ids = query.ids, !ids.isEmpty {
                result = result.where(\.id, in: ids)
            }
            if let search = query.search {
                result = result.where(
                    searchText: search,
                    columns: [
                        DatabaseQueryTextColumn<Variable.Table>(\.key),
                        DatabaseQueryTextColumn<Variable.Table>(\.name),
                        DatabaseQueryTextColumn<Variable.Table>(\.value),
                        DatabaseQueryTextColumn<Variable.Table>(\.notes),
                    ]
                )
            }
            return result
        }

        private func databaseOrders(
            for rules: [SystemModule.Variable.Search.Input.Query.Sort]
        ) -> [DatabaseQueryOrder<Variable.Table>] {
            var orders = rules.map { rule in
                let direction: DatabaseQueryDirection =
                    rule.direction == .asc ? .ascending : .descending
                return switch rule.field {
                case .key:
                    DatabaseQueryOrder<Variable.Table>(by: \.key, direction)
                case .name:
                    DatabaseQueryOrder<Variable.Table>(by: \.name, direction)
                case .value:
                    DatabaseQueryOrder<Variable.Table>(by: \.value, direction)
                case .notes:
                    DatabaseQueryOrder<Variable.Table>(by: \.notes, direction)
                }
            }
            if !rules.contains(where: { $0.field == .key }) {
                orders.append(.init(by: \.key, .ascending))
            }
            return orders
        }

        private func paginatedQuery(
            _ query: DatabaseQuerySelect<Variable.Table>,
            using page: Search.Page
        ) -> DatabaseQuerySelect<Variable.Table> {
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
