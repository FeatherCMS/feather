import FeatherOpenAPI

extension Invitation.Validate {
    public struct Schema: ObjectSchemaRepresentable {
        public var openAPIIdentifier: String {
            "AccountInvitationValidationSchema"
        }
        public var propertyMap: SchemaMap {
            [
                "email": EmailField().reference(),
                "expiresAt": ExpiresAtField().reference(),
            ]
        }

        public init() {}
    }
}
