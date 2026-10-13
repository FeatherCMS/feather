import FeatherOpenAPI

struct ContactFormSubmissionIdParameter: PathParameterRepresentable {
    var name: String { "contactFormSubmissionId" }
    var schema: any OpenAPISchemaRepresentable { ContactIdField().reference() }
}
