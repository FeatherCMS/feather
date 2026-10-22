import FeatherOpenAPI

extension Invitation.Exchange {
    public struct Schema: ObjectSchemaRepresentable {
        public var openAPIIdentifier: String {
            "AccountInvitationExchangeRequestSchema"
        }
        public var propertyMap: SchemaMap {
            [
                "token": Account.Auth.MagicLinkTokenField().reference(),
                "password": Account.Register.PasswordField().reference(),
            ]
        }

        public init() {}
    }
}
