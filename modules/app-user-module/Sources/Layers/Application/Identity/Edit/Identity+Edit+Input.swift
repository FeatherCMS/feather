public import FeatherApplication
public import UserDomain
public import UserModule

extension Identity.Edit {
    public struct Input: DTO {
        public let id: String
        public let name: String?
        public let roleIds: [String]?
        public let status: Identity.Model.Status?

        public init(
            id: String,
            name: String? = nil,
            roleIds: [String]?,
            status: Identity.Model.Status?
        ) {
            self.id = id
            self.name = name
            self.roleIds = roleIds
            self.status = status
        }
    }
}
