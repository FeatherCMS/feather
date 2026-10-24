public import AccountModule
public import FeatherApplication
public import FeatherDomain

extension Invitation.Edit {
    public struct Input: DTO {
        public let id: String
        public let email: FieldChange<String>
        public let roleIDs: FieldChange<[String]>

        public init(
            id: String,
            email: FieldChange<String>,
            roleIDs: FieldChange<[String]>
        ) {
            self.id = id
            self.email = email
            self.roleIDs = roleIDs
        }
    }
}
