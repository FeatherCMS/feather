public import FeatherApplication
public import FeatherDomain
public import UserDomain
public import UserModule

extension Identity.Edit {
    public struct Input: DTO {
        public let id: String
        public let name: FieldChange<String>
        public let roleIds: FieldChange<[String]>
        public let status: FieldChange<Identity.Model.Status>

        public init(
            id: String,
            name: FieldChange<String> = .unchanged,
            roleIds: FieldChange<[String]> = .unchanged,
            status: FieldChange<Identity.Model.Status> = .unchanged
        ) {
            self.id = id
            self.name = name
            self.roleIds = roleIds
            self.status = status
        }
    }
}
