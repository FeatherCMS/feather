public import AuthModule
public import FeatherApplication
import FeatherModuleKit
import UserApplication
import UserModule

extension AuthModule.Auth.CurrentUser {
    public struct Input: DTO {
        public let id: String

        public init(id: String) {
            self.id = id
        }
    }
}
