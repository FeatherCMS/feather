public import AuthModule
public import FeatherApplication

extension AuthModule.Auth.TokenAuth {
    public struct Input: DTO {
        public let token: String
        public init(token: String) { self.token = token }
    }
}
