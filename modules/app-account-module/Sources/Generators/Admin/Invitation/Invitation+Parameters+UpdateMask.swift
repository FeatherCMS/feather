import FeatherOpenAPI

extension Invitation.Parameters {
    struct UpdateMask: QueryParameterRepresentable {
        var name: String { "updateMask" }
        var required: Bool { true }
        var description: String? {
            "Comma-separated list of fields to update."
        }
        var schema: any OpenAPISchemaRepresentable {
            Invitation.Schemas.UpdateMask().reference()
        }
    }
}
