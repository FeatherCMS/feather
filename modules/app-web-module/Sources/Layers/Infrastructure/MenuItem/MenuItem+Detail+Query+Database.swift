import FeatherDBAL
public import FeatherInfrastructure
public import WebApplication
import WebDomain
public import WebModule

extension MenuItem.Detail.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func find(id: String) async throws -> MenuItem.Detail.Output {
            guard
                let row = try await DatabaseAccessLayer<MenuItem.Table>(
                    context: context
                )
                .selectFirst(by: \.id, equals: id)
            else {
                throw RepositoryError.notFound
            }
            return .init(
                id: row.id,
                menuId: row.menuId,
                label: row.label,
                url: row.url,
                priority: row.priority,
                isBlank: row.isBlank,
                permission: row.permission,
                authentication: MenuItem.Model.Authentication(
                    rawValue: row.authentication
                ) ?? .any,
                notes: row.notes,
                createdAt: row.createdAt,
                updatedAt: row.updatedAt
            )
        }
    }
}
