import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Profile.Get {
    public struct Response: JSONResponseRepresentable {
        public var openAPIIdentifier: String { "AccountProfileResponse" }
        public var description: String = "Account profile response"
        public var schema = Schema().reference()
        public init() {}
    }
}
