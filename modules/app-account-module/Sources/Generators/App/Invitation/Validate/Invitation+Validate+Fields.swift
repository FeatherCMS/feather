import FeatherOpenAPI

extension Invitation.Validate {
    public struct EmailField: StringSchemaRepresentable {
        public var openAPIIdentifier: String {
            "AccountInvitationRegistrationEmailField"
        }
        public var example: String? = "user@example.com"
        public init() {}
    }

    public struct ExpiresAtField: DoubleSchemaRepresentable {
        public var openAPIIdentifier: String {
            "AccountInvitationRegistrationExpiresAtField"
        }
        public var example: Double? = 1_760_000_000
        public init() {}
    }
}
