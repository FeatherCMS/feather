public import FeatherApplication
public import UserDomain
public import UserModule

extension Identity.Add {
    public struct Input: DTO {
        public let name: String
        public let status: Identity.Model.Status
        public let roleIds: [String]

        public init(
            name: String = "User",
            status: Identity.Model.Status,
            roleIds: [String] = []
        ) {
            self.name = name
            self.status = status
            self.roleIds = roleIds
        }
    }
}
