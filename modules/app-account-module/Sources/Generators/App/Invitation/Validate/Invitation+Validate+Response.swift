import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Invitation.Validate {
    public struct Response: JSONResponseRepresentable {
        public var openAPIIdentifier: String {
            "AccountInvitationValidationResponse"
        }
        public var description: String = "Invitation validation response"
        public var schema = Schema().reference()
        public init() {}
    }
}
