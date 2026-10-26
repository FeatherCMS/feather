import FeatherOpenAPI

extension Account.Register {
    public struct Schema: ObjectSchemaRepresentable {
        public var openAPIIdentifier: String { "AccountRegisterSchema" }
        public var propertyMap: SchemaMap {
            [
                "email": EmailField().reference(),
                "password": PasswordField().reference(),
            ]
        }

        public init() {}
    }

}
