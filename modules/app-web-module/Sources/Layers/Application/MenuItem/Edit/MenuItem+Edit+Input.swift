public import FeatherApplication
public import WebDomain

extension MenuItem.Edit {
    public struct Input: DTO {
        public let id: String
        public let menuId: String
        public let label: String?
        public let url: String?
        public let priority: Int?
        public let isBlank: Bool?
        public let permission: String?
        public let authentication: MenuItem.Authentication?
        public let notes: String?

        public init(
            id: String,
            menuId: String,
            label: String?,
            url: String?,
            priority: Int?,
            isBlank: Bool?,
            permission: String?,
            authentication: MenuItem.Authentication? = nil,
            notes: String?
        ) {
            self.id = id
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
