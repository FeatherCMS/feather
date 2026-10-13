import FeatherOpenAPI

struct AppContactFormKeyParameter: PathParameterRepresentable {
    var name: String { "contactFormKey" }
    var schema: any OpenAPISchemaRepresentable {
        AppContactKeyField().reference()
    }
}
