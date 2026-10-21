import FeatherApplication
import FeatherDBAL
public import FeatherInfrastructure
public import RedirectApplication
public import RedirectModule

extension RedirectModule.Rule.Search.Query {
    public struct Database: Interface {
        private let accessLayer: DatabaseAccessLayer<RedirectModule.Rule.Table>

        public init(context: any DatabaseContext) {
            self.accessLayer = .init(context: context)
        }

        public func search(
            query: RedirectModule.Rule.Search.Input.Query
        ) async throws -> RedirectModule.Rule.Search.Output {
            let items = try await accessLayer.select { queryBuilder in
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
            _ row: RedirectModule.Rule.Table.List
        ) throws -> RedirectModule.Rule.Search.Output.Item {
            guard let statusCode = RedirectModule.Rule.StatusCode(
                rawValue: row.statusCode
            ) else {
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
            _ query: RedirectModule.Rule.Search.Input.Query,
            to initialQuery: DatabaseQuerySelect<RedirectModule.Rule.Table>
        ) -> DatabaseQuerySelect<RedirectModule.Rule.Table> {
            var result = initialQuery
            if let search = query.search {
                result = result.where(
                    searchText: search,
                    columns: [
                        DatabaseQueryTextColumn<RedirectModule.Rule.Table>(
                            \.id
                        ),
                        DatabaseQueryTextColumn<RedirectModule.Rule.Table>(
                            \.source
                        ),
                        DatabaseQueryTextColumn<RedirectModule.Rule.Table>(
                            \.destination
                        ),
                        DatabaseQueryTextColumn<RedirectModule.Rule.Table>(
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
            for sort: RedirectModule.Rule.Search.Input.Query.Sort
        ) -> DatabaseQueryOrder<RedirectModule.Rule.Table> {
            let direction: DatabaseQueryDirection =
                switch sort.direction {
                case .asc: .ascending
                case .desc: .descending
                }
            return switch sort.field {
            case .id:
                DatabaseQueryOrder<RedirectModule.Rule.Table>(
                    by: \.id,
                    direction
                )
            case .source:
                DatabaseQueryOrder<RedirectModule.Rule.Table>(
                    by: \.source,
                    direction
                )
            case .destination:
                DatabaseQueryOrder<RedirectModule.Rule.Table>(
                    by: \.destination,
                    direction
                )
            case .statusCode:
                DatabaseQueryOrder<RedirectModule.Rule.Table>(
                    by: \.statusCode,
                    direction
                )
            case .notes:
                DatabaseQueryOrder<RedirectModule.Rule.Table>(
                    by: \.notes,
                    direction
                )
            }
        }

        private func databaseOrders(
            for sorts: [RedirectModule.Rule.Search.Input.Query.Sort]
        ) -> [DatabaseQueryOrder<RedirectModule.Rule.Table>] {
            var result = sorts.map(databaseOrder)
            if !sorts.contains(where: { $0.field == .id }) {
                result.append(.init(by: \.id, .ascending))
            }
            return result
        }

        private func paginatedQuery(
            _ query: DatabaseQuerySelect<RedirectModule.Rule.Table>,
            using page: FeatherApplication.Search.Page
        ) -> DatabaseQuerySelect<RedirectModule.Rule.Table> {
            let page = page.normalized()
            let pageIndex = page.number - 1
            let offset = pageIndex > Int.max / page.size
                ? Int.max
                : pageIndex * page.size
            return query.limit(page.size).offset(offset)
        }
    }
}
