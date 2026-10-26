import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

extension Auth.Schemas {
    struct IsPersistentField: BoolSchemaRepresentable {
        var example: Bool? = true
    }
}
