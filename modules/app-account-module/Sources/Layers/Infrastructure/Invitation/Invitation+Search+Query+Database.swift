public import AccountApplication
public import AccountModule
import FeatherApplication
import FeatherDBAL
public import FeatherInfrastructure

extension Invitation.Search.Query {
    public struct Database: Interface {
        private let accessLayer: DatabaseAccessLayer<Invitation.Table>

        public init(context: any DatabaseContext) {
            self.accessLayer = .init(context: context)
        }

        public func search(
            query: Invitation.Search.Input.Query
        ) async throws -> Invitation.Search.Output {
            let items = try await accessLayer.select(
                as: Invitation.Table.List.self
            ) {
                paginatedQuery(
                    applyFilters(query, to: $0)
                        .order(by: databaseOrders(for: query.sort)),
                    using: query.page
                )
            }
            let total = try await accessLayer.selectCount {
                applyFilters(query, to: $0)
            }
            return .init(
                items: try items.map { try $0.asSearchItem() },
                total: total
            )
        }

        private func applyFilters(
            _ query: Invitation.Search.Input.Query,
            to initial: DatabaseQuerySelect<Invitation.Table>
        ) -> DatabaseQuerySelect<Invitation.Table> {
            guard let search = query.search, !search.isEmpty else {
                return initial
            }
            return initial.where(
                searchText: search,
                columns: [
                    DatabaseQueryTextColumn<Invitation.Table>(\.id),
                    DatabaseQueryTextColumn<Invitation.Table>(\.email),
                    DatabaseQueryTextColumn<Invitation.Table>(\.token),
                ]
            )
        }

        private func databaseOrder(
            for rule: Invitation.Search.Input.Query.Sort
        ) -> DatabaseQueryOrder<Invitation.Table> {
            let direction: DatabaseQueryDirection =
                switch rule.direction {
                case .asc: .ascending
                case .desc: .descending
                }

            return switch rule.field {
            case .id: DatabaseQueryOrder(by: \.id, direction)
            case .email: DatabaseQueryOrder(by: \.email, direction)
            case .token: DatabaseQueryOrder(by: \.token, direction)
            case .expiresAt: DatabaseQueryOrder(by: \.expiresAt, direction)
            }
        }

        private func databaseOrders(
            for rules: [Invitation.Search.Input.Query.Sort]
        ) -> [DatabaseQueryOrder<Invitation.Table>] {
            var orderings = rules.map(databaseOrder)
            if !rules.contains(where: { $0.field == .id }) {
                orderings.append(.init(by: \.id, .ascending))
            }
            return orderings
        }

        private func paginatedQuery(
            _ query: DatabaseQuerySelect<Invitation.Table>,
            using page: Search.Page
        ) -> DatabaseQuerySelect<Invitation.Table> {
            let page = page.normalized()
            let pageIndex = page.number - 1
            let offset =
                pageIndex > Int.max / page.size
                ? Int.max : pageIndex * page.size
            return query.limit(page.size).offset(offset)
        }
    }
}
