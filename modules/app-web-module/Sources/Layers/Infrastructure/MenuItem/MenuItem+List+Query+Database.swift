import FeatherDBAL
public import FeatherInfrastructure
public import WebApplication
import WebDomain
public import WebModule

extension MenuItem.List.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func list(menuId: String) async throws -> MenuItem.List.Output {
            let items = try await DatabaseAccessLayer<MenuItem.Table>(
                context: context
            )
            .select { initial in
                initial
                    .where(\.menuId, equals: menuId)
                    .order(by: [
                        .init(by: \.priority, .ascending),
                        .init(by: \.label, .ascending),
                        .init(by: \.id, .ascending),
                    ])
            }
            return .init(
                items: items.map {
                    .init(
                        id: $0.id,
                        menuId: $0.menuId,
                        label: $0.label,
                        url: $0.url,
                        priority: $0.priority,
                        isBlank: $0.isBlank,
                        permission: $0.permission,
                        authentication: MenuItem.Model.Authentication(
                            rawValue: $0.authentication
                        ) ?? .any,
                        createdAt: $0.createdAt,
                        updatedAt: $0.updatedAt
                    )
                }
            )
        }
    }
}
