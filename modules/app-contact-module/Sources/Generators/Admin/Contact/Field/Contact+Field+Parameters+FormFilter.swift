import FeatherOpenAPI

extension Contact.Field.Parameters {
    struct FormFilter: QueryParameterRepresentable {
        var openAPIIdentifier: String { "FormFieldListFilterParameter" }
        var name: String { "form" }
        var required: Bool { false }
        var description: String? {
            "Filter fields by form key or use __unassigned__ for fields not assigned to a form."
        }
        var schema: any OpenAPISchemaRepresentable {
            Contact.Schemas.FormKey().reference(required: false)
        }
    }
}
