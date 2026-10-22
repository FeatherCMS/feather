public import AuthApplication
public import AuthModule
public import FeatherInfrastructure

extension Credential.Search.Query {
    public struct Database: Interface {
        private let listQuery: Credential.List.Query.Database

        public init(context: DatabaseQueryContext) {
            self.listQuery = .init(context: context)
        }

        public func search(
            query: Credential.Search.Input.Query,
            userId: String?
        ) async throws -> Credential.Search.Output {
            let listQuery = Credential.List.Input.Query(
                page: query.page,
                sort: query.sort.map {
                    .init(
                        field: .init(rawValue: $0.field.rawValue) ?? .userId,
                        direction: $0.direction
                    )
                },
                search: query.search
            )
            let result: Credential.List.Output
            let total: Int
            if let userId {
                result = try await self.listQuery.list(
                    userId: userId,
                    query: listQuery
                )
                total = try await self.listQuery.count(
                    userId: userId,
                    query: listQuery
                )
            }
            else {
                result = try await self.listQuery.list(query: listQuery)
                total = try await self.listQuery.count(query: listQuery)
            }
            return .init(
                items: result.items.map {
                    .init(
                        id: $0.id,
                        userId: $0.userId,
                        identityName: $0.identityName,
                        email: $0.email,
                        createdAt: $0.createdAt,
                        updatedAt: $0.updatedAt
                    )
                },
                total: total
            )
        }
    }
}
