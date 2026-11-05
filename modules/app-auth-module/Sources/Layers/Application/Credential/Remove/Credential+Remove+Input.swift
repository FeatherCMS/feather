import AuthDomain
public import AuthModule
public import FeatherApplication
import FeatherModuleKit

extension Credential.Remove {
    public struct Input: DTO {
        public let ids: [String]

        public init(ids: [String]) {
            self.ids = ids
        }
    }
}
