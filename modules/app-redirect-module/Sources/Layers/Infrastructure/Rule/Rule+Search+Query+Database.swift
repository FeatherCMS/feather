import FeatherApplication
import FeatherDBAL
public import FeatherInfrastructure
public import RedirectApplication
public import RedirectModule

extension Rule.Search.Query {
    public struct Database: Interface {
        private let accessLayer: DatabaseAccessLayer<Rule.Table>

        public init(context: any DatabaseContext) {
            self.accessLayer = .init(context: context)
        }

        public func search(
            query: Rule.Search.Input.Query
        ) async throws -> Rule.Search.Output {
            let items =
                try await accessLayer.select { queryBuilder in
                    paginatedQuery(
                        applyFilters(query, to: queryBuilder)
                            .order(by: databaseOrders(for: query.sort)),
                        using: query.page
                    )
                }
                .map(mapItem)

            let total = try await accessLayer.selectCount { queryBuilder in
                applyFilters(query, to: queryBuilder)
            }
            return .init(items: items, total: total)
        }

        private func mapItem(
            _ row: Rule.Table.List
        ) throws -> Rule.Search.Output.Item {
            guard
                let statusCode = Rule.StatusCode(
                    rawValue: row.statusCode
                )
            else {
                throw RepositoryError.invalidEnumValue(String(row.statusCode))
            }
            return .init(
                id: row.id,
                source: row.source,
                destination: row.destination,
                statusCode: statusCode,
                notes: row.notes,
                createdAt: row.createdAt,
                updatedAt: row.updatedAt
            )
        }

        private func applyFilters(
            _ query: Rule.Search.Input.Query,
            to initialQuery: DatabaseQuerySelect<Rule.Table>
        ) -> DatabaseQuerySelect<Rule.Table> {
            var result = initialQuery
            if let search = query.search {
                result = result.where(
                    searchText: search,
                    columns: [
                        DatabaseQueryTextColumn<Rule.Table>(
                            \.id
                        ),
                        DatabaseQueryTextColumn<Rule.Table>(
                            \.source
                        ),
                        DatabaseQueryTextColumn<Rule.Table>(
                            \.destination
                        ),
                        DatabaseQueryTextColumn<Rule.Table>(
                            \.notes
                        ),
                    ]
                )
            }
            if let statusCode = query.statusCode {
                result = result.where(\.statusCode, equals: statusCode.rawValue)
            }
            return result
        }

        private func databaseOrder(
            for sort: Rule.Search.Input.Query.Sort
        ) -> DatabaseQueryOrder<Rule.Table> {
            let direction: DatabaseQueryDirection =
                switch sort.direction {
                case .asc: .ascending
                case .desc: .descending
                }
            return switch sort.field {
            case .id:
                DatabaseQueryOrder<Rule.Table>(
                    by: \.id,
                    direction
                )
            case .source:
                DatabaseQueryOrder<Rule.Table>(
                    by: \.source,
                    direction
                )
            case .destination:
                DatabaseQueryOrder<Rule.Table>(
                    by: \.destination,
                    direction
                )
            case .statusCode:
                DatabaseQueryOrder<Rule.Table>(
                    by: \.statusCode,
                    direction
                )
            case .notes:
                DatabaseQueryOrder<Rule.Table>(
                    by: \.notes,
                    direction
                )
            }
        }

        private func databaseOrders(
            for sorts: [Rule.Search.Input.Query.Sort]
        ) -> [DatabaseQueryOrder<Rule.Table>] {
            var result = sorts.map(databaseOrder)
            if !sorts.contains(where: { $0.field == .id }) {
                result.append(.init(by: \.id, .ascending))
            }
            return result
        }

        private func paginatedQuery(
            _ query: DatabaseQuerySelect<Rule.Table>,
            using page: FeatherApplication.Search.Page
        ) -> DatabaseQuerySelect<Rule.Table> {
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
