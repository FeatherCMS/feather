public import FeatherApplication
package import WebDomain
public import WebModule

public import struct Foundation.Date

extension Menu.Add {
    public struct Output: FeatherApplication.DTO {
        public let id: String
        public let key: String
        public let name: String
        public let notes: String?
        public let createdAt: Date
        public let updatedAt: Date

        package init(model: Menu.Model) {
            self.id = model.id
            self.key = model.key
            self.name = model.name
            self.notes = model.notes
            self.createdAt = model.createdAt
            self.updatedAt = model.updatedAt
        }
    }
}
