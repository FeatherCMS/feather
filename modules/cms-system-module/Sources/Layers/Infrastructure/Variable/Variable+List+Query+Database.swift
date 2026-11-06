import FeatherDBAL
public import FeatherInfrastructure
public import SystemApplication
public import SystemModule

extension SystemModule.Variable.List.Query {
    public struct Database: Interface {
        private let accessLayer: DatabaseAccessLayer<Variable.Table>

        public init(context: any DatabaseContext) {
            self.accessLayer = .init(context: context)
        }

        public func list(
            query: SystemModule.Variable.List.Input.Query
        ) async throws -> SystemModule.Variable.List.Output {
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
    }
}
