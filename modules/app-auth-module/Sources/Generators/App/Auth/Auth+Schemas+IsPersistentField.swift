import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Auth.Schemas {
    struct IsPersistentField: BoolSchemaRepresentable {
        var example: Bool? = true
    }
}
