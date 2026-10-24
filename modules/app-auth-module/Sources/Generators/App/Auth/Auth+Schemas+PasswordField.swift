import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import UserOpenAPIGeneratorSupport

extension Auth.Schemas {
    struct PasswordField: StringSchemaRepresentable {
        var example: String? = "password"
    }
}
