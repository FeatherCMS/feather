import FeatherDBAL
public import FeatherInfrastructure
import WebDomain
public import WebApplication
public import WebModule

extension Menu.Public.List.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func listMenuItems(menuId: String) async throws -> [Item] {
            try await DatabaseAccessLayer<MenuItem.Table>(context: context)
                .select { initial in
                    initial
                        .where(\.menuId, equals: menuId)
                        .order(by: [
                            .init(by: \.priority, .ascending),
                            .init(by: \.label, .ascending),
                            .init(by: \.id, .ascending),
                        ])
                }
                .map {
                    .init(
                        id: $0.id,
                        label: $0.label,
                        url: $0.url,
                        priority: $0.priority,
                        isBlank: $0.isBlank,
                        permission: $0.permission,
                        authentication: MenuItem.Authentication(
                            rawValue: $0.authentication
                        ) ?? .any
                    )
                }
        }
    }
}
