import FeatherOpenAPI

extension Campaign.Parameters {
    struct UpdateMask: QueryParameterRepresentable {
        var openAPIIdentifier: String {
            "NewsletterCampaignUpdateMaskParameter"
        }
        var name: String { "updateMask" }
        var required: Bool { true }
        var description: String? { "Comma-separated list of fields to update." }
        var schema: any OpenAPISchemaRepresentable {
            Campaign.Schemas.UpdateMask().reference()
        }
    }
}
