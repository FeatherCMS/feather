public import AuthApplication
public import AuthModule
import FeatherApplication
import FeatherDBAL
public import FeatherInfrastructure

extension Session.Search.Query {
    public struct Database: Interface {
        private let accessLayer: DatabaseAccessLayer<Session.Table>

        public init(context: any DatabaseContext) {
            self.accessLayer = .init(context: context)
        }

        public func search(
            identityId: String,
            query: Session.Search.Input.Query
        ) async throws -> Session.Search.Output {
            let items = try await accessLayer
                .select(as: Session.Table.List.self) { initial in
                    paginate(
                        applyFilters(
                            query,
                            identityId: identityId,
                            to: initial
                        )
                        .order(by: orders(for: query.sort)),
                        page: query.page
                    )
                }
                .map {
                    Session.Search.Output.Item(
                        id: $0.id,
                        authenticationType: $0.authenticationType,
                        authenticationReference: $0.authenticationReference,
                        expiresAt: $0.expiresAt,
                        isPersistent: $0.isPersistent,
                        createdAt: $0.createdAt,
                        updatedAt: $0.updatedAt
                    )
                }
            let total = try await accessLayer.selectCount { initial in
                applyFilters(query, identityId: identityId, to: initial)
            }
            return .init(items: items, total: total)
        }

        private func applyFilters(
            _ query: Session.Search.Input.Query,
            identityId: String,
            to initial: DatabaseQuerySelect<Session.Table>
        ) -> DatabaseQuerySelect<Session.Table> {
            var result = initial.where(\.identityId, equals: identityId)
            if let search = query.search {
                result = result.where(
                    searchText: search,
                    columns: [
                        DatabaseQueryTextColumn<Session.Table>(\.id),
                        DatabaseQueryTextColumn<Session.Table>(
                            \.authenticationType
                        ),
                        DatabaseQueryTextColumn<Session.Table>(
                            \.authenticationReference
                        ),
                    ]
                )
            }
            return result
        }

        private func orders(
            for rules: [Session.Search.Input.Query.Sort]
        ) -> [DatabaseQueryOrder<Session.Table>] {
            var result = rules.map { rule in
                let direction: DatabaseQueryDirection =
                    rule.direction == .asc ? .ascending : .descending
                return switch rule.field {
                case .id:
                    DatabaseQueryOrder<Session.Table>(by: \.id, direction)
                case .createdAt:
                    DatabaseQueryOrder<Session.Table>(by: \.createdAt, direction)
                }
            }
            if !rules.contains(where: { $0.field == .id }) {
                result.append(.init(by: \.id, .ascending))
            }
            return result
        }

        private func paginate(
            _ query: DatabaseQuerySelect<Session.Table>,
            page: Search.Page
        ) -> DatabaseQuerySelect<Session.Table> {
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
