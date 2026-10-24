import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import UserOpenAPIGeneratorSupport

extension Auth.Schemas {
    struct TokenField: StringSchemaRepresentable {
        var example: String? =
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
    }
}
