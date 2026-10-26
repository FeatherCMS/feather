import FeatherDBAL
public import FeatherInfrastructure
public import WebApplication
import WebDomain
public import WebModule

extension Menu.Detail.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func find(id: String) async throws -> Menu.Detail.Output {
            guard
                let row = try await DatabaseAccessLayer<Menu.Table>(
                    context: context
                )
                .selectFirst(by: \.id, equals: id)
            else {
                throw RepositoryError.notFound
            }
            return .init(
                id: row.id,
                key: row.key,
                name: row.name,
                notes: row.notes,
                createdAt: row.createdAt,
                updatedAt: row.updatedAt
            )
        }
    }
}
