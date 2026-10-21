public import AuthApplication
public import AuthModule
import FeatherApplication
import FeatherDBAL
public import FeatherInfrastructure
import Foundation

extension Session.Table.List {
    var asQueryListItem: Session.List.Output.Item {
        .init(
            id: id,
            token: token,
            identityId: identityId,
            authenticationType: authenticationType,
            authenticationReference: authenticationReference,
            expiresAt: expiresAt.timeIntervalSince1970,
            isPersistent: isPersistent,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

extension Session.List.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func list(
            query: Session.List.Input.Query
        ) async throws -> Session.List.Output {
            let accessLayer = DatabaseAccessLayer<Session.Table>(
                context: context
            )
            let page = query.page.normalized()
            let pageIndex = page.number - 1
            let offset =
                pageIndex > Int.max / page.size
                ? Int.max : pageIndex * page.size
            let rows = try await accessLayer.select(as: Session.Table.List.self)
            {
                initial in
                var result = initial
                if let identityId = query.identityId {
                    result = result.where(\.identityId, equals: identityId)
                }
                if let search = query.search, !search.isEmpty {
                    result = result.where(
                        searchText: search,
                        columns: [
                            DatabaseQueryTextColumn<Session.Table>(\.id),
                            DatabaseQueryTextColumn<Session.Table>(\.token),
                            DatabaseQueryTextColumn<Session.Table>(
                                \.identityId
                            ),
                            DatabaseQueryTextColumn<Session.Table>(
                                \.authenticationType
                            ),
                            DatabaseQueryTextColumn<Session.Table>(
                                \.authenticationReference
                            ),
                        ]
                    )
                }
                let orders = query.sort.map { sort in
                    DatabaseQueryOrder<Session.Table>(
                        by: \.id,
                        sort.direction == .asc ? .ascending : .descending
                    )
                }
                let defaultOrders =
                    orders.isEmpty
                    ? [DatabaseQueryOrder<Session.Table>(by: \.id, .ascending)]
                    : orders
                return result.order(by: defaultOrders).limit(page.size)
                    .offset(offset)
            }
            return .init(items: rows.map(\.asQueryListItem))
        }
    }
}
