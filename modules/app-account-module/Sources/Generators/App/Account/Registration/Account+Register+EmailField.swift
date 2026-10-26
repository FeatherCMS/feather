import FeatherOpenAPI

extension Account.Register {
    public struct EmailField: StringSchemaRepresentable {
        public var openAPIIdentifier: String { "AccountRegisterEmailField" }
        public var example: String? = "admin@example.com"
        public init() {}
    }
}
