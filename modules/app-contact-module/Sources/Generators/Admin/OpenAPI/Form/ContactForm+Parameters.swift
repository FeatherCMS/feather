import FeatherOpenAPI

struct ContactFormIdParameter: PathParameterRepresentable {
    var name: String { "contactFormId" }
    var schema: any OpenAPISchemaRepresentable { ContactIdField().reference() }
}
