import AuthDomain
public import AuthModule
public import FeatherApplication
import FeatherDomain
import FeatherModuleKit

extension Credential.Edit {
    public struct Input: DTO {
        public let id: String
        public let userId: String?
        public let email: String?
        public let password: String?

        public init(
            id: String,
            userId: String? = nil,
            email: String?,
            password: String?,
        ) {
            self.id = id
            self.userId = userId
            self.email = email
            self.password = password
        }
    }
}
