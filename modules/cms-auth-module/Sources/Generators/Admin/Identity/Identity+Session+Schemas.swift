import FeatherOpenAPI

extension Identity.Session {
    enum Schemas {}
}

extension Identity.Session.Schemas {
    struct Timestamp: DoubleSchemaRepresentable {
        var openAPIIdentifier: String { "UserAuthSessionTimestampField" }
    }

    struct Persistent: BoolSchemaRepresentable {
        var openAPIIdentifier: String { "UserAuthSessionPersistentField" }
    }

    struct AuthenticationType: StringSchemaRepresentable {
        var openAPIIdentifier: String {
            "UserAuthSessionAuthenticationTypeField"
        }
    }

    struct AuthenticationReference: StringSchemaRepresentable {
        var openAPIIdentifier: String {
            "UserAuthSessionAuthenticationReferenceField"
        }
    }
}
