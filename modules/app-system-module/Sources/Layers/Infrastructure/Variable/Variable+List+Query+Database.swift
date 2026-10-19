import FeatherApplication
import FeatherDBAL
public import FeatherInfrastructure
public import SystemApplication
public import SystemModule

extension SystemModule.Variable.List.Query {
    public struct Database: SystemModule.Variable.List.Query.Interface {
        private let accessLayer: DatabaseAccessLayer<Variable.Table>

        public init(context: any DatabaseContext) {
            self.accessLayer = .init(context: context)
        }

        public func list(
            query: SystemModule.Variable.List.Input.Query
        ) async throws -> SystemModule.Variable.List.Output {
            let items =
                try await accessLayer.select { queryBuilder in
                    paginatedQuery(
                        applyFilters(query, to: queryBuilder)
                            .order(by: databaseOrders(for: query.sort)),
                        using: query.page
                    )
                }
                .map(mapListItem)

            return .init(items: items)
        }

        public func count(
            query: SystemModule.Variable.List.Input.Query
        ) async throws -> Int {
            try await accessLayer.selectCount { queryBuilder in
                applyFilters(query, to: queryBuilder)
            }
        }

        private func mapListItem(
            _ row: Variable.Table.List
        ) -> SystemModule.Variable.List.Output.Item {
            .init(
                id: row.id,
                key: row.key,
                value: row.value,
                name: row.name,
                notes: row.notes
            )
        }

        private func applyFilters(
            _ query: SystemModule.Variable.List.Input.Query,
            to initialQuery: DatabaseQuerySelect<Variable.Table>
        ) -> DatabaseQuerySelect<Variable.Table> {
            var result = initialQuery
            if let ids = query.ids, !ids.isEmpty {
                result = result.where(\.id, in: ids)
            }
            if let search = query.search {
                result = result.where(
                    searchText: search,
                    columns: [
                        .init(\.key),
                        .init(\.name),
                        .init(\.value),
                        .init(\.notes),
                    ]
                )
            }
            return result
        }

        private func databaseOrder(
            for rule: SystemModule.Variable.List.Input.Query.Sort
        ) -> DatabaseQueryOrder<Variable.Table> {
            let direction: DatabaseQueryDirection =
                switch rule.direction {
                case .asc: .ascending
                case .desc: .descending
                }

            return switch rule.field {
            case .key: DatabaseQueryOrder(by: \.key, direction)
            case .name: DatabaseQueryOrder(by: \.name, direction)
            case .value: DatabaseQueryOrder(by: \.value, direction)
            case .notes: DatabaseQueryOrder(by: \.notes, direction)
            }
        }

        private func databaseOrders(
            for rules: [SystemModule.Variable.List.Input.Query.Sort]
        ) -> [DatabaseQueryOrder<Variable.Table>] {
            var orderings = rules.map(databaseOrder)
            if !rules.contains(where: { $0.field == .key }) {
                orderings.append(.init(by: \.key, .ascending))
            }
            return orderings
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
