import FeatherOpenAPI

extension Contact.Form.Parameters {
    struct Key: PathParameterRepresentable {
        var openAPIIdentifier: String { "ContactFormKeyParameter" }
        var name: String { "contactFormKey" }
        var schema: any OpenAPISchemaRepresentable {
            Contact.Schemas.FormKey().reference()
        }
    }
}
