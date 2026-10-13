import FeatherOpenAPI

struct FormFieldIdParameter: PathParameterRepresentable {
    var name: String { "formFieldId" }
    var schema: any OpenAPISchemaRepresentable { ContactIdField().reference() }
}
