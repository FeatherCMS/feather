import FeatherOpenAPI

struct NewsletterCampaignUpdateMaskParameter: QueryParameterRepresentable {
    var name: String { "updateMask" }
    var required: Bool { true }
    var description: String? { "Comma-separated list of fields to update." }
    var schema: any OpenAPISchemaRepresentable {
        NewsletterCampaignUpdateMaskSchema().reference()
    }
}

struct NewsletterCampaignUpdateMaskSchema: StringSchemaRepresentable {
    var openAPIIdentifier: String { "NewsletterCampaignUpdateMask" }
    var example: String? { "key,name,fromEmail" }
}
