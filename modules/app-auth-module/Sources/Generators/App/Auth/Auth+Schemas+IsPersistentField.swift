import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import UserOpenAPIGeneratorSupport

extension Auth.Schemas {
    struct IsPersistentField: BoolSchemaRepresentable {
        var example: Bool? = true
    }
}
