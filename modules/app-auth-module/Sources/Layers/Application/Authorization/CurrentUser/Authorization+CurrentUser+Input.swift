public import AuthModule
public import FeatherApplication
import FeatherModuleKit
import UserApplication
import UserModule

extension AuthModule.Authorization.CurrentUser {
    public struct Input: DTO {
        public let id: String

        public init(id: String) {
            self.id = id
        }
    }
}
