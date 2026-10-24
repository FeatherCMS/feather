import FeatherApplication
import FeatherDBAL
public import FeatherInfrastructure
public import SystemApplication
public import SystemModule

extension SystemModule.Permission.List.Query {
    public struct Database: Interface {
        private let accessLayer: DatabaseAccessLayer<Permission.Table>

        public init(context: any DatabaseContext) {
            self.accessLayer = .init(context: context)
        }

        public func list(
            query: SystemModule.Permission.List.Input.Query
        ) async throws -> SystemModule.Permission.List.Output {
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
            query: SystemModule.Permission.List.Input.Query
        ) async throws -> Int {
            try await accessLayer.selectCount { queryBuilder in
                applyFilters(query, to: queryBuilder)
            }
        }

        private func mapListItem(
            _ row: Permission.Table.List
        ) -> SystemModule.Permission.List.Output.Item {
            .init(
                id: row.id,
                key: row.key,
                name: row.name,
                notes: row.notes
            )
        }

        private func applyFilters(
            _ query: SystemModule.Permission.List.Input.Query,
            to initialQuery: DatabaseQuerySelect<Permission.Table>
        ) -> DatabaseQuerySelect<Permission.Table> {
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
                        .init(\.notes),
                    ]
                )
            }
            return result
        }

        private func databaseOrder(
            for rule: SystemModule.Permission.List.Input.Query.Sort
        ) -> DatabaseQueryOrder<Permission.Table> {
            let direction: DatabaseQueryDirection =
                switch rule.direction {
                case .asc: .ascending
                case .desc: .descending
                }

            return switch rule.field {
            case .key: DatabaseQueryOrder(by: \.key, direction)
            case .name: DatabaseQueryOrder(by: \.name, direction)
            case .notes: DatabaseQueryOrder(by: \.notes, direction)
            }
        }

        private func databaseOrders(
            for rules: [SystemModule.Permission.List.Input.Query.Sort]
        ) -> [DatabaseQueryOrder<Permission.Table>] {
            var orderings = rules.map(databaseOrder)
            if !rules.contains(where: { $0.field == .key }) {
                orderings.append(.init(by: \.key, .ascending))
            }
            return orderings
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
