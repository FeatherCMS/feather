import AuthDomain
public import AuthModule
public import FeatherApplication
import FeatherModuleKit

extension MagicLink.Add {
    public struct Input: DTO {
        public let authEmailId: String
        public let isPersistent: Bool

        public init(
            authEmailId: String,
            isPersistent: Bool
        ) {
            self.authEmailId = authEmailId
            self.isPersistent = isPersistent
        }
    }
}
