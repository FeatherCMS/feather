import AuthDomain
public import AuthModule
public import FeatherApplication
import FeatherDomain
import FeatherModuleKit

extension Credential.Add {
    public struct Input: DTO {
        public let userId: String
        public let email: String
        public let password: String

        public init(
            userId: String,
            email: String,
            password: String,
        ) {
            self.userId = userId
            self.email = email
            self.password = password
        }
    }
}
