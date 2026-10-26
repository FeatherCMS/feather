import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

extension Auth.Schemas {
    struct TokenField: StringSchemaRepresentable {
        var example: String? =
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
    }
}
