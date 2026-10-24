import FeatherApplication
import FeatherDBAL
public import FeatherInfrastructure
public import NewsletterApplication
public import NewsletterModule

extension Campaign.Search.Query {
    public struct Database: Interface {
        private let accessLayer: DatabaseAccessLayer<Campaign.Table>

        public init(context: any DatabaseContext) {
            self.accessLayer = .init(context: context)
        }

        public func search(
            query: Campaign.Search.Input.Query
        ) async throws -> Campaign.Search.Output {
            let items =
                try await accessLayer
                .select(as: Campaign.Table.List.self) { initial in
                    paginatedQuery(
                        applyFilters(query, to: initial)
                            .order(by: databaseOrders(for: query.sort)),
                        using: query.page
                    )
                }
                .map {
                    Campaign.Search.Output.Item(
                        id: $0.id,
                        key: $0.key,
                        name: $0.name,
                        fromEmail: $0.fromEmail
                    )
                }
            let total = try await accessLayer.selectCount { initial in
                applyFilters(query, to: initial)
            }
            return .init(items: items, total: total)
        }

        private func applyFilters(
            _ query: Campaign.Search.Input.Query,
            to initial: DatabaseQuerySelect<Campaign.Table>
        ) -> DatabaseQuerySelect<Campaign.Table> {
            guard let search = query.search, !search.isEmpty else {
                return initial
            }
            return initial.where(
                searchText: search,
                columns: [
                    DatabaseQueryTextColumn<Campaign.Table>(\.key),
                    DatabaseQueryTextColumn<Campaign.Table>(\.name),
                    DatabaseQueryTextColumn<Campaign.Table>(\.fromEmail),
                ]
            )
        }

        private func databaseOrders(
            for rules: [Campaign.Search.Input.Query.Sort]
        ) -> [DatabaseQueryOrder<Campaign.Table>] {
            var orders = rules.map { rule in
                let direction: DatabaseQueryDirection =
                    rule.direction == .asc ? .ascending : .descending
                return switch rule.field {
                case .key:
                    DatabaseQueryOrder<Campaign.Table>(by: \.key, direction)
                case .name:
                    DatabaseQueryOrder<Campaign.Table>(by: \.name, direction)
                }
            }
            if !rules.contains(where: { $0.field == .name }) {
                orders.append(.init(by: \.name, .ascending))
            }
            if !rules.contains(where: { $0.field == .key }) {
                orders.append(.init(by: \.key, .ascending))
            }
            return orders
        }

        private func paginatedQuery(
            _ query: DatabaseQuerySelect<Campaign.Table>,
            using page: FeatherApplication.Search.Page
        ) -> DatabaseQuerySelect<Campaign.Table> {
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
