import FeatherOpenAPI

extension Menu {
    enum Parameters {
        struct UpdateMask: QueryParameterRepresentable {
            var name: String { "updateMask" }
            var required: Bool { true }
            var description: String? {
                "Comma-separated list of fields to update. Include an optional field to clear it when omitted from the request body."
            }
            var schema: any OpenAPISchemaRepresentable {
                Menu.Schemas.UpdateMask().reference()
            }
        }
    }
}
