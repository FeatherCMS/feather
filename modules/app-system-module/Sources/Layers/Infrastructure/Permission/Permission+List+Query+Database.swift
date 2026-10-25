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
                    applyFilters(query, to: queryBuilder)
                        .order(by: \.key, .ascending)
                        .limit(min(max(query.limit ?? 20, 1), 100))
                }
                .map(mapListItem)

            return .init(items: items)
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
    }
}
