import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Settings {
    public struct Response: JSONResponseRepresentable {
        public var openAPIIdentifier: String { "AccountSettingsResponse" }
        public var description: String = "Account settings response"
        public var schema = ResponseSchema().reference()
        public init() {}
    }
}
