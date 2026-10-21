public import AuthModule
public import FeatherApplication
import FeatherModuleKit

extension Credential.Detail {
    public struct Input: DTO {
        public let id: String

        public init(
            id: String
        ) {
            self.id = id
        }
    }
}
