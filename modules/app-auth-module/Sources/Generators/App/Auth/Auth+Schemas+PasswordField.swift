import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

extension Auth.Schemas {
    struct PasswordField: StringSchemaRepresentable {
        var example: String? = "password"
    }
}
