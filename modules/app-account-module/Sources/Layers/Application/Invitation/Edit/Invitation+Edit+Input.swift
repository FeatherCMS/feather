public import AccountModule
public import FeatherApplication

extension Invitation.Edit {
    public struct Input: DTO {
        public let id: String
        public let email: String?
        public let roleIDs: [String]?

        public init(id: String, email: String?, roleIDs: [String]? = nil) {
            self.id = id
            self.email = email
            self.roleIDs = roleIDs
        }
    }
}
