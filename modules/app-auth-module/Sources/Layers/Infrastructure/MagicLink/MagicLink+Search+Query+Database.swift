public import AuthApplication
public import AuthModule
public import FeatherInfrastructure

extension MagicLink.Search.Query {
    public struct Database: Interface {
        private let listQuery: MagicLink.List.Query.Database

        public init(context: DatabaseQueryContext) {
            self.listQuery = .init(context: context)
        }

        public func search(query: MagicLink.Search.Input.Query) async throws
            -> MagicLink.Search.Output
        {
            let listQuery = MagicLink.List.Input.Query(
                page: query.page,
                sort: query.sort.map {
                    .init(field: .id, direction: $0.direction)
                },
                search: query.search,
                userId: query.userId
            )
            let result = try await self.listQuery.list(query: listQuery)
            let total = try await self.listQuery.count(query: listQuery)
            return .init(
                items: result.items.map {
                    .init(
                        id: $0.id,
                        authEmailId: $0.authEmailId,
                        token: $0.token,
                        expiresAt: $0.expiresAt,
                        isPersistent: $0.isPersistent,
                        isUsed: $0.isUsed,
                        createdAt: $0.createdAt,
                        updatedAt: $0.updatedAt
                    )
                },
                total: total
            )
        }
    }
}
