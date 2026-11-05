import AuthDomain
public import AuthModule
public import FeatherApplication
import FeatherModuleKit

extension Session.Extend {
    public struct Input: DTO {
        public let token: String
        public let expiresAt: Double

        public init(
            token: String,
            expiresAt: Double
        ) {
            self.token = token
            self.expiresAt = expiresAt
        }
    }
}
