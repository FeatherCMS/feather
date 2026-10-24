import FeatherOpenAPI
import OpenAPIKit30

extension Profile.Fields {
    struct ImageAssetID: SchemaRepresentable {
        var required: Bool

        init(required: Bool = true) {
            self.required = required
        }

        func openAPISchema() -> JSONSchema {
            .string(required: required, nullable: true)
        }
    }
}
