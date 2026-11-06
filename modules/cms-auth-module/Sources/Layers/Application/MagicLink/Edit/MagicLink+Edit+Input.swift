import AuthDomain
public import AuthModule
public import FeatherApplication
public import FeatherDomain
import FeatherModuleKit

extension MagicLink.Edit {
    public struct Input: DTO {
        public let id: String
        public let authEmailId: FieldChange<String>
        public let isPersistent: FieldChange<Bool>

        public init(
            id: String,
            authEmailId: FieldChange<String> = .unchanged,
            isPersistent: FieldChange<Bool> = .unchanged
        ) {
            self.id = id
            self.authEmailId = authEmailId
            self.isPersistent = isPersistent
        }
    }
}
