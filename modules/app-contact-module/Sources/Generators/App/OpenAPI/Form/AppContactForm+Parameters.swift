import FeatherOpenAPI

struct AppContactFormIdParameter: PathParameterRepresentable {
    var name: String { "contactFormId" }
    var schema: any OpenAPISchemaRepresentable {
        AppContactIdField().reference()
    }
}
