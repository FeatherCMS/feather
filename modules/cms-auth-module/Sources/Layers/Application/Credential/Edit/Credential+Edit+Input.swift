import AuthDomain
public import AuthModule
public import FeatherApplication
public import FeatherDomain
import FeatherModuleKit

extension Credential.Edit {
    public struct Input: DTO {
        public let id: String
        public let userId: FieldChange<String>
        public let email: FieldChange<String>
        public let password: FieldChange<String>

        public init(
            id: String,
            userId: FieldChange<String> = .unchanged,
            email: FieldChange<String> = .unchanged,
            password: FieldChange<String> = .unchanged,
        ) {
            self.id = id
            self.userId = userId
            self.email = email
            self.password = password
        }
    }
}
