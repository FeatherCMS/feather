import FeatherOpenAPI

extension Account.Auth {
    public struct MagicLinkTokenField: StringSchemaRepresentable {
        public var openAPIIdentifier: String {
            "AccountAuthMagicLinkTokenField"
        }
        public var example: String? = "mgl_3XbY..."
        public init() {}
    }
}
