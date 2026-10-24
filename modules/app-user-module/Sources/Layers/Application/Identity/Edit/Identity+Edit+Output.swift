public import FeatherApplication
public import UserDomain
public import UserModule

public import struct Foundation.Date

extension Identity.Edit {
    public struct Output: DTO {
        public let id: String
        public let name: String
        public let roleIds: [String]
        public let status: Identity.Model.Status
        public let createdAt: Date
        public let updatedAt: Date

        package init(
            id: String,
            name: String,
            roleIds: [String],
            status: Identity.Model.Status,
            createdAt: Date,
            updatedAt: Date
        ) {
            self.id = id
            self.name = name
            self.roleIds = roleIds
            self.status = status
            self.createdAt = createdAt
            self.updatedAt = updatedAt
        }
    }
}
