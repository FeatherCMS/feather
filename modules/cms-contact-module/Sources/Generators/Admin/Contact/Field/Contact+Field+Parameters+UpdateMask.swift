import FeatherOpenAPI

extension Contact.Field.Parameters {
    struct UpdateMask: QueryParameterRepresentable {
        var name: String { "updateMask" }
        var required: Bool { true }
        var description: String? {
            "Comma-separated list of fields to update."
        }
        var schema: any OpenAPISchemaRepresentable {
            Contact.Field.Schemas.UpdateMask().reference()
        }
    }
}
