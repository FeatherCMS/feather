public import FeatherApplication
import WebDomain
public import WebModule

public import struct Foundation.Date

extension MenuItem.Edit {
    public struct Output: DTO {
        public let id: String
        public let menuId: String
        public let label: String
        public let url: String
        public let priority: Int
        public let isBlank: Bool
        public let permission: String
        public let authentication: MenuItem.Authentication
        public let notes: String?
        public let createdAt: Date
        public let updatedAt: Date

        init(model: MenuItem.Model) {
            self.id = model.id
            self.menuId = model.menuId
            self.label = model.label
            self.url = model.url
            self.priority = model.priority
            self.isBlank = model.isBlank
            self.permission = model.permission
            self.authentication = model.authentication
            self.notes = model.notes
            self.createdAt = model.createdAt
            self.updatedAt = model.updatedAt
        }
    }
}
