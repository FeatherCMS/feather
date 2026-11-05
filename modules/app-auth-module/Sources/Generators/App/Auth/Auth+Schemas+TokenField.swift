import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Auth.Schemas {
    struct TokenField: StringSchemaRepresentable {
        var example: String? =
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
    }
}
