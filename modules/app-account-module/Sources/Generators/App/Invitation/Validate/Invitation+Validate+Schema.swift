import FeatherOpenAPI

extension Invitation.Validate {
    public struct Schema: ObjectSchemaRepresentable {
        public var openAPIIdentifier: String {
            "AccountInvitationValidationSchema"
        }
        public var propertyMap: SchemaMap {
            [
                "email": Email().reference(),
                "expiresAt": ExpiresAt().reference(),
            ]
        }

        public init() {}
    }
}
