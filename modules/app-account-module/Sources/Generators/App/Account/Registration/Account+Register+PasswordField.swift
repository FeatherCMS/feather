import FeatherOpenAPI

extension Account.Register {
    public struct PasswordField: StringSchemaRepresentable {
        public var openAPIIdentifier: String { "AccountRegisterPasswordField" }
        public var example: String? = "password"
        public init() {}
    }
}
