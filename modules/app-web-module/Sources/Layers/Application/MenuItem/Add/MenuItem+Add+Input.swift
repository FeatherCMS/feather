public import FeatherApplication
public import WebDomain
public import WebModule

extension MenuItem.Add {
    public struct Input: DTO {
        public let menuId: String
        public let label: String
        public let url: String
        public let priority: Int
        public let isBlank: Bool
        public let permission: String
        public let authentication: MenuItem.Model.Authentication
        public let notes: String

        public init(
            menuId: String,
            label: String,
            url: String,
            priority: Int,
            isBlank: Bool,
            permission: String,
            authentication: MenuItem.Model.Authentication = .any,
            notes: String
        ) {
            self.menuId = menuId
            self.label = label
            self.url = url
            self.priority = priority
            self.isBlank = isBlank
            self.permission = permission
            self.authentication = authentication
            self.notes = notes
        }
    }
}
