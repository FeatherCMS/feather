import FeatherOpenAPI

extension Contact.Field.Parameters {
    struct ID: PathParameterRepresentable {
        var openAPIIdentifier: String { "FormFieldIdParameter" }
        var name: String { "formFieldId" }
        var schema: any OpenAPISchemaRepresentable {
            Contact.Schemas.ID().reference()
        }
    }
}
