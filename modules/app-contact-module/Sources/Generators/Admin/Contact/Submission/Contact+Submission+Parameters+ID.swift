import FeatherOpenAPI

extension Contact.Submission.Parameters {
    struct ID: PathParameterRepresentable {
        var name: String { "contactFormSubmissionId" }
        var description: String? { "The ID of the contact form submission." }
        var schema: any OpenAPISchemaRepresentable {
            Contact.Schemas.ID().reference()
        }
    }
}
