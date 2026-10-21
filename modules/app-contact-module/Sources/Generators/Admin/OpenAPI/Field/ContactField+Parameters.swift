import FeatherOpenAPI

struct FormFieldIdParameter: PathParameterRepresentable {
    var name: String { "formFieldId" }
    var schema: any OpenAPISchemaRepresentable { ContactIdField().reference() }
}

struct FormFieldListFilterParameter: QueryParameterRepresentable {
    var name: String { "form" }
    var required: Bool { false }
    var description: String? {
        "Filter fields by form key or use __unassigned__ for fields not assigned to a form."
    }
    var schema: any OpenAPISchemaRepresentable {
        ContactFormKeyField().reference(required: false)
    }
}
