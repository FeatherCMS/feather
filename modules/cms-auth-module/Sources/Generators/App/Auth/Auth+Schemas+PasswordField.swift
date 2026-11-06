import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Auth.Schemas {
    struct PasswordField: StringSchemaRepresentable {
        var example: String? = "password"
    }
}
