import AuthDomain
public import AuthModule
public import FeatherApplication
import FeatherModuleKit

extension AuthEmail.Add {
    public struct Input: DTO {
        public let identityId: String
        public let email: String
        public init(
            identityId: String,
            email: String
        ) {
            self.identityId = identityId
            self.email = email
        }
    }
}
