public import AuthApplication
public import AuthModule
import FeatherApplication
import FeatherDBAL
public import FeatherInfrastructure

extension Email.Search.Query {
    public struct Database: Interface {
        private let accessLayer: DatabaseAccessLayer<Email.Table>

        public init(context: any DatabaseContext) {
            self.accessLayer = .init(context: context)
        }

        public func search(
            query: Email.Search.Input.Query
        ) async throws -> Email.Search.Output {
            let items =
                try await accessLayer
                .select(as: Email.Table.List.self) { initial in
                    paginate(
                        applyFilters(query, to: initial)
                            .order(by: orders(for: query.sort)),
                        page: query.page
                    )
                }
                .map {
                    Email.Search.Output.Item(
                        id: $0.id,
                        identityId: $0.identityId,
                        email: $0.email
                    )
                }
            let total = try await accessLayer.selectCount { initial in
                applyFilters(query, to: initial)
            }
            return .init(items: items, total: total)
        }

        private func applyFilters(
            _ query: Email.Search.Input.Query,
            to initial: DatabaseQuerySelect<Email.Table>
        ) -> DatabaseQuerySelect<Email.Table> {
            var result = initial
            if let identityId = query.identityId, !identityId.isEmpty {
                result = result.where(\.identityId, equals: identityId)
            }
            if let search = query.search {
                result = result.where(
                    searchText: search,
                    columns: [
                        DatabaseQueryTextColumn<Email.Table>(\.identityId),
                        DatabaseQueryTextColumn<Email.Table>(\.email),
                    ]
                )
            }
            return result
        }

        private func orders(
            for rules: [Email.Search.Input.Query.Sort]
        ) -> [DatabaseQueryOrder<Email.Table>] {
            var result = rules.map { rule in
                let direction: DatabaseQueryDirection =
                    rule.direction == .asc ? .ascending : .descending
                return switch rule.field {
                case .identityId:
                    DatabaseQueryOrder<Email.Table>(
                        by: \.identityId,
                        direction
                    )
                case .email:
                    DatabaseQueryOrder<Email.Table>(by: \.email, direction)
                }
            }
            if !rules.contains(where: { $0.field == .email }) {
                result.append(.init(by: \.email, .ascending))
            }
            return result
        }

        private func paginate(
            _ query: DatabaseQuerySelect<Email.Table>,
            page: Search.Page
        ) -> DatabaseQuerySelect<Email.Table> {
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
