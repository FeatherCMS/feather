import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Auth.Schemas {
    struct SessionExpiresAtField: DoubleSchemaRepresentable {
        var openAPIIdentifier: String { "AuthSessionExpiresAtField" }
    }
}
