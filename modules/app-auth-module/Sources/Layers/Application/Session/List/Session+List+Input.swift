public import AuthModule
public import FeatherApplication
import FeatherModuleKit

extension Session.List {
    public struct Input: DTO {
        public let identityId: String

        public init(identityId: String) {
            self.identityId = identityId
        }
    }
}
