import FeatherOpenAPI

struct ContactFormKeyParameter: PathParameterRepresentable {
    var name: String { "contactFormKey" }
    var schema: any OpenAPISchemaRepresentable {
        ContactFormKeyField().reference()
    }
}
