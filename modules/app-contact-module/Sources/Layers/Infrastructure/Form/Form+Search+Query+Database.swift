public import ContactApplication
public import ContactModule
import FeatherApplication
import FeatherDBAL
public import FeatherInfrastructure

extension Form.Search.Query {
    public struct Database: Interface {
        private let accessLayer: DatabaseAccessLayer<Form.Table>

        public init(context: any DatabaseContext) {
            self.accessLayer = .init(context: context)
        }

        public func search(
            query: Form.Search.Input.Query
        ) async throws -> Form.Search.Output {
            let items =
                try await accessLayer
                .select(as: Form.Table.List.self) { initial in
                    paginatedQuery(
                        applyFilters(query, to: initial)
                            .order(by: databaseOrders(for: query.sort)),
                        using: query.page
                    )
                }
                .map {
                    Form.Search.Output.Item(
                        id: $0.id,
                        key: $0.key,
                        name: $0.name
                    )
                }

            let total = try await accessLayer.selectCount { initial in
                applyFilters(query, to: initial)
            }
            return .init(items: items, total: total)
        }

        private func applyFilters(
            _ query: Form.Search.Input.Query,
            to initial: DatabaseQuerySelect<Form.Table>
        ) -> DatabaseQuerySelect<Form.Table> {
            guard let search = query.search, !search.isEmpty else {
                return initial
            }
            return initial.where(
                searchText: search,
                columns: [
                    DatabaseQueryTextColumn<Form.Table>(\.key),
                    DatabaseQueryTextColumn<Form.Table>(\.name),
                ]
            )
        }

        private func databaseOrders(
            for rules: [Form.Search.Input.Query.Sort]
        ) -> [DatabaseQueryOrder<Form.Table>] {
            var orders = rules.map { rule in
                let direction: DatabaseQueryDirection =
                    rule.direction == .asc ? .ascending : .descending
                return switch rule.field {
                case .key:
                    DatabaseQueryOrder<Form.Table>(by: \.key, direction)
                case .name:
                    DatabaseQueryOrder<Form.Table>(by: \.name, direction)
                }
            }
            if !rules.contains(where: { $0.field == .name }) {
                orders.append(.init(by: \.name, .ascending))
            }
            return orders
        }

        private func paginatedQuery(
            _ query: DatabaseQuerySelect<Form.Table>,
            using page: Search.Page
        ) -> DatabaseQuerySelect<Form.Table> {
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
