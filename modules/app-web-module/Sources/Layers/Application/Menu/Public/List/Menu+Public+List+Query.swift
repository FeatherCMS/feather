public import WebDomain
public import WebModule

extension Menu.Public.List {
    public enum Query {
        public struct Item: Sendable {
            public let id: String
            public let label: String
            public let url: String
            public let priority: Int
            public let isBlank: Bool
            public let permission: String
            public let authentication: MenuItem.Model.Authentication

            public init(
                id: String,
                label: String,
                url: String,
                priority: Int,
                isBlank: Bool,
                permission: String,
                authentication: MenuItem.Model.Authentication
            ) {
                self.id = id
                self.label = label
                self.url = url
                self.priority = priority
                self.isBlank = isBlank
                self.permission = permission
                self.authentication = authentication
            }
        }

        public protocol Interface: Sendable {
            func listMenuItems(menuId: String) async throws -> [Item]
        }
    }
}
