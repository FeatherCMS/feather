import AuthDomain
public import AuthModule
public import FeatherApplication
import FeatherModuleKit

extension MagicLink.Edit {
    public struct Input: DTO {
        public let id: String
        public let authEmailId: String?
        public let isPersistent: Bool?

        public init(
            id: String,
            authEmailId: String?,
            isPersistent: Bool?
        ) {
            self.id = id
            self.authEmailId = authEmailId
            self.isPersistent = isPersistent
        }
    }
}
