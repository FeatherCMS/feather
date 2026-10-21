import AuthDomain
public import AuthModule
public import FeatherApplication
import FeatherModuleKit

extension AuthEmail.Edit {
    public struct Input: DTO {
        public let id: String
        public let identityId: String
        public let email: String
        public init(
            id: String,
            identityId: String,
            email: String
        ) {
            self.id = id
            self.identityId = identityId
            self.email = email
        }
    }
}
