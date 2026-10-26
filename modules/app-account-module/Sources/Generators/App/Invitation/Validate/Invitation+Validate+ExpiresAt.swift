import FeatherOpenAPI

extension Invitation.Validate {
    public struct ExpiresAt: DoubleSchemaRepresentable {
        public var openAPIIdentifier: String {
            "AccountInvitationRegistrationExpiresAtField"
        }
        public var example: Double? = 1_760_000_000
        public init() {}
    }
}
