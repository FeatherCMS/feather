import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Account.Auth {
    public struct Response: JSONResponseRepresentable {
        public var openAPIIdentifier: String { "AccountAuthResponse" }
        public var description: String = "Account authentication response"
        public var schema = ResponseSchema().reference()
        public init() {}
    }
}
