import Application
import ContactDomain
import struct Foundation.Date

public struct ContactFormDetail: DTO {
    public let id: String
    public let name: String
    public let items: [ContactFormItemDetail]
    public let createdAt: Date
    public let updatedAt: Date

    package init(id: String, name: String, items: [ContactFormItemDetail], createdAt: Date, updatedAt: Date) {
        self.id = id
        self.name = name
        self.items = items
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
