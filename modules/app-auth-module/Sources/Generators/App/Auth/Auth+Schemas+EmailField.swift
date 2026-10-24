import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import UserOpenAPIGeneratorSupport

extension Auth.Schemas {
    struct EmailField: StringSchemaRepresentable {
        var example: String? = "admin@example.com"
    }
}
