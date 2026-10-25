import FeatherOpenAPI

extension Invitation.Validate {
    public struct Email: StringSchemaRepresentable {
        public var openAPIIdentifier: String {
            "AccountInvitationRegistrationEmailField"
        }
        public var example: String? = "user@example.com"
        public init() {}
    }
}
