import FeatherApplication
import FeatherDBAL
import FeatherDatabase
import FeatherInfrastructure
import RedirectApplication
import RedirectModule

extension RedirectModule.Rule.Search.Query {
    public struct Database: Interface {
        private let accessLayer: DatabaseAccessLayer<RedirectModule.Rule.Table>

        public init(context: any DatabaseContext) {
            self.accessLayer = .init(context: context)
        }

        public func search(query: Input.Query) async throws -> Output {
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
        ) throws -> Output.Item {
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
            _ query: Input.Query,
            to initialQuery: DatabaseQuerySelect<RedirectModule.Rule.Table>
        ) -> DatabaseQuerySelect<RedirectModule.Rule.Table> {
            var result = initialQuery
            if let search = query.search {
                result = result.where(
                    searchText: search,
                    columns: [
                        .init(\.id),
                        .init(\.source),
                        .init(\.destination),
                        .init(\.notes),
                    ]
                )
            }
            if let statusCode = query.statusCode {
                result = result.where(\.statusCode, equals: statusCode.rawValue)
            }
            return result
        }

        private func databaseOrder(
            for sort: Input.Query.Sort
        ) -> DatabaseQueryOrder<RedirectModule.Rule.Table> {
            let direction: DatabaseQueryDirection =
                switch sort.direction {
                case .asc: .ascending
                case .desc: .descending
                }
            switch sort.field {
            case .id: .init(by: \.id, direction)
            case .source: .init(by: \.source, direction)
            case .destination: .init(by: \.destination, direction)
            case .statusCode: .init(by: \.statusCode, direction)
            case .notes: .init(by: \.notes, direction)
            }
        }

        private func databaseOrders(
            for sorts: [Input.Query.Sort]
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
