import FeatherOpenAPI

extension Account.Auth {
    public struct TokenField: StringSchemaRepresentable {
        public var openAPIIdentifier: String { "AccountAuthTokenField" }
        public var example: String? = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
        public init() {}
    }
}
