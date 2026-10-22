import FeatherOpenAPI
import OpenAPIKit30

extension Profile.Fields {
    struct UserID: StringSchemaRepresentable {
        var openAPIIdentifier: String { "AccountProfileUserIDField" }
    }

    struct Name: SchemaRepresentable {
        var required: Bool

        init(required: Bool = true) {
            self.required = required
        }

        func openAPISchema() -> JSONSchema {
            .string(required: required, nullable: true)
        }
    }

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
