import AuthDomain
public import AuthModule
public import FeatherApplication
public import FeatherDomain
import FeatherModuleKit

extension Email.Edit {
    public struct Input: DTO {
        public let id: String
        public let identityId: FieldChange<String>
        public let email: FieldChange<String>
        public init(
            id: String,
            identityId: FieldChange<String> = .unchanged,
            email: FieldChange<String> = .unchanged
        ) {
            self.id = id
            self.identityId = identityId
            self.email = email
        }
    }
}
