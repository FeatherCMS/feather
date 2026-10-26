import FeatherOpenAPI

extension Issue.Parameters {
    struct UpdateMask: QueryParameterRepresentable {
        var openAPIIdentifier: String { "NewsletterIssueUpdateMaskParameter" }
        var name: String { "updateMask" }
        var required: Bool { true }
        var description: String? { "Comma-separated list of fields to update." }
        var schema: any OpenAPISchemaRepresentable {
            Issue.Schemas.UpdateMask().reference()
        }
    }
}
