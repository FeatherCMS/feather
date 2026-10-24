import FeatherOpenAPI

extension Contact.Form.Parameters {
    struct Key: PathParameterRepresentable {
        var openAPIIdentifier: String { "AppContactFormKeyParameter" }
        var name: String { "contactFormKey" }
        var schema: any OpenAPISchemaRepresentable {
            Contact.Schemas.ID().reference()
        }
    }
}
