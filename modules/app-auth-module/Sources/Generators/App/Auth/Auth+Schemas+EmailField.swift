import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Auth.Schemas {
    struct EmailField: StringSchemaRepresentable {
        var example: String? = "admin@example.com"
    }
}
